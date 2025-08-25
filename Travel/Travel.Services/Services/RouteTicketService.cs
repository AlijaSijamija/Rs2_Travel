using AutoMapper;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Travel.Models.Enums;
using Travel.Models.Filters;
using Travel.Models.Route;
using Travel.Models.RouteTicket;
using Travel.Services.Database;
using Travel.Services.Interfaces;
using static Microsoft.EntityFrameworkCore.DbLoggerCategory;

namespace Travel.Services.Services
{
    public class RouteTicketService : BaseCRUDService<Models.RouteTicket.RouteTicket, Database.RouteTicket, RouteTicketSearchObject, RouteTicketRequest, RouteTicketRequest, long>, IRouteTicketService
    {
        public RouteTicketService(AppDbContext context, IMapper mapper) : base(context, mapper)
        {

        }

        public override async Task BeforeInsert(Database.RouteTicket entity, Models.RouteTicket.RouteTicketRequest insert)
        {
            var trip = _context.Routes.FirstOrDefault(t => t.Id == insert.RouteId);
            entity.AgencyId = trip.AgencyId;
            trip.AvailableSeats = trip.AvailableSeats - (insert.NumberOfAdultPassengers + insert.NumberOfChildPassengers);
            var list = new List<TicketSeat>();

            if (insert.SeatNumbers != null)
            {
                foreach (var item in insert.SeatNumbers)
                {
                    var seatNumber = new TicketSeat
                    {
                        SeatNumber = item.SeatNumber,
                        PassengerName = item.PassengerName
                    };
                    list.Add(seatNumber);
                }
            }

            entity.TicketSeats = list;
        }

        public override IQueryable<Database.RouteTicket> AddFilter(IQueryable<Database.RouteTicket> query, RouteTicketSearchObject? search = null)
        {
            var filteredQuery = base.AddFilter(query, search);

            if (search.RouteId != null)
            {
                filteredQuery = filteredQuery.Where(x => x.RouteId == search.RouteId);
            }

            if (!string.IsNullOrWhiteSpace(search.PassengerId))
            {
                filteredQuery = filteredQuery.Where(x => x.PassengerId == search.PassengerId);
            }

            return filteredQuery;
        }

        public override IQueryable<Database.RouteTicket> AddInclude(IQueryable<Database.RouteTicket> query, RouteTicketSearchObject? search = null)
        {
            query = query.Include("Route").Include("Passenger").Include("SavedRoutes").Include("TicketSeats");
            return base.AddInclude(query, search);
        }

        public List<AgencyProfitReport> GetProfitByAgency(AgencyProfitSearchObject searchObject)
        {
            var tickets = _context.RouteTickets.Include(r => r.Agency).Include(r => r.Route)
                .Where(rt => rt.CreatedAt.Year == searchObject.Year)
                .ToList();

            if (searchObject.BusTypes != null && searchObject.BusTypes.Any())
                tickets = tickets.Where(rt => searchObject.BusTypes.Contains((int)rt.Route.BusType)).ToList();

            var agencyGroups = tickets.GroupBy(rt => new
            {
                rt.AgencyId,
                AgencyName = rt.Agency.Name,
                rt.Route?.BusType
            });

            var result = new List<AgencyProfitReport>();

            foreach (var group in agencyGroups)
            {
                int ticketsSold = group.Count();
                double revenue = group.Sum(rt => rt.Price);
                double cost = CalculateRouteCost(group.Key.BusType, GetSeatsForBusType(group.Key?.BusType));// cost po sjedistu
                double profit = revenue - cost;

                result.Add(new AgencyProfitReport
                {
                    AgencyId = group.Key.AgencyId,
                    AgencyName = group.Key.AgencyName,
                    TicketsSold = ticketsSold,
                    TotalRevenue = revenue,
                    TotalCost = cost,
                    TotalProfit = profit,
                    BusType = group.Key.BusType ?? BusType.Midi,
                });
            }

            return result;
        }


        public List<RouteProfitReport> GetProfitByRouteForAgency(AgencyProfitSearchObject searchObject)
        {
            var tickets = _context.RouteTickets.Include(r => r.Agency).Include(r => r.Route).ThenInclude(r => r.FromCity)
                .Include(r => r.Route).ThenInclude(r => r.ToCity)
                .Where(rt => rt.AgencyId == searchObject.AgencyId && rt.CreatedAt.Year == searchObject.Year)
                .ToList();
            if (searchObject.BusTypes != null && searchObject.BusTypes.Any())
                tickets = tickets.Where(rt => searchObject.BusTypes.Contains((int)rt.Route.BusType)).ToList();

            var routeGroups = tickets.GroupBy(rt => new
            {
                rt.RouteId,
                FromCity = rt.Route.FromCity.Name,
                ToCity = rt.Route.ToCity.Name,
                BusType = rt.Route.BusType
            });

            var result = new List<RouteProfitReport>();

            foreach (var group in routeGroups)
            {
                int ticketsSold = group.Count();
                double revenue = group.Sum(rt => rt.Price);
                double cost = CalculateRouteCost(group.Key.BusType,GetSeatsForBusType( group.Key?.BusType));
                double profit = revenue - cost;

                result.Add(new RouteProfitReport
                {
                    RouteId = group.Key.RouteId,
                    RouteName = $"{group.Key.FromCity} - {group.Key.ToCity}",
                    BusType = group.Key.BusType,
                    TicketsSold = ticketsSold,
                    TotalRevenue = revenue,
                    TotalCost = cost,
                    TotalProfit = profit
                });
            }

            return result;
        }

        public List<PaymentDataPDF> GeneratePaymentData(int year, long? agencyId, List<int>? busTypes = null)
        {
            // Dohvat podataka iz baze
            var query = _context.RouteTickets
                .Include(r => r.Route).ThenInclude(r => r.FromCity)
                .Include(r => r.Route).ThenInclude(r => r.ToCity)
                .Include(r => r.Agency)
                .Where(rt => rt.CreatedAt.Year == year);

            if (agencyId != null)
                query = query.Where(rt => rt.AgencyId == agencyId);

            if (busTypes != null && busTypes.Any())
                query = query.Where(rt => busTypes.Contains((int)rt.Route.BusType));

     
            var ticketsList = query.ToList();

            if (agencyId != null)
            {
                // Grupiranje po rutama za odabranu agenciju
                return ticketsList
                    .GroupBy(rt => new
                    {
                        FromCityName = rt.Route?.FromCity?.Name ?? "Unknown",
                        ToCityName = rt.Route?.ToCity?.Name ?? "Unknown",
                        BusType = rt.Route?.BusType ?? BusType.Midi
                    })
                    .Select(g =>
                    {
                        var ticketsSold = g.Count();
                        var busType = g.Key.BusType;
                        var income = g.Sum(rt => rt.Price);
                        var expense = CalculateRouteCost(busType, GetSeatsForBusType( g.Key.BusType));
                        return new PaymentDataPDF
                        {
                            Name = $"{g.Key.FromCityName} - {g.Key.ToCityName} ({busType})",
                            BusType = busType,
                            TicketsSold = ticketsSold,
                            Income = income,
                            Expense = expense,
                            Profit = income - expense
                        };
                    })
                    .ToList();
            }
            else
            {
                // Grupiranje po agencijama i bus tipovima
                return ticketsList
                    .GroupBy(rt => new
                    {
                        AgencyName = rt.Agency?.Name ?? "Unknown",
                        BusType = rt.Route?.BusType ?? BusType.Midi
                    })
                    .Select(g =>
                    {
                        var ticketsSold = g.Count();
                        var busType = g.Key.BusType;
                        var income = g.Sum(rt => rt.Price);
                        var expense = CalculateRouteCost(busType, GetSeatsForBusType( g.Key.BusType));
                        return new PaymentDataPDF
                        {
                            Name = $"{g.Key.AgencyName} ({busType})",
                            TicketsSold = ticketsSold,
                            BusType = busType,
                            Income = income,
                            Expense = expense,
                            Profit = income - expense
                        };
                    })
                    .ToList();
            }
        }

        public List<Models.Route.Route> GetRouteTickets(string passengerId)
        {
            var routes = _context.Routes.Include(o => o.RouteTickets).ThenInclude(o => o.Passenger).Include(o => o.Agency)
                .Include(o => o.FromCity).Include(o => o.ToCity).ToList();
            if (!string.IsNullOrWhiteSpace(passengerId))
            {
                routes = routes.Where(o => o.RouteTickets.Any(t => t.PassengerId == passengerId)).ToList();
            }

            return _mapper.Map<List<Models.Route.Route>>(routes);
        }

        public List<Models.TicketSeat.TicketSeat> GetReservedSeats(long routeId)
        {
            var reservedSeats = _context.TicketSeats
                .Include(t => t.RouteTicket)
                .Where(s => s.RouteTicket != null && s.RouteTicket.RouteId == routeId)
                .ToList();

            return _mapper.Map<List<Models.TicketSeat.TicketSeat>>(reservedSeats);
        }

        public double CalculateRouteCost(BusType? busType, int seatsSold)
        {
            double costPerSeat = busType switch
            {
                BusType.Mini => 5,      // BAM po sjedistu, npr. gorivo+odrzavanje
                BusType.Midi => 7,
                BusType.Standard => 10,
                BusType.Luxury => 15,
                _ => 0
            };

            return costPerSeat * seatsSold;
        }

        public static int GetSeatsForBusType(BusType? busType)
        {
            switch (busType)
            {
                case BusType.Mini:
                    return 15; // prosjek 10-20
                case BusType.Midi:
                    return 28; // prosjek 21-35
                case BusType.Standard:
                    return 43; // prosjek 36-50
                case BusType.Luxury:
                    return 55; // npr. 51+
                default:
                    return 15;
            }
        }


    }
}
