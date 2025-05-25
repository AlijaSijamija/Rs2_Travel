using AutoMapper;
using Travel.Services.Database;
using Travel.Services.Interfaces;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Travel.Services.Services
{
    public class CityService : BaseCRUDService<Models.City.City, Database.City, Models.Filters.BaseSearchObject, Models.City.City, Models.City.City, long>, ICityService
    {
        public CityService(AppDbContext context, IMapper mapper) : base(context, mapper)
        {

        }
    }
}
