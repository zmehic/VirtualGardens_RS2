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
        public InProgressNarudzbaState(_210011Context _context, IMapper _mapper, IServiceProvider _serviceProvider) : base(_context, _mapper, _serviceProvider)
        {
        }

        public override NarudzbeDTO Finish(int id)
        {
            var set = context.Set<Narudzbe>();
            var entity = set.Find(id);
            if(entity != null) 
                entity.StateMachine = "finished";
            context.SaveChanges();

            return mapper.Map<NarudzbeDTO>(entity!);
        }

        public override NarudzbeDTO Update(int id, NarudzbeUpsertRequest request)
        {
            var set = context.Set<Narudzbe>();
            var entity = set.Find(id);
            mapper.Map(request, entity);
            context.SaveChanges();

            return mapper.Map<Models.DTOs.NarudzbeDTO>(entity!);
        }

        public override List<string> AllowedActions(Narudzbe? entity)
        {
            return new List<string>() { "finish" };
        }
    }
}
