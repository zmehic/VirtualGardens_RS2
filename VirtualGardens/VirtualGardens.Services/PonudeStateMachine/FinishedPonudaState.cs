using MapsterMapper;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using VirtualGardens.Models.DTOs;
using VirtualGardens.Services.Database;

namespace VirtualGardens.Services.PonudeStateMachine
{
    public class FinishedPonudaState : BasePonudaState
    {
        public FinishedPonudaState(_210011Context context, IMapper mapper, IServiceProvider serviceProvider) : base(context, mapper, serviceProvider)
        {
        }

        public override PonudeDTO Edit(int id)
        {
            var set = Context.Set<Ponude>();
            var entity = set.Find(id);
            entity.StateMachine = "created";
            Context.SaveChanges();

            return Mapper.Map<PonudeDTO>(entity);
        }

        public override List<string> AllowedActions(Ponude entity)
        {
            return new List<string>() { "edit" };
        }
    }
}
