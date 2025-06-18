using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
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
    }
}
