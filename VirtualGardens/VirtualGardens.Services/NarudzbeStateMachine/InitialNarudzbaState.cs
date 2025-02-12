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
        public InitialNarudzbaState(_210011Context _context, IMapper _mapper, IServiceProvider _serviceProvider) : base(_context, _mapper, _serviceProvider)
        {
        }

        public override NarudzbeDTO Insert(NarudzbeUpsertRequest request)
        {
            var set = context.Set<Narudzbe>();
            var entity = mapper.Map<Narudzbe>(request);
            entity.StateMachine = "created";
            set.Add(entity);
            context.SaveChanges();

            return mapper.Map<NarudzbeDTO>(entity);
        }

        public override List<string> AllowedActions(Narudzbe? entity)
        {
            return new List<string>() { "insert" };
        }
    }
}
