using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Travel.Services.Interfaces;

namespace Travel.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class SectionController : BaseCRUDController<Models.Section.Section, Models.Filters.SectionSearchObject, Models.Section.SectionReguest, Models.Section.SectionReguest, long>
    {
        public SectionController(ILogger<BaseController<Models.Section.Section, Models.Filters.SectionSearchObject, long>> logger, ISectionService service) : base(logger, service)
        {

        }
    }
}
