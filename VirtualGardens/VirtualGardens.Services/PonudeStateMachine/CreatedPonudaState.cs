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
using VirtualGardens.Services.Conventions;
using VirtualGardens.Services.Database;

namespace VirtualGardens.Services.PonudeStateMachine
{
    public class CreatedPonudaState:BasePonudaState
    {
        public CreatedPonudaState(_210011Context context, IMapper mapper, IServiceProvider serviceProvider) : base(context, mapper, serviceProvider)
        {
        }

        public override PonudeDTO Update(int id, PonudeUpsertRequest request)
        {
            var set = Context.Set<Ponude>();
            var entity = set.Find(id);
            Mapper.Map(request, entity);
            Context.SaveChanges();

            return Mapper.Map<Models.DTOs.PonudeDTO>(entity);
        }
        
        public override void Delete(int id)
        {
            var entity = Context.Set<Ponude>().Find(id);

            if (entity == null)
            {
                throw new Exception("Nemoguće pronaći objekat sa poslanim id-om!");
            }

            Context.Remove(entity);
            Context.SaveChanges();
        }

        public override PonudeDTO Activate(int id)
        {
            var set = Context.Set<Ponude>();
            var entity = set.Find(id);
            entity.StateMachine = "active";
            Context.SaveChanges();

            var bus = RabbitHutch.CreateBus("host=rabbitmq:5672");
            var mappedEntity = Mapper.Map<PonudeDTO>(entity);

            var users = Context.Korisnicis.Where(x => x.KorisniciUloges.Any(role => role.Uloga != null && role.Uloga.Naziv == "Kupac")).ToList();

            foreach ( var user in users )
            {
                PonudaActivated message = new PonudaActivated { ime=user.Ime, prezime=user.Prezime, email=user.Email, nazivPonude=mappedEntity.Naziv, popust=mappedEntity.Popust };
                bus.PubSub.Publish(message);
            }   
            
            return mappedEntity;
        }

        public override PonudeDTO AddSet(SetoviPonudeUpsertRequest request)
        {
            var set = Context.Set<SetoviPonude>();
            var entity = Mapper.Map<SetoviPonude>(request);
            var ponuda = (Context.Set<Ponude>()).Find(request.PonudaId);

            set.Add(entity);
            Context.SaveChanges();

            return Mapper.Map<PonudeDTO>(entity);
        }

        public override List<string> AllowedActions(Ponude entity)
        {
            return new List<string>() { "update", "delete", "activate", "addset" };
        }
    }
}
