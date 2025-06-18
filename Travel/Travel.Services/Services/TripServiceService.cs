using AutoMapper;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Travel.Services.Database;
using Travel.Services.Interfaces;

namespace Travel.Services.Services
{
    public class TripServiceService : BaseCRUDService<Models.TripService.TripService, Database.TripService, Models.Filters.BaseSearchObject, Models.TripService.TripService, Models.TripService.TripService, long>, ITripServiceService
    {
        public TripServiceService(AppDbContext context, IMapper mapper) : base(context, mapper)
        {

        }
    }
}
