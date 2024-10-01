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
    public class ActivePonudaState : BasePonudaState
    {
        public ActivePonudaState(_210011Context context, IMapper mapper, IServiceProvider serviceProvider) : base(context, mapper, serviceProvider)
        {
        }

        public override PonudeDTO Finish(int id)
        {
            var set = Context.Set<Ponude>();
            var entity = set.Find(id);
            entity.StateMachine = "finished";
            Context.SaveChanges();

            return Mapper.Map<PonudeDTO>(entity);
        }
        public override List<string> AllowedActions(Ponude entity)
        {
            return new List<string>() { "finish" };
        }
    }
}
