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
        public ActivePonudaState(_210011Context _context, IMapper _mapper, IServiceProvider _serviceProvider) : base(_context, _mapper, _serviceProvider)
        {
        }

        public override PonudeDTO Finish(int id)
        {
            var set = context.Set<Ponude>();
            var entity = set.Find(id);
            if(entity != null) 
                entity.StateMachine = "finished";
            context.SaveChanges();

            return mapper.Map<PonudeDTO>(entity!);
        }
        public override List<string> AllowedActions(Ponude entity)
        {
            return new List<string>() { "finish" };
        }
    }
}
