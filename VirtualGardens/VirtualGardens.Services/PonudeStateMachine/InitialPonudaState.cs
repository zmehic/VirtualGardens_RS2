using MapsterMapper;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using VirtualGardens.Models.DTOs;
using VirtualGardens.Models.Exceptions;
using VirtualGardens.Models.Requests.Narudzbe;
using VirtualGardens.Models.Requests.Ponude;
using VirtualGardens.Services.Database;

namespace VirtualGardens.Services.PonudeStateMachine
{
    public class InitialPonudaState:BasePonudaState
    {
        public InitialPonudaState(_210011Context _context, IMapper _mapper, IServiceProvider _serviceProvider) : base(_context, _mapper, _serviceProvider)
        {
        }

        

        public override PonudeDTO Insert(PonudeUpsertRequest request)
        {
            var set = context.Set<Ponude>();
            checkForExisting(request);
            var entity = mapper.Map<Ponude>(request);
            entity.StateMachine = "created";
            set.Add(entity);
            context.SaveChanges();

            return mapper.Map<PonudeDTO>(entity);
        }

        private void checkForExisting(PonudeUpsertRequest request)
        {
            var ponuda = context.Ponudes.Where(x=>x.IsDeleted == false && x.Naziv ==  request.Naziv).FirstOrDefault();
            if(ponuda != null)
            {
                throw new UserException("Ponuda sa tim nazivom već postoji!");
            }
        }

        public override List<string> AllowedActions(Ponude entity)
        {
            return new List<string>() { "insert" };
        }
    }
}
