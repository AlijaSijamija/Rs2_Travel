using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Travel.Models.Route;
using Travel.Services.Interfaces;

namespace Travel.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class RouteController : BaseCRUDController<Models.Route.Route, Models.Filters.RouteSearchObject, Models.Route.RouteRequest, Models.Route.RouteRequest, long>
    {
        public RouteController(ILogger<BaseController<Models.Route.Route, Models.Filters.RouteSearchObject, long>> logger, IRouteService service) : base(logger, service)
        {

        }

        [HttpPost("save-route")]
        public virtual void SaveRoute([FromQuery] SaveRoute request)
        {
            (_service as IRouteService).SaveRoute(request);
        }

        [HttpPut("remove-saved-route")]
        public virtual void RemoveSavedRoute([FromQuery] SaveRoute request)
        {
            (_service as IRouteService).RemoveSavedRoute(request);
        }

        [HttpPut("saved-routes/{passengerId}")]
        public virtual async  Task<List<Models.Route.Route>> GetSavedRoutes([FromRoute] string passengerId)
        {
          return  await (_service as IRouteService).GetSavedRoutes(passengerId);
        }
    }
}
