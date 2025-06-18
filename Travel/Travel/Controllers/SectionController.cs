using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Travel.Services.Interfaces;

namespace Travel.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class SectionController : BaseCRUDController<Models.Section.Section, Models.Filters.BaseSearchObject, Models.Section.Section, Models.Section.Section, long>
    {
        public SectionController(ILogger<BaseController<Models.Section.Section, Models.Filters.BaseSearchObject, long>> logger, ISectionService service) : base(logger, service)
        {
        }
    }
}
