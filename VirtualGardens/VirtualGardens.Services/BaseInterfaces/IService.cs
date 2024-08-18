using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using VirtualGardens.Models.HelperClasses;
using VirtualGardens.Models.SearchObjects;

namespace VirtualGardens.Services.BaseInterfaces
{
    public interface IService<TModel, TSearch> where TSearch : BaseSearchObject
    {
        public PagedResult<TModel> GetPaged(TSearch search);
        public TModel GetById(int id);
    }
}
