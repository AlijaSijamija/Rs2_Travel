using AutoMapper;
using Travel.Services.Database;
using Travel.Services.Interfaces;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Travel.Models.Filters;

namespace Travel.Services.Services
{
    public class CityService : BaseCRUDService<Models.City.City, Database.City, Models.Filters.CitySearchObject, Models.City.CityReguest, Models.City.CityReguest, long>, ICityService
    {
        public CityService(AppDbContext context, IMapper mapper) : base(context, mapper)
        {

        }

        public override IQueryable<Database.City> AddFilter(IQueryable<Database.City> query, CitySearchObject? search = null)
        {
            var filteredQuery = base.AddFilter(query, search);

            if (!string.IsNullOrWhiteSpace(search?.Name))
            {
                filteredQuery = filteredQuery.Where(x => x.Name.Contains(search.Name));
            }

            return filteredQuery;
        }
    }
}
