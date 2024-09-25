using MapsterMapper;
using VirtualGardens.Models.Requests.Narudzbe;
using VirtualGardens.Services.Database;
using Microsoft.Extensions.DependencyInjection;
using VirtualGardens.Models.Exceptions;

namespace VirtualGardens.Services.NarudzbeStateMachine
{
    public class BaseNarudzbaState
    {
        public _210011Context Context { get; set; }
        public IMapper Mapper { get; set; }
        public IServiceProvider ServiceProvider { get; set; }

        public BaseNarudzbaState(_210011Context context, IMapper mapper, IServiceProvider serviceProvider)
        {
            Context = context;
            Mapper = mapper;
            ServiceProvider = serviceProvider;
        }
        public virtual Models.DTOs.NarudzbeDTO Insert(NarudzbeUpsertRequest request)
        {
            throw new UserException("Method not allowed");
        }

        public virtual Models.DTOs.NarudzbeDTO Update(int id, NarudzbeUpsertRequest request)
        {
            throw new UserException("Method not allowed");
        }

        public virtual Models.DTOs.NarudzbeDTO Finish(int id)
        {
            throw new UserException("Method not allowed");
        }

        public virtual Models.DTOs.NarudzbeDTO InProgress(int id)
        {
            throw new UserException("Method not allowed");
        }

        public virtual Models.DTOs.NarudzbeDTO Created(int id)
        {
            throw new UserException("Method not allowed");
        }

        public virtual Models.DTOs.NarudzbeDTO Edit(int id)
        {
            throw new UserException("Method not allowed");
        }

        public virtual List<string> AllowedActions(Database.Narudzbe entity)
        {
            throw new UserException("Method not allowed");
        }

        public BaseNarudzbaState CreateState(string statename)
        {
            switch(statename)
            {
                case "initial":
                    return ServiceProvider.GetService<InitialNarudzbaState>();
                case "created":
                    return ServiceProvider.GetService<CreatedNarudzbaState>();
                case "inprogress":
                    return ServiceProvider.GetService<InProgressNarudzbaState>();
                case "finished":
                    return ServiceProvider.GetService<FinishedNarudzbaState>();

                default: throw new Exception("State not recognized");
            }
        }
    }
}
//initial, created, inprogress, finished