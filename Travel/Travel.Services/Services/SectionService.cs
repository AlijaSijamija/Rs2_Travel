using AutoMapper;
using Travel.Models.Section;
using Travel.Services.Database;
using Travel.Services.Interfaces;

namespace Travel.Services.Services
{
    public class SectionService : BaseCRUDService<Models.Section.Section, Database.Section, Models.Filters.BaseSearchObject, Models.Section.Section, Models.Section.Section, long>, ISectionService
    {
        public SectionService(AppDbContext context, IMapper mapper) : base(context, mapper)
        {

        }
    }


}
