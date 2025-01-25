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
        public SetoviService(_210011Context _context, IMapper _mapper) : base(_context, _mapper)
        {
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
            var narudzba = context.Narudzbes.Where(x => x.NarudzbaId == entity.NarudzbaId).FirstOrDefault();
            if(narudzba!=null && entity!=null)
                narudzba.UkupnaCijena -= (float)entity.CijenaSaPopustom!;

            context.SaveChanges();

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
                    float cijena = context.Proizvodis.Where(x => x.ProizvodId == item.ProizvodId).FirstOrDefault()?.Cijena ?? 0.0f;
                    if (cijena != 0.0f && item != null)
                    {
                        float ukupnacijena = item.Kolicina * cijena;
                        float ukupnacijenaPopust = (float)item.Kolicina * (float)Math.Round((cijena * (1 - (float)((float)request.Popust! / 100))),2);
                        suma += ukupnacijena;
                        sumaPopust += ukupnacijenaPopust;
                    }
                }
            }

            suma = (float)Math.Round(suma, 2);
            sumaPopust = (float)Math.Round(sumaPopust, 2);

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
            var setovi = context.Setovis.Where(x => x.NarudzbaId == request.NarudzbaId && x.IsDeleted==false).ToList();
            var narudzba = context.Narudzbes.Where(x => x.NarudzbaId == request.NarudzbaId).FirstOrDefault();

            float ukupnacijena = 0.0f;
            foreach (var x in setovi)
            {
                ukupnacijena += x.CijenaSaPopustom ?? 0;
            }
            if (narudzba != null)
            {
                narudzba.UkupnaCijena = ukupnacijena;
                context.Update(narudzba);
            }
            context.SaveChanges();

            base.AfterInsert(request, entity);
        }


    }
}
