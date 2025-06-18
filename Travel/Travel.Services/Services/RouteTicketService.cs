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
            query = query.Include("Route").Include("Passenger");
            return base.AddInclude(query, search);
        }

        public List<AgencyProfitReport> GetProfitByAgency(AgencyProfitSearchObject searchObject)
        {
            var query = _context.RouteTickets
                .Where(rt=>searchObject.Year == rt.CreatedAt.Year)
                .GroupBy(rt => new { rt.AgencyId, rt.Agency.Name })
                .Select(g => new AgencyProfitReport
                {
                    AgencyId = g.Key.AgencyId,
                    AgencyName = g.Key.Name,
                    TotalProfit = g.Sum(rt => rt.Price)
                });

            return  query.ToList();
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

            return  query.ToList();
        }

    }
}
