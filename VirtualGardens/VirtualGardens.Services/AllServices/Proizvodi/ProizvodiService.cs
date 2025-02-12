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
using VirtualGardens.Models.Exceptions;
using VirtualGardens.Models.Requests;
using VirtualGardens.Models.Requests.Proizvodi;
using VirtualGardens.Models.SearchObjects;
using VirtualGardens.Services.AllServices;
using VirtualGardens.Services.BaseServices;
using VirtualGardens.Services.Database;
using VirtualGardens.Services.Recommender;

namespace VirtualGardens.Services.AllServices.Proizvodi
{
    public class ProizvodiService : BaseCRUDService<ProizvodiDTO, ProizvodiSearchObject, Database.Proizvodi, ProizvodiUpsertRequest, ProizvodiUpsertRequest>, IProizvodiService
    {
        public IRecommenderService recommenderService;
        public ProizvodiService(_210011Context _context, IMapper _mapper, IRecommenderService _recommenderService) : base(_context, _mapper)
        {
            recommenderService = _recommenderService;
        }

        public override IQueryable<Database.Proizvodi> AddFilter(ProizvodiSearchObject search, IQueryable<Database.Proizvodi> query)
        {

            if (!string.IsNullOrEmpty(search.NazivGTE))
            {
                query = query.Where(x => x.Naziv.ToLower().StartsWith(search.NazivGTE.ToLower()));
            }

            if (search.CijenaFrom.HasValue)
            {
                query = query.Where(x => x.Cijena >= search.CijenaFrom.Value);
            }

            if (search.CijenaTo.HasValue)
            {
                query = query.Where(x => x.Cijena <= search.CijenaTo.Value);
            }

            if (search.DostupnaKolicinaFrom.HasValue)
            {
                query = query.Where(x => x.DostupnaKolicina >= search.DostupnaKolicinaFrom.Value);
            }

            if (search.DostupnaKolicinaTo.HasValue)
            {
                query = query.Where(x => x.DostupnaKolicina <= search.DostupnaKolicinaTo.Value);
            }

            if (search.JedinicaMjereId.HasValue)
            {
                query = query.Where(x => x.JedinicaMjereId == search.JedinicaMjereId.Value);
            }

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

        public override void BeforeInsert(ProizvodiUpsertRequest request, Database.Proizvodi entity)
        {
            var proizvod = context.Proizvodis.Where(x => x.IsDeleted == false && x.Naziv == request.Naziv).FirstOrDefault();
            if (proizvod != null)
            {
                throw new UserException("Već postoji proizvod sa tim nazivom");
            }
        }

        public override void BeforeUpdate(ProizvodiUpsertRequest request, Database.Proizvodi entity)
        {
            var proizvod = context.Proizvodis.Where(x => x.IsDeleted == false && x.Naziv == request.Naziv).FirstOrDefault();
            if (proizvod != null && proizvod.Naziv != entity.Naziv)
            {
                throw new UserException("Već postoji proizvod sa tim nazivom");
            }

        }

        public List<ProizvodiDTO> Recommend(int id)
        {
            return recommenderService.Recommend(id);
        }

        public void TrainModel()
        {
            recommenderService.TrainModel();
        }
    }

    public class Copurchase_prediction
    {
        public float Score { get; set; }
    }

    public class ProductEntry
    {
        [KeyType(count: 262111)]
        public uint ProductID { get; set; }
        [KeyType(count: 262111)]
        public uint CoPurchaseProductID { get; set; }

        public float Label { get; set; }
    }
}
