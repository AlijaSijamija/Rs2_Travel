using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Travel.Services.Interfaces;

namespace Travel.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class TripServiceController : BaseCRUDController<Travel.Models.TripService.TripService, Travel.Models.Filters.BaseSearchObject, Travel.Models.TripService.TripService, Travel.Models.TripService.TripService, long>
    {
        public TripServiceController(ILogger<BaseController<Travel.Models.TripService.TripService, Travel.Models.Filters.BaseSearchObject, long>> logger, ITripServiceService service) : base(logger, service)
        {

        }
    }
}
