using Travel.Models.City;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Travel.Services.Interfaces
{
    public interface ICityService : ICRUDService<Models.City.City, Models.Filters.BaseSearchObject, City, City, long>
    {
    }
}
