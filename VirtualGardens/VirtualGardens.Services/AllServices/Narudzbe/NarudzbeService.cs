using Azure.Core;
using MapsterMapper;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml.Schema;
using VirtualGardens.Models.DTOs;
using VirtualGardens.Models.Requests;
using VirtualGardens.Models.Requests.Narudzbe;
using VirtualGardens.Models.SearchObjects;
using VirtualGardens.Services.AllServices.Proizvodi;
using VirtualGardens.Services.BaseServices;
using VirtualGardens.Services.Database;
using VirtualGardens.Services.NarudzbeStateMachine;

namespace VirtualGardens.Services.AllServices.Narudzbe
{
    public class NarudzbeService : BaseCRUDService<Models.DTOs.NarudzbeDTO, NarudzbeSearchObject, Database.Narudzbe, NarudzbeUpsertRequest, NarudzbeUpsertRequest>, INarudzbeService
    {
        public BaseNarudzbaState baseNarudzbaState { get; set; }
        ILogger<ProizvodiService> logger;
        public NarudzbeService(_210011Context _context, IMapper _mapper, BaseNarudzbaState _baseNarudzbaState, ILogger<ProizvodiService> _logger) : base(_context, _mapper)
        {
            baseNarudzbaState = _baseNarudzbaState;
            logger = _logger;
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
                if(search.NalogId == 0)
                {
                    query = query.Where(x => x.NalogId == null);
                }
                if (search.NalogId.HasValue && search.NalogId.Value!=0)
                {
                    query = query.Where(x => x.NalogId == search.NalogId.Value);
                }

                if (search?.isDeleted != null)
                {
                    query = query.Where(x => x.IsDeleted == search.isDeleted);
                }

                if(search?.StateMachine != null)
                {
                    query = query.Where(x=>x.StateMachine == search.StateMachine);
                }
            }

            return query;
        }

        public override NarudzbeDTO Insert(NarudzbeUpsertRequest request)
        {
            int? lastNumber;
            if(!context.Narudzbes.Any())
            {
                lastNumber = 0;
            }
            else
            {
                var lastOrderNumberSplit = (context.Narudzbes.OrderBy(x => x.NarudzbaId).Last().BrojNarudzbe).Split('-');
                lastNumber = Int32.Parse(lastOrderNumberSplit[1]);
            }
            request.BrojNarudzbe = $"NAR-{lastNumber + 1}";

            var state = baseNarudzbaState.CreateState("initial");
            return state.Insert(request);
        }

        public override NarudzbeDTO Update(int id, NarudzbeUpsertRequest request)
        {
            var entity = GetById(id);
            var state = baseNarudzbaState.CreateState(entity.StateMachine!);
            return state.Update(id,request);
        }

        public NarudzbeDTO InProgress(int id)
        {
            var entity = GetById(id);
            var state = baseNarudzbaState.CreateState(entity.StateMachine!);
            return state.InProgress(id);
        }

        public NarudzbeDTO Edit(int id)
        {
            var entity = GetById(id);
            var state = baseNarudzbaState.CreateState(entity.StateMachine!);
            return state.Edit(id);
        }

        public NarudzbeDTO Finish(int id)
        {
            var entity = GetById(id);
            var state = baseNarudzbaState.CreateState(entity.StateMachine!);
            return state.Finish(id);
        }

        public override void Delete(int id)
        {
            var entity = GetById(id);
            var state = baseNarudzbaState.CreateState(entity.StateMachine!);
            state.Delete(id);
        }

        public List<string> AllowedActions(int id)
        {
            logger.LogInformation($"Allowed action called for {id}");
            if(id <= 0)
            {
                var state = baseNarudzbaState.CreateState("initial");
                return state.AllowedActions(null);
            }
            else
            {
                var entity = context.Narudzbes.Find(id);

                var state = baseNarudzbaState.CreateState(entity!.StateMachine!);
                return state.AllowedActions(entity);
            }
        }

        public List<int> MonthlyStatistics(int year)
        {
            var list = context.Narudzbes.Where(x=>x.Datum.Year==year && x.IsDeleted == false).ToList();
            List<int> result = new List<int> { 0,0,0,0,0,0,0,0,0,0,0,0};

            foreach(var item in list)
            {
                result[item.Datum.Month - 1]++;
            }

            return result;
        }

        public List<string> CheckOrderValidity(int orderId)
        {
            var order = context.Narudzbes.Where(x=>x.NarudzbaId==orderId).FirstOrDefault();
            var ordersSets = context.ProizvodiSets.Include(x => x.Set).Where(x => x.Set.NarudzbaId == orderId && x.Set.IsDeleted==false).ToList();
            var ordersProductsWithDuplicates = context.ProizvodiSets.Include(x => x.Proizvod).Where(x => x.Set.NarudzbaId == orderId && x.Set.IsDeleted==false).Select(x=>x.Proizvod).ToList();
            var ordersProducts = ordersProductsWithDuplicates.Distinct().ToList();

            List<string> listOfErrors = [];

            foreach (var item in ordersSets)
            {
                var orderProduct = ordersProducts.Find(x => x.ProizvodId == item.ProizvodId);
                if (orderProduct != null)
                    orderProduct.DostupnaKolicina -= item.Kolicina; 
            }

            foreach (var item in ordersProducts)
            {
                if(item.DostupnaKolicina<0)
                {
                    listOfErrors.Add($"Naručili ste previše {item.Naziv}, prekoračili ste dostupnu količinu za {int.Abs(item.DostupnaKolicina)}");
                }
            }

            return listOfErrors;

        }
    }
}
