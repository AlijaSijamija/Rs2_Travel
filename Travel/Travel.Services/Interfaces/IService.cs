using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Travel.Models.Filters;

namespace Travel.Services.Interfaces
{
    public interface IService<T, TSearch, TId> where TSearch : class
    {
        Task<PagedResult<T>> Get(TSearch search = null);
        Task<T> GetById(TId id);
        Task Delete(TId id);
    }
}
