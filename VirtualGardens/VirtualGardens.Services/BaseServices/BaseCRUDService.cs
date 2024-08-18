using MapsterMapper;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using VirtualGardens.Models.SearchObjects;
using VirtualGardens.Services.Database;

namespace VirtualGardens.Services.BaseServices
{
    public abstract class BaseCRUDService<TModel, TSearch, TDbEntity, TInsert, TUpdate> : BaseService<TModel, TSearch, TDbEntity> where TModel : class where TSearch : BaseSearchObject where TDbEntity : class
    {
        public BaseCRUDService(_210011Context context, IMapper mapper) : base(context, mapper)
        {
        }

        public virtual TModel Insert(TInsert request)
        {
            TDbEntity entity = Mapper.Map<TDbEntity>(request);

            BeforeInsert(request, entity);

            Context.Add(entity);
            Context.SaveChanges();
            AfterInsert(request, entity);

            return Mapper.Map<TModel>(entity);
        }

        public virtual TModel Update(int id, TUpdate request)
        {
            var set = Context.Set<TDbEntity>();

            var entity = set.Find(id);

            Mapper.Map(request, entity);

            BeforeUpdate(request, entity);

            Context.SaveChanges();

            AfterUpdate(request, entity);

            return Mapper.Map<TModel>(entity);
        }

        public virtual void Delete(int id)
        {
            var entity = Context.Set<TDbEntity>().Find(id);

            if(entity == null)
            {
                throw new Exception("Nemoguće pronaći objekat sa poslanim id-om!");
            }

            Context.Remove(entity);
            Context.SaveChanges();
        }

        public virtual void BeforeInsert(TInsert request, TDbEntity entity) { }
        public virtual void AfterInsert(TInsert request, TDbEntity entity) { }
        public virtual void BeforeUpdate(TUpdate request, TDbEntity entity) { }
        public virtual void AfterUpdate(TUpdate request, TDbEntity entity) { }
    }
}
