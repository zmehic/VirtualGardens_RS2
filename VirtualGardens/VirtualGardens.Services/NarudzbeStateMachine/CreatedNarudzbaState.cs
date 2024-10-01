using Azure.Core;
using MapsterMapper;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using VirtualGardens.Models.DTOs;
using VirtualGardens.Models.Requests.Narudzbe;
using VirtualGardens.Services.Database;

namespace VirtualGardens.Services.NarudzbeStateMachine
{
    public class CreatedNarudzbaState : BaseNarudzbaState
    {
        public CreatedNarudzbaState(_210011Context context, IMapper mapper, IServiceProvider serviceProvider) : base(context, mapper, serviceProvider)
        {
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

            Context.Remove(entity);
            Context.SaveChanges();
        }

        public override NarudzbeDTO InProgress(int id)
        {
            var set = Context.Set<Narudzbe>();
            var entity = set.Find(id);
            entity.StateMachine = "inprogress";
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
