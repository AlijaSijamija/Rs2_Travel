using AutoMapper;
using Travel.Models.Filters;
using Travel.Models.Section;
using Travel.Services.Database;
using Travel.Services.Interfaces;

namespace Travel.Services.Services
{
    public class SectionService : BaseCRUDService<Models.Section.Section, Database.Section, Models.Filters.SectionSearchObject, Models.Section.SectionReguest, Models.Section.SectionReguest, long>, ISectionService
    {
        public SectionService(AppDbContext context, IMapper mapper) : base(context, mapper)
        {

        }

        public override IQueryable<Database.Section> AddFilter(IQueryable<Database.Section> query, SectionSearchObject? search = null)
        {
            var filteredQuery = base.AddFilter(query, search);

            if (!string.IsNullOrWhiteSpace(search?.Name))
            {
                filteredQuery = filteredQuery.Where(x => x.Name.Contains(search.Name));
            }

            return filteredQuery;
        }
    }
}
