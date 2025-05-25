using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Travel.Services.Interfaces;

namespace Travel.Controllers
{
    [Route("api/[controller]")]
    [ApiController]

    public class AgencyController : BaseCRUDController<Models.Agency.Agency, Models.Filters.AgencySearchObject, Models.Agency.AgencyRequest, Models.Agency.AgencyRequest, long>
    {
        public AgencyController(ILogger<BaseController<Models.Agency.Agency, Models.Filters.AgencySearchObject, long>> logger, IAgencyService service) : base(logger, service)
        {

        }
    }
}
