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
            var saveRouteDb = new Database.SavedRoutes() { PassengerId = saveRoute.PassengerId, RouteId = saveRoute.RouteId
            ,ValidFrom=saveRoute.ValidFrom, ValidTo=saveRoute.ValidTo};
            _context.SavedRoutes.Add(saveRouteDb);
            _context.SaveChanges();
        }

        public void RemoveSavedRoute(SaveRoute saveRoute)
        {
            var savedRouteDb = _context.SavedRoutes.Where(s => s.PassengerId == saveRoute.PassengerId && s.RouteId == saveRoute.RouteId).FirstOrDefault();
            _context.SavedRoutes.Remove(savedRouteDb);
            _context.SaveChanges();
        }

        public async Task<List<Models.Route.Route>> GetSavedRoutes(string passengerId)
        {
            var savedRoutes = await _context.SavedRoutes
                .Include(sr => sr.Route)
                    .ThenInclude(r => r.FromCity)
                .Include(sr => sr.Route)
                    .ThenInclude(r => r.ToCity)
                .Include(sr => sr.Route)
                    .ThenInclude(r => r.Agency)
                .Where(sr => sr.PassengerId == passengerId)
                .Select(sr => new Models.Route.Route
                {
                    Id = sr.Route.Id,
                    NumberOfSeats = sr.Route.NumberOfSeats,
                    AvailableSeats = sr.Route.AvailableSeats,
                    AdultPrice = sr.Route.AdultPrice,
                    ChildPrice = sr.Route.ChildPrice,
                    FromCityId = sr.Route.FromCityId,
                    FromCity =  _mapper.Map<Models.City.City>(sr.Route.FromCity),
                    ToCityId = sr.Route.ToCityId,
                    ToCity = _mapper.Map<Models.City.City>(sr.Route.ToCity),
                    TravelTime = sr.Route.TravelTime,
                    DepartureTime = sr.Route.DepartureTime,
                    ArrivalTime = sr.Route.ArrivalTime,
                    ValidFrom = sr.ValidFrom,
                    ValidTo = sr.ValidTo,
                    AgencyId = sr.Route.AgencyId,
                    Agency = _mapper.Map<Models.Agency.Agency>(sr.Route.Agency)
                })
                .ToListAsync();

            return savedRoutes;
        }

    }
}
