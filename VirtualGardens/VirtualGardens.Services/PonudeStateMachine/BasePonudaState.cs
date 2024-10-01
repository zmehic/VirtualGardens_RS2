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
        public _210011Context Context { get; set; }
        public IMapper Mapper { get; set; }
        public IServiceProvider ServiceProvider { get; set; }

        public BasePonudaState(_210011Context context, IMapper mapper, IServiceProvider serviceProvider)
        {
            Context = context;
            Mapper = mapper;
            ServiceProvider = serviceProvider;
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
            throw new UserException("Method not allowed");
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
                    return ServiceProvider.GetService<InitialPonudaState>();
                case "created":
                    return ServiceProvider.GetService<CreatedPonudaState>();
                case "active":
                    return ServiceProvider.GetService<ActivePonudaState>();
                case "finished":
                    return ServiceProvider.GetService<FinishedPonudaState>();

                default: throw new Exception("State not recognized");
            }
        }
    }
}

