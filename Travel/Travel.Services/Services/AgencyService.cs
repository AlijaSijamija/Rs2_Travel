using AutoMapper;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Travel.Models.Agency;
using Travel.Models.Filters;
using Travel.Models.Notification;
using Travel.Services.Database;
using Travel.Services.Interfaces;

namespace Travel.Services.Services
{
    public class AgencyService : BaseCRUDService<Models.Agency.Agency, Database.Agency, AgencySearchObject, AgencyRequest, AgencyRequest, long>, IAgencyService
    {
        public AgencyService(AppDbContext context, IMapper mapper) : base(context, mapper)
        {

        }

        public override IQueryable<Database.Agency> AddFilter(IQueryable<Database.Agency> query, AgencySearchObject? search = null)
        {
            var filteredQuery = base.AddFilter(query, search);

            if (!string.IsNullOrWhiteSpace(search?.Name))
            {
                filteredQuery = filteredQuery.Where(x => x.Name.Contains(search.Name));
            }

            return filteredQuery;
        }

        public override IQueryable<Database.Agency> AddInclude(IQueryable<Database.Agency> query, AgencySearchObject? search = null)
        {
            query = query.Include("City").Include("Admin").Include("AgencyAvailableBuses");
            return base.AddInclude(query, search);
        }

        public override async Task BeforeInsert(Database.Agency entity, Models.Agency.AgencyRequest insert)
        {
            if (insert.AvailableBuses != null && insert.AvailableBuses.Any())
            {
                entity.AgencyAvailableBuses = insert.AvailableBuses
                    .Select(bus => new Database.AgencyAvailableBus
                    {
                        BusType = bus 
                    })
                    .ToList();
            }
        }


        public override async Task BeforeUpdate(Database.Agency entity, Models.Agency.AgencyRequest update)
        {
            await this.ManageAvailableBuses(entity.Id, update);
        }

        private async Task ManageAvailableBuses(long agencyId, Models.Agency.AgencyRequest update)
        {
            var entity = await _context.Agencies
                .Include(a => a.AgencyAvailableBuses)
                .FirstOrDefaultAsync(a => a.Id == agencyId);

            if (entity == null) return;

            var busesToRemove = entity.AgencyAvailableBuses
                .Where(ab => !update.AvailableBuses.Any(busType => ab.BusType == busType))
                .ToList();

            if (busesToRemove.Any())
            {
                busesToRemove.ForEach(bus =>
                {
                    entity.AgencyAvailableBuses.Remove(bus);
                });
            }

            var busesToAdd = update.AvailableBuses
                .Where(busType => !entity.AgencyAvailableBuses.Any(b => busType == b.BusType))
                .ToList();

            if (busesToAdd.Any())
            {
                foreach (var bus in busesToAdd)
                {
                    entity.AgencyAvailableBuses.Add(new Database.AgencyAvailableBus
                    {
                        BusType = bus, 
                    });
                }
            }

            await _context.SaveChangesAsync();
        }

    }
}
