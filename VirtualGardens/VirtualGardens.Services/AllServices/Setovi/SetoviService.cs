using MapsterMapper;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using VirtualGardens.Models.DTOs;
using VirtualGardens.Models.Requests;
using VirtualGardens.Models.Requests.Setovi;
using VirtualGardens.Models.SearchObjects;
using VirtualGardens.Services.BaseServices;
using VirtualGardens.Services.Database;

namespace VirtualGardens.Services.AllServices.Setovi
{
    public class SetoviService : BaseCRUDService<Models.DTOs.SetoviDTO, SetoviSearchObject, Database.Setovi, SetoviUpsertRequest, SetoviUpsertRequest>, ISetoviService
    {
        public _210011Context _210011Context { get; set; }
        public SetoviService(_210011Context context, IMapper mapper) : base(context, mapper)
        {
            _210011Context = context;
        }

        public override IQueryable<Database.Setovi> AddFilter(SetoviSearchObject search, IQueryable<Database.Setovi> query)
        {
            if (search.CijenaFrom.HasValue)
            {
                query = query.Where(x => x.Cijena >= search.CijenaFrom.Value);
            }

            if (search.CijenaTo.HasValue)
            {
                query = query.Where(x => x.Cijena <= search.CijenaTo.Value);
            }

            if (search.PopustFrom.HasValue)
            {
                query = query.Where(x => x.Popust >= search.PopustFrom.Value);
            }

            if (search.PopustTo.HasValue)
            {
                query = query.Where(x => x.Popust <= search.PopustTo.Value);
            }

            if (search.NarudzbaId.HasValue)
            {
                query = query.Where(x => x.NarudzbaId == search.NarudzbaId.Value);
            }

            if (search.CijenaSaPopustomFrom.HasValue)
            {
                query = query.Where(x => x.CijenaSaPopustom >= search.CijenaSaPopustomFrom.Value);
            }

            if (search.CijenaSaPopustomTo.HasValue)
            {
                query = query.Where(x => x.CijenaSaPopustom <= search.CijenaSaPopustomTo.Value);
            }

            if (search?.isDeleted != null)
            {
                query = query.Where(x => x.IsDeleted == search.isDeleted);
            }

            return query;
        }

        public override void AfterDelete(int id, Database.Setovi entity)
        {
            var narudzba = _210011Context.Narudzbes.Where(x => x.NarudzbaId == entity.NarudzbaId).FirstOrDefault();
            if(narudzba!=null && entity!=null)
                narudzba.UkupnaCijena -= (float)entity.CijenaSaPopustom!;

            _210011Context.SaveChanges();

            return;
        }
        public override SetoviDTO Insert(SetoviUpsertRequest request)
        {
            float suma = 0;
            float sumaPopust = 0;
            if (request.ProizvodiSets != null && request.ProizvodiSets.Count > 0)
            {
                foreach (var item in request.ProizvodiSets)
                {
                    var cijena = _210011Context.Proizvodis.Where(x => x.ProizvodId == item.ProizvodId).FirstOrDefault()?.Cijena;
                    if (cijena != null && item != null)
                    {
                        var ukupnacijena = item.Kolicina * cijena;
                        var ukupnacijenaPopust = item.Kolicina * (cijena * (1 - (request.Popust / 100)));
                        suma += ukupnacijena != null ? (float)ukupnacijena : 0.0f;
                        sumaPopust += ukupnacijenaPopust != null ? (float)ukupnacijenaPopust : 0.0f;
                    }
                }
            }
            request.Cijena = suma;

            if (request.Popust == null || request.Popust == 0)
                request.Popust = 0;

            if (request.Popust > 0)
            {
                var popust = 1 - request.Popust / 100;
                request.CijenaSaPopustom = sumaPopust;
            }
            else
            {
                request.CijenaSaPopustom = suma;
            }

            return base.Insert(request);
        }

        public override void AfterInsert(SetoviUpsertRequest request, Database.Setovi entity)
        {
            var setovi = _210011Context.Setovis.Where(x => x.NarudzbaId == request.NarudzbaId && x.IsDeleted==false).ToList();
            var narudzba = _210011Context.Narudzbes.Where(x => x.NarudzbaId == request.NarudzbaId).FirstOrDefault();

            float ukupnacijena = 0.0f;
            foreach (var x in setovi)
            {
                ukupnacijena += x.CijenaSaPopustom ?? 0;
            }

            narudzba.UkupnaCijena = ukupnacijena;
            _210011Context.Update(narudzba);
            _210011Context.SaveChanges();

            base.AfterInsert(request, entity);
        }


    }
}
