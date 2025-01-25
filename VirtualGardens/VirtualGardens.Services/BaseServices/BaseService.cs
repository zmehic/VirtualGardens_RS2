using MapsterMapper;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using VirtualGardens.Models.SearchObjects;
using VirtualGardens.Services.BaseInterfaces;
using VirtualGardens.Services.Database;
using VirtualGardens.Models.HelperClasses;
using Microsoft.EntityFrameworkCore;
using System.Linq.Expressions;

namespace VirtualGardens.Services.BaseServices
{
    public abstract class BaseService<TModel, TSearch, TDbEntity> : IService<TModel, TSearch> where TSearch : BaseSearchObject where TDbEntity : class where TModel : class
    {
        public _210011Context context { get; set; }
        public IMapper mapper { get; set; }

        public BaseService(_210011Context _context, IMapper _mapper)
        {
            context = _context;
            mapper = _mapper;
        }

        public PagedResult<TModel> GetPaged(TSearch search)
        {
            List<TModel> result = new List<TModel>();
            var query = context.Set<TDbEntity>().AsQueryable();

            if(!string.IsNullOrEmpty(search?.IncludeTables) )
            {
                query=ApplyIncludes(query, search.IncludeTables);
            }

            query=AddFilter(search,query);

            int count = query.Count();

            if(!string.IsNullOrEmpty(search?.OrderBy) && !string.IsNullOrEmpty(search?.SortDirection))
            {
                query=ApplySorting(query, search.OrderBy, search.SortDirection);
            }

            if(search?.Page.HasValue == true && search.PageSize.HasValue == true)
            {
                query = query.Skip((search.Page.Value-1)*search.PageSize.Value).Take(search.PageSize.Value);
            }

            var list = query.ToList();
            result = mapper.Map(list, result);

            PagedResult<TModel> pagedResult = new PagedResult<TModel>();
            pagedResult.ResultList = result;
            pagedResult.Count = count;

            return pagedResult;
        }

        public TModel GetById(int id)
        {
            var entity = context.Set<TDbEntity>().Find(id);

            if (entity != null)
            {
                return mapper.Map<TModel>(entity);
            }
            else
                return null;
        }

        public virtual IQueryable<TDbEntity> AddFilter(TSearch search, IQueryable<TDbEntity> query)
        {
            return query;
        }

        private IQueryable<TDbEntity> ApplyIncludes(IQueryable<TDbEntity> query, string includes)
        {
            try
            {
                var tableIncludes = includes.Split(',');
                query = tableIncludes.Aggregate(query, (current,inc)=> current.Include(inc));
            }
            catch (Exception)
            {
                throw new Exception("Pogrešna include lista!");
            }

            return query;
        }

        public IQueryable<TDbEntity> ApplySorting(IQueryable<TDbEntity> query, string sortColumn, string sortDirection)
        {
            var entityType = typeof(TDbEntity);
            var property = entityType.GetProperty(sortColumn);
            if (property != null)
            {
                var parameter = Expression.Parameter(entityType, "x");
                var propertyAccess = Expression.MakeMemberAccess(parameter, property);
                var orderByExpression = Expression.Lambda(propertyAccess, parameter);

                string methodName = "";

                var sortDirectionToLower = sortDirection.ToLower();

                methodName = sortDirectionToLower == "desc" || sortDirectionToLower == "descending" ? "OrderByDescending" : sortDirectionToLower == "asc" || sortDirectionToLower == "ascending" ? "OrderBy" : "";
            
                if(methodName == "")
                {
                    return query;
                }

                var resultExpression = Expression.Call(typeof(Queryable), methodName, new Type[] { entityType, property.PropertyType }, query.Expression, Expression.Quote(orderByExpression));

                return query.Provider.CreateQuery<TDbEntity>(resultExpression);
            }
            else
            {
                return query;
            }
        }
    }
}
