using AutoMapper;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Travel.Models.Filters;
using Travel.Models.OrganizedTrip;
using Travel.Models.Route;
using Travel.Services.Database;
using Travel.Services.Interfaces;

namespace Travel.Services.Services
{

    public class OrganizedTripService : BaseCRUDService<Models.OrganizedTrip.OrganizedTrip, Database.OrganizedTrip, OrganizedTripSearchObject, OrganizedTripRequest, OrganizedTripRequest, long>, IOrganizedTripService
    {
        public OrganizedTripService(AppDbContext context, IMapper mapper) : base(context, mapper)
        {

        }

        public override IQueryable<Database.OrganizedTrip> AddFilter(IQueryable<Database.OrganizedTrip> query, OrganizedTripSearchObject? search = null)
        {
            var filteredQuery = base.AddFilter(query, search);

            if (search.AgencyId != null)
            {
                filteredQuery = filteredQuery.Where(x => x.AgencyId == search.AgencyId);
            }

            if (search.Future.HasValue && search.Future.Value)
            {
                filteredQuery = filteredQuery.Where(x => x.StartDate > DateTime.Now);
            }

            return filteredQuery;
        }

        public override IQueryable<Database.OrganizedTrip> AddInclude(IQueryable<Database.OrganizedTrip> query, OrganizedTripSearchObject? search = null)
        {
            query = query.Include("Agency").Include("IncludedServices");
            return base.AddInclude(query, search);
        }

        public override async Task BeforeInsert(Database.OrganizedTrip entity, Models.OrganizedTrip.OrganizedTripRequest insert)
        {
            if (insert.IncludedServicesIds != null && insert.IncludedServicesIds.Any())
            {
                var includedServices = _context.TripServices.Select(u => u).Where(u => insert.IncludedServicesIds.Contains(u.Id)).ToList();
                entity.IncludedServices = includedServices;
            }
        }

        public override async Task BeforeUpdate(Database.OrganizedTrip entity, Models.OrganizedTrip.OrganizedTripRequest update)
        {
            await this.ManageServices(entity.Id, update);
        }

        private async Task ManageServices(long tripId, Models.OrganizedTrip.OrganizedTripRequest update)
        {
            var entity = await _context.OrganizedTrips
                .Include(r => r.IncludedServices)
                .FirstOrDefaultAsync(r => r.Id == tripId);

            var servicesToRemove = entity.IncludedServices
            .Where(i => !update.IncludedServicesIds.Any(s => s == i.Id)).ToList();

            if (servicesToRemove.Any())
            {
                servicesToRemove.ForEach(service =>
                {
                    entity.IncludedServices.Remove(service);
                });
            }

            var servicesToAdd = update.IncludedServicesIds.Where(i => !entity.IncludedServices.Any(s => s.Id == i));

            if (servicesToAdd.Any())
            {
                var includedServices = _context.TripServices.Select(u => u).Where(u => servicesToAdd.Contains(u.Id)).ToList();
                foreach (var service in includedServices)
                {
                    entity.IncludedServices.Add(service);
                }
            }

        }
    }

}
