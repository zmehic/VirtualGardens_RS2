using Azure.Core;
using MapsterMapper;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using VirtualGardens.Models.DTOs;
using VirtualGardens.Models.Requests.Narudzbe;
using VirtualGardens.Services.BaseInterfaces;
using VirtualGardens.Services.Database;

namespace VirtualGardens.Services.NarudzbeStateMachine
{
    public class CreatedNarudzbaState : BaseNarudzbaState
    {
        public _210011Context _210011Context { get; set; }
        public CreatedNarudzbaState(_210011Context context, IMapper mapper, IServiceProvider serviceProvider) : base(context, mapper, serviceProvider)
        {
            _210011Context = context;
        }

        void BeforeUpdate(Narudzbe entity)
        {
            var orderProducts = _210011Context.ProizvodiSets.Include(x => x.Set).Where(x => x.Set.NarudzbaId == entity.NarudzbaId && x.Set.IsDeleted==false).ToList();
            foreach (var item in orderProducts)
            {
                var product = _210011Context.Proizvodis.Where(x => x.ProizvodId == item.ProizvodId).FirstOrDefault();
                if(product!=null)
                {
                    product.DostupnaKolicina -= item.Kolicina;
                    _210011Context.Update(product);
                    _210011Context.SaveChanges();
                }
            }
        }

        public override NarudzbeDTO Update(int id, NarudzbeUpsertRequest request)
        {
            var set = Context.Set<Narudzbe>();
            var entity = set.Find(id);
            Mapper.Map(request, entity);
            Context.SaveChanges();

            return Mapper.Map<Models.DTOs.NarudzbeDTO>(entity);
        }

        public override void Delete(int id)
        {
            var entity = Context.Set<Narudzbe>().Find(id);

            if (entity == null)
            {
                throw new Exception("Nemoguće pronaći objekat sa poslanim id-om!");
            }

            if (entity is ISoftDeletable softDeletableEntity)
            {
                entity.Otkazana = true;
                softDeletableEntity.IsDeleted = true;
                softDeletableEntity.VrijemeBrisanja = DateTime.Now;

                Context.Update(entity);
            }
            else
            {
                Context.Remove(entity);
            }

            Context.SaveChanges();

        }

        public override NarudzbeDTO InProgress(int id)
        {
            var set = Context.Set<Narudzbe>();
            var entity = set.Find(id);
            entity.StateMachine = "inprogress";
            BeforeUpdate(entity);
            Context.SaveChanges();

            return Mapper.Map<NarudzbeDTO>(entity);
        }

        public override NarudzbeDTO Finish(int id)
        {
            var set = Context.Set<Narudzbe>();
            var entity = set.Find(id);
            entity.StateMachine = "finished";
            Context.SaveChanges();

            return Mapper.Map<NarudzbeDTO>(entity);
        }

        public override List<string> AllowedActions(Narudzbe entity)
        {
            return new List<string>() { "update", "inprogress", "finish", "delete" };
        }
    }
}
