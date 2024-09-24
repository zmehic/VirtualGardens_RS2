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
    public class InitialNarudzbaState : BaseNarudzbaState
    {
        public InitialNarudzbaState(_210011Context context, IMapper mapper, IServiceProvider serviceProvider) : base(context, mapper, serviceProvider)
        {
        }

        public override NarudzbeDTO Insert(NarudzbeUpsertRequest request)
        {
            var set = Context.Set<Narudzbe>();
            var entity = Mapper.Map<Narudzbe>(request);
            entity.StateMachine = "created";
            set.Add(entity);
            Context.SaveChanges();

            return Mapper.Map<NarudzbeDTO>(entity);
        }

        public override List<string> AllowedActions(Narudzbe entity)
        {
            return new List<string>() { "insert" };
        }
    }
}
