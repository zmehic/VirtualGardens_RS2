using MapsterMapper;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Internal;
using Microsoft.Identity.Client;
using Microsoft.ML;
using Microsoft.ML.Data;
using Microsoft.ML.Trainers;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Dynamic.Core;
using System.Runtime.CompilerServices;
using System.Text;
using System.Threading.Tasks;
using VirtualGardens.Models.DTOs;
using VirtualGardens.Models.Requests;
using VirtualGardens.Models.Requests.Proizvodi;
using VirtualGardens.Models.SearchObjects;
using VirtualGardens.Services.AllServices;
using VirtualGardens.Services.BaseServices;
using VirtualGardens.Services.Database;
using VirtualGardens.Services.Recommender;

namespace VirtualGardens.Services
{
    public class ProizvodiService : BaseCRUDService<Models.DTOs.ProizvodiDTO, ProizvodiSearchObject, Database.Proizvodi, ProizvodiUpsertRequest, ProizvodiUpsertRequest>, IProizvodiService
    {
        public _210011Context Context { get; set; }
        public IMapper Mapper { get; set; }
        public IRecommenderService _recommenderService;
        public ProizvodiService(_210011Context context, IMapper mapper, IRecommenderService recommenderService) : base(context, mapper)
        {
            Context = context;
            Mapper = mapper;
            _recommenderService= recommenderService;
        }

        public override IQueryable<Services.Database.Proizvodi> AddFilter(ProizvodiSearchObject search, IQueryable<Services.Database.Proizvodi> query)
        {
            // Filter by name using "Greater Than or Equal To" (GTE) for partial matches
            if (!string.IsNullOrEmpty(search.NazivGTE))
            {
                query = query.Where(x => x.Naziv.ToLower().StartsWith(search.NazivGTE.ToLower()));
            }

            // Filter by price range
            if (search.CijenaFrom.HasValue)
            {
                query = query.Where(x => x.Cijena >= search.CijenaFrom.Value);
            }

            if (search.CijenaTo.HasValue)
            {
                query = query.Where(x => x.Cijena <= search.CijenaTo.Value);
            }

            // Filter by available quantity range
            if (search.DostupnaKolicinaFrom.HasValue)
            {
                query = query.Where(x => x.DostupnaKolicina >= search.DostupnaKolicinaFrom.Value);
            }

            if (search.DostupnaKolicinaTo.HasValue)
            {
                query = query.Where(x => x.DostupnaKolicina <= search.DostupnaKolicinaTo.Value);
            }

            // Filter by unit of measure ID
            if (search.JedinicaMjereId.HasValue)
            {
                query = query.Where(x => x.JedinicaMjereId == search.JedinicaMjereId.Value);
            }

            // Filter by product type ID
            if (search.VrstaProizvodaId.HasValue)
            {
                query = query.Where(x => x.VrstaProizvodaId == search.VrstaProizvodaId.Value);
            }
            if (search?.isDeleted != null)
            {
                query = query.Where(x => x.IsDeleted == search.isDeleted);
            }

            return query;
        }

        public bool RecalcuclateQuantity()
        {
            var proizvodi = Context.Set<Proizvodi>().Where(x=>x.IsDeleted==false).ToList();

            foreach (var item in proizvodi)
            {
                var ulaziProizvodi = Context.Set<UlaziProizvodi>().Where(x=>x.ProizvodId==item.ProizvodId && x.IsDeleted==false && x.Ulaz.IsDeleted==false).ToList();

                int suma = 0;
                if(ulaziProizvodi.Count > 0)
                {
                    foreach (var item2 in ulaziProizvodi)
                    {
                        suma += item2.Kolicina;
                    }
                }
                item.DostupnaKolicina = suma;
                Context.Update<Proizvodi>(item);
            }
            Context.SaveChanges();
            return true;
        }

        public List<ProizvodiDTO> Recommend(int id)
        {
            return _recommenderService.Recommend(id);
        }

        public void TrainModel()
        {
            _recommenderService.TrainModel();
        }
    }

    public class Copurchase_prediction
    {
        public float Score { get; set; }
    }

    public class ProductEntry
    {
        [KeyType(count:262111)]
        public uint ProductID { get; set; }
        [KeyType(count: 262111)]
        public uint CoPurchaseProductID { get; set; }

        public float Label { get; set; }
    }
}
