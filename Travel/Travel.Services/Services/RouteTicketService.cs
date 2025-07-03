using AutoMapper;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Travel.Models.Filters;
using Travel.Models.Route;
using Travel.Models.RouteTicket;
using Travel.Services.Database;
using Travel.Services.Interfaces;

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
            var query = _context.RouteTickets
                .Where(rt => searchObject.Year == rt.CreatedAt.Year)
                .GroupBy(rt => new { rt.AgencyId, rt.Agency.Name })
                .Select(g => new AgencyProfitReport
                {
                    AgencyId = g.Key.AgencyId,
                    AgencyName = g.Key.Name,
                    TotalProfit = g.Sum(rt => rt.Price)
                });

            return query.ToList();
        }

        public List<RouteProfitReport> GetProfitByRouteForAgency(AgencyProfitSearchObject searchObject)
        {
            var query = _context.RouteTickets
                .Where(rt => rt.AgencyId == searchObject.AgencyId && searchObject.Year == rt.CreatedAt.Year)
                .GroupBy(rt => new
                {
                    rt.RouteId,
                    CityFromName = rt.Route.FromCity.Name,
                    CityToName = rt.Route.ToCity.Name
                })
                .Select(g => new RouteProfitReport
                {
                    RouteId = g.Key.RouteId,
                    RouteName = g.Key.CityFromName + " - " + g.Key.CityToName,
                    TotalProfit = g.Sum(rt => rt.Price)
                });

            return query.ToList();
        }

        public List<PaymentDataPDF> GeneratePaymentData(int year, long? agencyId)
        {
            var query = _context.RouteTickets
                .Include(r=>r.Route).ThenInclude(r=>r.FromCity)
                .Include(r=>r.Route).ThenInclude(r=>r.ToCity)
                .Where(rt => rt.CreatedAt.Year == year);

            if (agencyId != null)
            {
                query = query.Where(rt => rt.AgencyId == agencyId);

                return query
                  .GroupBy(rt => new
                  {
                      FromCityName = rt.Route.FromCity.Name,
                      ToCityName = rt.Route.ToCity.Name
                                      })
                    .Select(g => new PaymentDataPDF
                    {
                        Name = g.Key.FromCityName + " - " + g.Key.ToCityName,
                        Price = g.Sum(rt => rt.Price)
                    })
                    .ToList();

            }
            else
            {
                return query
                    .GroupBy(rt => rt.Agency.Name)
                    .Select(g => new PaymentDataPDF
                    {
                        Name = g.Key,
                        Price = g.Sum(rt => rt.Price)
                    })
                    .ToList();
            }
        }


        public List<Models.Route.Route> GetRouteTickets(string passengerId)
        {
            var routes = _context.Routes.Include(o => o.RouteTickets).ThenInclude(o => o.Passenger).Include(o => o.Agency)
                .Include(o=>o.FromCity).Include(o=>o.ToCity).ToList();
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
    }
}
