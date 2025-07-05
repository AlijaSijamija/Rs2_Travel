using AutoMapper;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Travel.Models.Filters;
using Travel.Services.Database;
using Travel.Services.Interfaces;

namespace Travel.Services.Services
{
    public class BaseService<T, TDb, TSearch, TId> : IService<T, TSearch, TId> where TDb : class where T : class where TSearch : BaseSearchObject
    {
        protected AppDbContext _context;
        protected IMapper _mapper { get; set; }
        public BaseService(AppDbContext context, IMapper mapper)
        {
            _context = context;
            _mapper = mapper;
        }

        public virtual async Task<PagedResult<T>> Get(TSearch? search = null)
        {
            var query = _context.Set<TDb>().AsQueryable();

            PagedResult<T> result = new PagedResult<T>();



            query = AddInclude(query, search);
            query = AddFilter(query, search);

            result.Count = await query.CountAsync();

            if (search?.Page.HasValue == true && search?.PageSize.HasValue == true)
            {
                var skip = (search.Page.Value - 1) * search.PageSize.Value;
                query = query.Skip(skip).Take(search.PageSize.Value);
            }


            var list = await query.ToListAsync();


            var tmp = _mapper.Map<List<T>>(list);
            result.Result = tmp;
            return result;
        }

        public virtual IQueryable<TDb> AddInclude(IQueryable<TDb> query, TSearch? search = null)
        {
            return query;
        }

        public virtual IQueryable<TDb> AddFilter(IQueryable<TDb> query, TSearch? search = null)
        {
            return query;
        }

        public virtual async Task<T> GetById(TId id)
        {
            var entity = await _context.Set<TDb>().FindAsync(id);
            return _mapper.Map<T>(entity);
        }

        public virtual async Task Delete(TId id)
        {
            var entity = await _context.Set<TDb>().FindAsync(id);

            _context.Remove(entity);
            await _context.SaveChangesAsync();
        }
    }
}
