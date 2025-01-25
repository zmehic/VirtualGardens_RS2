using MapsterMapper;
using VirtualGardens.Models.Requests.Narudzbe;
using VirtualGardens.Services.Database;
using Microsoft.Extensions.DependencyInjection;
using VirtualGardens.Models.Exceptions;

namespace VirtualGardens.Services.NarudzbeStateMachine
{
    public class BaseNarudzbaState
    {
        public _210011Context context { get; set; }
        public IMapper mapper { get; set; }
        public IServiceProvider serviceProvider { get; set; }

        public BaseNarudzbaState(_210011Context _context, IMapper _mapper, IServiceProvider _serviceProvider)
        {
            context = _context;
            mapper = _mapper;
            serviceProvider = _serviceProvider;
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

        public virtual void Delete(int id)
        {
            throw new UserException("Method not allowed");
        }

        public virtual List<string> AllowedActions(Database.Narudzbe? entity)
        {
            throw new UserException("Method not allowed");
        }

        public BaseNarudzbaState CreateState(string statename)
        {
            switch(statename)
            {
                case "initial":
                    return serviceProvider.GetService<InitialNarudzbaState>()!;
                case "created":
                    return serviceProvider.GetService<CreatedNarudzbaState>()!;
                case "inprogress":
                    return serviceProvider.GetService<InProgressNarudzbaState>()!;
                case "finished":
                    return serviceProvider.GetService<FinishedNarudzbaState>()!;

                default: throw new Exception("State not recognized");
            }
        }
    }
}