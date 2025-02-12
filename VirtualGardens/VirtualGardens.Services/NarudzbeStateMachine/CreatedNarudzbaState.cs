using Azure.Core;
using MapsterMapper;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using VirtualGardens.Models.DTOs;
using VirtualGardens.Models.Exceptions;
using VirtualGardens.Models.Requests.Narudzbe;
using VirtualGardens.Services.BaseInterfaces;
using VirtualGardens.Services.Database;

namespace VirtualGardens.Services.NarudzbeStateMachine
{
    public class CreatedNarudzbaState : BaseNarudzbaState
    {
        public CreatedNarudzbaState(_210011Context _context, IMapper _mapper, IServiceProvider _serviceProvider) : base(_context, _mapper, _serviceProvider)
        {
        }

        void BeforeUpdate(Narudzbe entity)
        {
            var orderProducts = context.ProizvodiSets.Include(x => x.Set).Where(x => x.Set.NarudzbaId == entity.NarudzbaId && x.Set.IsDeleted==false).ToList();
            foreach (var item in orderProducts)
            {
                var product = context.Proizvodis.Where(x => x.ProizvodId == item.ProizvodId).FirstOrDefault();
                if(product!=null)
                {
                    product.DostupnaKolicina -= item.Kolicina;
                    context.Update(product);
                    context.SaveChanges();
                }
            }
        }

        public override NarudzbeDTO Update(int id, NarudzbeUpsertRequest request)
        {
            var set = context.Set<Narudzbe>();
            var entity = set.Find(id);
            mapper.Map(request, entity);
            context.SaveChanges();

            return mapper.Map<Models.DTOs.NarudzbeDTO>(entity!);
        }

        public override void Delete(int id)
        {
            var entity = context.Set<Narudzbe>().Find(id);

            if (entity == null)
            {
                throw new UserException("Taj objekat ne postoji u bazi podataka!");
            }

            if (entity is ISoftDeletable softDeletableEntity)
            {
                entity.Otkazana = true;
                softDeletableEntity.IsDeleted = true;
                softDeletableEntity.VrijemeBrisanja = DateTime.Now;

                context.Update(entity);
            }
            else
            {
                context.Remove(entity);
            }

            context.SaveChanges();

        }

        public override NarudzbeDTO InProgress(int id)
        {
            var set = context.Set<Narudzbe>();
            var entity = set.Find(id);

            if(entity != null)
            {
                entity.StateMachine = "inprogress";
                BeforeUpdate(entity);
            }
            context.SaveChanges();

            return mapper.Map<NarudzbeDTO>(entity!);
        }

        public override NarudzbeDTO Finish(int id)
        {
            var set = context.Set<Narudzbe>();
            var entity = set.Find(id);
            if(entity != null ) 
                entity.StateMachine = "finished";
            context.SaveChanges();

            return mapper.Map<NarudzbeDTO>(entity!);
        }

        public override List<string> AllowedActions(Narudzbe? entity)
        {
            return new List<string>() { "update", "inprogress", "finish", "delete" };
        }
    }
}
