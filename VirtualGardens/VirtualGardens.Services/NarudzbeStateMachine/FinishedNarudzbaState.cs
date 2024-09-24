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
        public FinishedNarudzbaState(_210011Context context, IMapper mapper, IServiceProvider serviceProvider) : base(context, mapper, serviceProvider)
        {
        }

        public override NarudzbeDTO Edit(int id)
        {
            var set = Context.Set<Narudzbe>();
            var entity = set.Find(id);
            entity.StateMachine = "created";
            Context.SaveChanges();

            return Mapper.Map<NarudzbeDTO>(entity);
        }

        public override List<string> AllowedActions(Narudzbe entity)
        {
            return new List<string>() { "edit" };
        }
    }
}
