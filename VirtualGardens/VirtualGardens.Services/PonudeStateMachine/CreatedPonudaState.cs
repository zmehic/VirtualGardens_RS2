using EasyNetQ;
using EasyNetQ.DI;
using MapsterMapper;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using VirtualGardens.Models.DTOs;
using VirtualGardens.Models.Messages;
using VirtualGardens.Models.Requests.Narudzbe;
using VirtualGardens.Models.Requests.Ponude;
using VirtualGardens.Models.Requests.SetoviPonude;
using VirtualGardens.Services.BaseInterfaces;
using VirtualGardens.Services.Database;

namespace VirtualGardens.Services.PonudeStateMachine
{
    public class CreatedPonudaState:BasePonudaState
    {
        public CreatedPonudaState(_210011Context _context, IMapper _mapper, IServiceProvider _serviceProvider) : base(_context, _mapper, _serviceProvider)
        {
        }

        public override PonudeDTO Update(int id, PonudeUpsertRequest request)
        {
            var set = context.Set<Ponude>();
            var entity = set.Find(id);
            mapper.Map(request, entity);
            context.SaveChanges();

            return mapper.Map<Models.DTOs.PonudeDTO>(entity!);
        }
        
        public override void Delete(int id)
        {
            var entity = context.Set<Ponude>().Find(id);

            if (entity == null)
            {
                throw new Exception("Nemoguće pronaći objekat sa poslanim id-om!");
            }

            if (entity is ISoftDeletable softDeletableEntity)
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
        }

        public override PonudeDTO Activate(int id)
        {
            var set = context.Set<Ponude>();
            var entity = set.Find(id);
            if(entity != null)
                entity.StateMachine = "active";
            context.SaveChanges();

            var bus = RabbitHutch.CreateBus("host=rabbitmq:5672");
            var mappedEntity = mapper.Map<PonudeDTO>(entity!);

            var users = context.Korisnicis.Where(x => x.KorisniciUloges.Any(role => role.Uloga != null && role.Uloga.Naziv == "Kupac")).ToList();

            foreach ( var user in users )
            {
                PonudaActivated message = new PonudaActivated { ime=user.Ime, prezime=user.Prezime, email=user.Email, nazivPonude=mappedEntity.Naziv, popust=mappedEntity.Popust };
                bus.PubSub.Publish(message);
            }   
            
            return mappedEntity;
        }

        public override PonudeDTO AddSet(SetoviPonudeUpsertRequest request)
        {
            var set = context.Set<SetoviPonude>();
            var entity = mapper.Map<SetoviPonude>(request);
            var ponuda = (context.Set<Ponude>()).Find(request.PonudaId);

            set.Add(entity);
            context.SaveChanges();

            return mapper.Map<PonudeDTO>(entity);
        }

        public override List<string> AllowedActions(Ponude entity)
        {
            return new List<string>() { "update", "delete", "activate", "addset" };
        }
    }
}
