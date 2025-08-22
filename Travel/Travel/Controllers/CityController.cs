using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Travel.Services.Interfaces;

namespace Travel.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class CityController : BaseCRUDController<Travel.Models.City.City, Travel.Models.Filters.CitySearchObject, Travel.Models.City.CityReguest, Travel.Models.City.CityReguest, long>
    {
        public CityController(ILogger<BaseController<Travel.Models.City.City, Travel.Models.Filters.CitySearchObject, long>> logger, ICityService service) : base(logger, service)
        {

        }
    }
}
