using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Travel.Services.Interfaces;

namespace Travel.Controllers
{
    [Route("api/[controller]")]
    [ApiController]

    public class OrganizedTripController : BaseCRUDController<Models.OrganizedTrip.OrganizedTrip, Models.Filters.OrganizedTripSearchObject, Models.OrganizedTrip.OrganizedTripRequest, Models.OrganizedTrip.OrganizedTripRequest, long>
    {
        public OrganizedTripController(ILogger<BaseController<Models.OrganizedTrip.OrganizedTrip, Models.Filters.OrganizedTripSearchObject, long>> logger, IOrganizedTripService service) : base(logger, service)
        {

        }
    }
}
