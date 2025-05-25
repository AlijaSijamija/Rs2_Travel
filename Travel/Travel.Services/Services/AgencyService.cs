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
            query = query.Include("City").Include("Admin");
            return base.AddInclude(query, search);
        }
    }
}
