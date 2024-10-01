using MapsterMapper;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using VirtualGardens.Models.DTOs;
using VirtualGardens.Models.Requests.Narudzbe;
using VirtualGardens.Models.Requests.Ponude;
using VirtualGardens.Services.Database;

namespace VirtualGardens.Services.PonudeStateMachine
{
    public class InitialPonudaState:BasePonudaState
    {
        public InitialPonudaState(_210011Context context, IMapper mapper, IServiceProvider serviceProvider) : base(context, mapper, serviceProvider)
        {
        }

        public override PonudeDTO Insert(PonudeUpsertRequest request)
        {
            var set = Context.Set<Ponude>();
            var entity = Mapper.Map<Ponude>(request);
            entity.StateMachine = "created";
            set.Add(entity);
            Context.SaveChanges();

            return Mapper.Map<PonudeDTO>(entity);
        }

        public override List<string> AllowedActions(Ponude entity)
        {
            return new List<string>() { "insert" };
        }
    }
}
