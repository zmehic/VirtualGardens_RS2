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
    public class InProgressNarudzbaState : BaseNarudzbaState
    {
        public InProgressNarudzbaState(_210011Context context, IMapper mapper, IServiceProvider serviceProvider) : base(context, mapper, serviceProvider)
        {
        }

        public override NarudzbeDTO Finish(int id)
        {
            var set = Context.Set<Narudzbe>();
            var entity = set.Find(id);
            entity.StateMachine = "finished";
            Context.SaveChanges();

            return Mapper.Map<NarudzbeDTO>(entity);
        }

        public override NarudzbeDTO Update(int id, NarudzbeUpsertRequest request)
        {
            var set = Context.Set<Narudzbe>();
            var entity = set.Find(id);
            Mapper.Map(request, entity);
            Context.SaveChanges();

            return Mapper.Map<Models.DTOs.NarudzbeDTO>(entity);
        }
        public override List<string> AllowedActions(Narudzbe entity)
        {
            return new List<string>() { "finish" };
        }
    }
}
