using Travel.Models.Filters;
using Travel.Models.Notification;
using Travel.Models.Section;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Travel.Services.Interfaces
{
    public interface ISectionService : ICRUDService<Models.Section.Section, Models.Filters.BaseSearchObject, Section, Section, long>
    {
    }
}
