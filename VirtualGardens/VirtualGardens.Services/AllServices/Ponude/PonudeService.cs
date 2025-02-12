using Azure.Core;
using EasyNetQ;
using MapsterMapper;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using VirtualGardens.Models.DTOs;
using VirtualGardens.Models.HelperClasses;
using VirtualGardens.Models.Requests;
using VirtualGardens.Models.Requests.Ponude;
using VirtualGardens.Models.Requests.Setovi;
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
        public BasePonudaState basePonudaState { get; set; }
        public PonudeService(_210011Context _context, BasePonudaState _basePonudaState, IMapper _mapper) : base(_context, _mapper)
        {
            basePonudaState = _basePonudaState;
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
            var state = basePonudaState.CreateState("initial");
            return state.Insert(request);
        }

        public override PonudeDTO Update(int id, PonudeUpsertRequest request)
        {
            var entity = GetById(id);
            var state = basePonudaState.CreateState(entity.StateMachine!);
            return state.Update(id, request);
        }

        public override void Delete(int id)
        {
            var entity = GetById(id);
            var state = basePonudaState.CreateState(entity.StateMachine!);
            state.Delete(id);
        }

        public PonudeDTO Edit(int id)
        {
            var entity = GetById(id);
            var state = basePonudaState.CreateState(entity.StateMachine!);
            return state.Edit(id);
        }

        public PonudeDTO Activate(int id)
        {
            var entity = GetById(id);
            var state = basePonudaState.CreateState(entity.StateMachine!);
            return state.Activate(id);
        }

        public PonudeDTO Finish(int id)
        {
            var entity = GetById(id);
            var state = basePonudaState.CreateState(entity.StateMachine!);
            return state.Finish(id);
        }
        public PonudeDTO AddSet(SetoviPonudeUpsertRequest request)
        {
            var entity = GetById(request.PonudaId);
            var state = basePonudaState.CreateState(entity.StateMachine!);
            return state.AddSet(request);
        }

        public List<string> AllowedActions(int id)
        {
            if (id <= 0)
            {
                var state = basePonudaState.CreateState("initial");
                return state.AllowedActions(null!);
            }
            else
            {
                var entity = context.Ponudes.Find(id);
                var state = basePonudaState.CreateState(entity!.StateMachine!);
                return state.AllowedActions(entity);
            }
        }

        public NarudzbeDTO AddPonudaToOrder(int ponudaId, int narudzbaId)
        {
            var setovi = context.SetoviPonudes.Include(x => x.Set).ThenInclude(x => x.ProizvodiSets).Where(x => x.PonudaId == ponudaId && x.IsDeleted==false && x.Set.IsDeleted==false).Select(x=> mapper.Map<SetoviUpsertRequest>(x.Set)).ToList();

            var sumaPopust = 0.0f;
            var suma = 0.0f;
            var sumaUkupno = 0.0f;

            if(setovi.Count > 0)
            {
                foreach(var set in setovi)
                {
                    if(set.ProizvodiSets != null && set.ProizvodiSets.Count > 0)
                    {
                        foreach (var item in set.ProizvodiSets)
                        {
                            float cijena = context.Proizvodis.Where(x => x.ProizvodId == item.ProizvodId).FirstOrDefault()?.Cijena ?? 0.0f;
                            if(cijena != 0.0f && item != null)
                            {
                                float ukupnaCijena = item.Kolicina * cijena;
                                float ukupnaCijenaPopust = (float)item.Kolicina * (float)Math.Round((cijena * (1 - (float)((float)set.Popust! / 100))), 2);
                                suma += ukupnaCijena;
                                sumaPopust += ukupnaCijenaPopust;
                            }
                        }
                    }

                    suma = (float)Math.Round(suma, 2);
                    sumaPopust = (float)Math.Round(sumaPopust, 2);

                    set.Cijena = suma;

                    if (set.Popust == null || set.Popust == 0)
                        set.Popust = 0;

                    if (set.Popust > 0)
                    {
                        var popust = 1 - set.Popust / 100;
                        set.CijenaSaPopustom = sumaPopust;
                    }
                    else
                    {
                        set.CijenaSaPopustom = suma;
                    }

                    Database.Setovi entity = mapper.Map<Database.Setovi>(set);
                    entity.NarudzbaId = narudzbaId;
                    context.Add(entity);
                    sumaUkupno += (float)entity.CijenaSaPopustom!;
                }
            }
            var narudzba = context.Narudzbes.Where(x => x.NarudzbaId == narudzbaId).FirstOrDefault();
            if(narudzba!=null)
                narudzba.UkupnaCijena += sumaUkupno;
            if(narudzba!=null)
                context.Update(narudzba);
            context.SaveChanges();
            return mapper.Map<NarudzbeDTO>(narudzba!);


        }
    }
}
