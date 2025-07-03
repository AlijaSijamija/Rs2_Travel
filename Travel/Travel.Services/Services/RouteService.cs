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

        public override async Task BeforeInsert(Database.Route entity, Models.Route.RouteRequest insert)
        {
            entity.AvailableSeats = insert.NumberOfSeats;
        }

        public override IQueryable<Database.Route> AddFilter(IQueryable<Database.Route> query, RouteSearchObject? search = null)
        {
            var filteredQuery = base.AddFilter(query, search);
            var test= filteredQuery.ToList();
            if (search.FromCityId != null)
            {
                filteredQuery = filteredQuery.Where(x => x.FromCityId == search.FromCityId);
            }

            if (search.ToCityId != null)
            {
                filteredQuery = filteredQuery.Where(x => x.ToCityId == search.ToCityId);
            }

            if (search.ValidFrom.HasValue)
            {
                filteredQuery = filteredQuery.Where(x => x.ValidFrom <= search.ValidFrom.Value);
            }

            if (search.ValidTo.HasValue)
            {
                filteredQuery = filteredQuery.Where(x => x.ValidTo >= search.ValidTo.Value);
            }

             test = filteredQuery.ToList();
            return filteredQuery;
        }

        public override IQueryable<Database.Route> AddInclude(IQueryable<Database.Route> query, RouteSearchObject? search = null)
        {
            query = query.Include("ToCity").Include("FromCity").Include("Agency");
            return base.AddInclude(query, search);
        }

        public void SaveRoute(SaveRoute saveRoute)
        {
            var saveRouteDb = new Database.SavedRoutes() { PassengerId = saveRoute.PassengerId, RouteId = saveRoute.RouteId };
            _context.SavedRoutes.Add(saveRouteDb);
            _context.SaveChanges();
        }

        public void RemoveSavedRoute(SaveRoute saveRoute)
        {
            var savedRouteDb = _context.SavedRoutes.Where(s => s.PassengerId == saveRoute.PassengerId && s.RouteId == saveRoute.RouteId).FirstOrDefault();
            _context.SavedRoutes.Remove(savedRouteDb);
            _context.SaveChanges();
        }

        public List<Models.Route.Route> GetSavedRoutes(string passengerId)
        {
            var savedRoutes = _context.Routes.Include(s=>s.SavedRoutes).Include(s=>s.Agency).Include(s=>s.FromCity).Include(s=>s.ToCity).Where(s => s.SavedRoutes.Any(sr=>sr.PassengerId==passengerId)).ToList();
            return _mapper.Map<List<Models.Route.Route>>(savedRoutes);
        }
    }
}
