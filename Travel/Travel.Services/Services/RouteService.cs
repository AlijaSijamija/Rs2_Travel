using AutoMapper;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Travel.Models.Agency;
using Travel.Models.Filters;
using Travel.Models.Route;
using Travel.Services.Database;
using Travel.Services.Interfaces;

namespace Travel.Services.Services
{
    public class RouteService : BaseCRUDService<Models.Route.Route, Database.Route, RouteSearchObject, RouteRequest, RouteRequest, long>, IRouteService
    {
        public RouteService(AppDbContext context, IMapper mapper) : base(context, mapper)
        {

        }

        public override IQueryable<Database.Route> AddFilter(IQueryable<Database.Route> query, RouteSearchObject? search = null)
        {
            var filteredQuery = base.AddFilter(query, search);

            if (search.FromCityId != null)
            {
                filteredQuery = filteredQuery.Where(x => x.FromCityId == search.FromCityId);
            }

            if (search.ToCityId != null)
            {
                filteredQuery = filteredQuery.Where(x => x.ToCityId == search.ToCityId);
            }

            return filteredQuery;
        }

        public override IQueryable<Database.Route> AddInclude(IQueryable<Database.Route> query, RouteSearchObject? search = null)
        {
            query = query.Include("ToCity").Include("FromCity").Include("Agency");
            return base.AddInclude(query, search);
        }
    }
}
