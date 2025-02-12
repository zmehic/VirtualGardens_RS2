using MapsterMapper;
using Microsoft.Extensions.DependencyInjection;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using VirtualGardens.Models.Exceptions;
using VirtualGardens.Models.Requests.Narudzbe;
using VirtualGardens.Models.Requests.Ponude;
using VirtualGardens.Models.Requests.SetoviPonude;
using VirtualGardens.Services.Database;
using VirtualGardens.Services.NarudzbeStateMachine;

namespace VirtualGardens.Services.PonudeStateMachine
{
    public class BasePonudaState
    {
        public _210011Context context { get; set; }
        public IMapper mapper { get; set; }
        public IServiceProvider serviceProvider { get; set; }

        public BasePonudaState(_210011Context _context, IMapper _mapper, IServiceProvider _serviceProvider)
        {
            context = _context;
            mapper = _mapper;
            serviceProvider = _serviceProvider;
        }
        public virtual Models.DTOs.PonudeDTO Insert(PonudeUpsertRequest request)
        {
            throw new UserException("Method not allowed");
        }

        public virtual Models.DTOs.PonudeDTO Update(int id, PonudeUpsertRequest request)
        {
            throw new UserException("Method not allowed");
        }

        public virtual Models.DTOs.PonudeDTO Created(int id)
        {
            throw new UserException("Method not allowed");
        }

        public virtual Models.DTOs.PonudeDTO Edit(int id)
        {
            throw new UserException("Method not allowed");
        }

        public virtual Models.DTOs.PonudeDTO Activate(int id)
        {
            throw new UserException("Method not allowed");
        }

        public virtual Models.DTOs.PonudeDTO Finish(int id)
        {
            throw new UserException("Method not allowed");
        }

        public virtual Models.DTOs.PonudeDTO AddSet(SetoviPonudeUpsertRequest request)
        {
            throw new UserException("Method not allowed");
        }

        public virtual void Delete(int id)
        {
            throw new UserException("Da biste obrisali ponudu, morate je vratiti u stanje 'Kreirana'");
        }

        public virtual List<string> AllowedActions(Database.Ponude entity)
        {
            throw new UserException("Method not allowed");
        }

        public BasePonudaState CreateState(string statename)
        {
            switch (statename)
            {
                case "initial":
                    return serviceProvider.GetService<InitialPonudaState>()!;
                case "created":
                    return serviceProvider.GetService<CreatedPonudaState>()!;
                case "active":
                    return serviceProvider.GetService<ActivePonudaState>()!;
                case "finished":
                    return serviceProvider.GetService<FinishedPonudaState>()!;

                default: throw new Exception("State not recognized");
            }
        }
    }
}

