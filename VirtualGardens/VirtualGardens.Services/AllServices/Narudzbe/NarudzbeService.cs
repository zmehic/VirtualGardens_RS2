using Azure.Core;
using MapsterMapper;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using VirtualGardens.Models.DTOs;
using VirtualGardens.Models.Requests;
using VirtualGardens.Models.Requests.Narudzbe;
using VirtualGardens.Models.SearchObjects;
using VirtualGardens.Services.BaseServices;
using VirtualGardens.Services.Database;
using VirtualGardens.Services.NarudzbeStateMachine;

namespace VirtualGardens.Services.AllServices.Narudzbe
{
    public class NarudzbeService : BaseCRUDService<Models.DTOs.NarudzbeDTO, NarudzbeSearchObject, Database.Narudzbe, NarudzbeUpsertRequest, NarudzbeUpsertRequest>, INarudzbeService
    {
        public BaseNarudzbaState BaseNarudzbaState { get; set; }
        ILogger<ProizvodiService> _logger;
        public NarudzbeService(_210011Context context, IMapper mapper, BaseNarudzbaState baseNarudzbaState, ILogger<ProizvodiService> logger) : base(context, mapper)
        {
            BaseNarudzbaState = baseNarudzbaState;
            _logger = logger;
        }

        public override IQueryable<Database.Narudzbe> AddFilter(NarudzbeSearchObject search, IQueryable<Database.Narudzbe> query)
        {
            if (!string.IsNullOrEmpty(search?.BrojNarudzbeGTE))
            {
                query = query.Where(x => x.BrojNarudzbe.ToLower().StartsWith(search.BrojNarudzbeGTE.ToLower()));
            }
            if(search != null)
            {
                if (search.Otkazana.HasValue)
                {
                    query = query.Where(x => x.Otkazana == search.Otkazana.Value);
                }

                if (search.DatumFrom.HasValue)
                {
                    query = query.Where(x => x.Datum >= search.DatumFrom.Value);
                }

                if (search.DatumTo.HasValue)
                {
                    query = query.Where(x => x.Datum <= search.DatumTo.Value);
                }

                if (search.Placeno.HasValue)
                {
                    query = query.Where(x => x.Placeno == search.Placeno.Value);
                }

                if (search.Status.HasValue)
                {
                    query = query.Where(x => x.Status == search.Status.Value);
                }

                if (search.UkupnaCijenaFrom.HasValue)
                {
                    query = query.Where(x => x.UkupnaCijena >= search.UkupnaCijenaFrom.Value);
                }

                if (search.UkupnaCijenaTo.HasValue)
                {
                    query = query.Where(x => x.UkupnaCijena <= search.UkupnaCijenaTo.Value);
                }

                if (search.KorisnikId.HasValue)
                {
                    query = query.Where(x => x.KorisnikId == search.KorisnikId.Value);
                }

                if (search.NalogId.HasValue)
                {
                    query = query.Where(x => x.NalogId == search.NalogId.Value);
                }
            }

            return query;
        }

        public override NarudzbeDTO Insert(NarudzbeUpsertRequest request)
        {
            var state = BaseNarudzbaState.CreateState("initial");
            return state.Insert(request);
        }

        public override NarudzbeDTO Update(int id, NarudzbeUpsertRequest request)
        {
            var entity = GetById(id);
            var state = BaseNarudzbaState.CreateState(entity.StateMachine);
            return state.Update(id,request);
        }

        public NarudzbeDTO InProgress(int id)
        {
            var entity = GetById(id);
            var state = BaseNarudzbaState.CreateState(entity.StateMachine);
            return state.InProgress(id);
        }

        public NarudzbeDTO Edit(int id)
        {
            var entity = GetById(id);
            var state = BaseNarudzbaState.CreateState(entity.StateMachine);
            return state.Edit(id);
        }

        public NarudzbeDTO Finish(int id)
        {
            var entity = GetById(id);
            var state = BaseNarudzbaState.CreateState(entity.StateMachine);
            return state.Finish(id);
        }

        public override void Delete(int id)
        {
            var entity = GetById(id);
            var state = BaseNarudzbaState.CreateState(entity.StateMachine);
            state.Delete(id);
        }

        public List<string> AllowedActions(int id)
        {
            _logger.LogInformation($"Allowed action called for {id}");
            if(id <= 0)
            {
                var state = BaseNarudzbaState.CreateState("initial");
                return state.AllowedActions(null);
            }
            else
            {
                var entity = Context.Narudzbes.Find(id);

                var state = BaseNarudzbaState.CreateState(entity.StateMachine!);
                return state.AllowedActions(entity);
            }
        }
    }
}
