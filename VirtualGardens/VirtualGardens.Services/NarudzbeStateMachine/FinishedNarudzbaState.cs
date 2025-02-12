using MapsterMapper;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using VirtualGardens.Models.DTOs;
using VirtualGardens.Services.Database;

namespace VirtualGardens.Services.NarudzbeStateMachine
{
    public class FinishedNarudzbaState : BaseNarudzbaState
    {
        public FinishedNarudzbaState(_210011Context _context, IMapper _mapper, IServiceProvider _serviceProvider) : base(_context, _mapper, _serviceProvider)
        {
        }

        public override NarudzbeDTO Edit(int id)
        {
            var set = context.Set<Narudzbe>();
            var entity = set.Find(id);
            if(entity != null)
                entity.StateMachine = "created";
            context.SaveChanges();

            return mapper.Map<NarudzbeDTO>(entity!);
        }

        public override List<string> AllowedActions(Narudzbe? entity)
        {
            return new List<string>() { "edit" };
        }
    }
}
