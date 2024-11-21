using Azure.Core;
using EasyNetQ;
using MapsterMapper;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using VirtualGardens.Models.DTOs;
using VirtualGardens.Models.Requests;
using VirtualGardens.Models.Requests.Ponude;
using VirtualGardens.Models.Requests.SetoviPonude;
using VirtualGardens.Models.SearchObjects;
using VirtualGardens.Services.BaseServices;
using VirtualGardens.Services.Database;
using VirtualGardens.Services.NarudzbeStateMachine;
using VirtualGardens.Services.PonudeStateMachine;

namespace VirtualGardens.Services.AllServices.Ponude
{
    public class PonudeService : BaseCRUDService<Models.DTOs.PonudeDTO, PonudeSearchObject, Database.Ponude, PonudeUpsertRequest, PonudeUpsertRequest>, IPonudeService
    {
        public BasePonudaState BasePonudaState { get; set; }
        public PonudeService(_210011Context context, BasePonudaState basePonudaState, IMapper mapper) : base(context, mapper)
        {
            BasePonudaState = basePonudaState;
        }

        public override IQueryable<Database.Ponude> AddFilter(PonudeSearchObject search, IQueryable<Database.Ponude> query)
        {

            if (!string.IsNullOrEmpty(search.NazivContains))
            {
                query = query.Where(x => x.Naziv.ToLower().Contains(search.NazivContains.ToLower()));
            }

            if (search.PopustFrom.HasValue)
            {
                query = query.Where(x => x.Popust >= search.PopustFrom.Value);
            }

            if (search.PopustTo.HasValue)
            {
                query = query.Where(x => x.Popust <= search.PopustTo.Value);
            }

            if(search != null)
            {
                if (search.isDeleted != null)
                {
                    query = query.Where(x => x.IsDeleted == search.isDeleted);
                }

                if (search.StateMachine != null)
                {
                    query = query.Where(x => x.StateMachine == search.StateMachine);
                }

                if (search.DatumFrom.HasValue)
                {
                    query = query.Where(x => x.DatumKreiranja >= search.DatumFrom.Value);
                }

                if (search.DatumTo.HasValue)
                {
                    query = query.Where(x => x.DatumKreiranja <= search.DatumTo.Value);
                }
            }

            

            return query;
        }

        public override PonudeDTO Insert(PonudeUpsertRequest request)
        {
            var state = BasePonudaState.CreateState("initial");
            return state.Insert(request);
        }

        public override PonudeDTO Update(int id, PonudeUpsertRequest request)
        {
            var entity = GetById(id);
            var state = BasePonudaState.CreateState(entity.StateMachine);
            return state.Update(id, request);
        }

        public override void Delete(int id)
        {
            var entity = GetById(id);
            var state = BasePonudaState.CreateState(entity.StateMachine);
            state.Delete(id);
        }

        public PonudeDTO Edit(int id)
        {
            var entity = GetById(id);
            var state = BasePonudaState.CreateState(entity.StateMachine);
            return state.Edit(id);
        }

        public PonudeDTO Activate(int id)
        {
            var entity = GetById(id);
            var state = BasePonudaState.CreateState(entity.StateMachine);
            return state.Activate(id);
        }

        public PonudeDTO Finish(int id)
        {
            var entity = GetById(id);
            var state = BasePonudaState.CreateState(entity.StateMachine);
            return state.Finish(id);
        }
        public PonudeDTO AddSet(SetoviPonudeUpsertRequest request)
        {
            var entity = GetById(request.PonudaId);
            var state = BasePonudaState.CreateState(entity.StateMachine);
            return state.AddSet(request);
        }

        public List<string> AllowedActions(int id)
        {
            if (id <= 0)
            {
                var state = BasePonudaState.CreateState("initial");
                return state.AllowedActions(null);
            }
            else
            {
                var entity = Context.Ponudes.Find(id);
                var state = BasePonudaState.CreateState(entity.StateMachine);
                return state.AllowedActions(entity);
            }
        }
    }
}
