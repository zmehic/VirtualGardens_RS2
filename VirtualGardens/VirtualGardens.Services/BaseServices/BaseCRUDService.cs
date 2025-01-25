using MapsterMapper;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using VirtualGardens.Models.SearchObjects;
using VirtualGardens.Services.BaseInterfaces;
using VirtualGardens.Services.Database;

namespace VirtualGardens.Services.BaseServices
{
    public abstract class BaseCRUDService<TModel, TSearch, TDbEntity, TInsert, TUpdate> : BaseService<TModel, TSearch, TDbEntity> where TModel : class where TSearch : BaseSearchObject where TDbEntity : class
    {
        public BaseCRUDService(_210011Context _context, IMapper _mapper) : base(_context, _mapper)
        {
        }

        public virtual TModel Insert(TInsert request)
        {
            TDbEntity entity = mapper.Map<TDbEntity>(request);

            BeforeInsert(request, entity);

            context.Add(entity);
            context.SaveChanges();
            AfterInsert(request, entity);

            return mapper.Map<TModel>(entity);
        }

        public virtual TModel Update(int id, TUpdate request)
        {
            var set = context.Set<TDbEntity>();
            var entity = set.Find(id);

            mapper.Map(request, entity);

            BeforeUpdate(request, entity);

            context.SaveChanges();

            AfterUpdate(request, entity);

            return mapper.Map<TModel>(entity);
        }

        public virtual void Delete(int id)
        {
            var entity = context.Set<TDbEntity>().Find(id);

            if(entity == null)
            {
                throw new Exception("Nemoguće pronaći objekat sa poslanim id-om!");
            }

            BeforeDelete(id, entity);

            if(entity is ISoftDeletable softDeletableEntity)
            {
                softDeletableEntity.IsDeleted = true;
                softDeletableEntity.VrijemeBrisanja = DateTime.Now;

                context.Update(entity);
            }
            else
            {
                context.Remove(entity);
            }

            context.SaveChanges();

            AfterDelete(id, entity);
        }

        public virtual void BeforeInsert(TInsert request, TDbEntity entity) { }
        public virtual void AfterInsert(TInsert request, TDbEntity entity) { }
        public virtual void BeforeUpdate(TUpdate request, TDbEntity entity) { }
        public virtual void AfterUpdate(TUpdate request, TDbEntity entity) { }
        public virtual void BeforeDelete(int id, TDbEntity entity) { }
        public virtual void AfterDelete(int id, TDbEntity entity) { }
    }
}
