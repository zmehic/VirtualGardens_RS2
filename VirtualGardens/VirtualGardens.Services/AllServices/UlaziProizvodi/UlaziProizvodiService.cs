﻿using MapsterMapper;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using VirtualGardens.Models.Requests;
using VirtualGardens.Models.Requests.UlaziProizvodi;
using VirtualGardens.Models.SearchObjects;
using VirtualGardens.Services.BaseServices;
using VirtualGardens.Services.Database;

namespace VirtualGardens.Services.AllServices.UlaziProizvodi
{
    public class UlaziProizvodiService : BaseCRUDService<Models.DTOs.UlaziProizvodiDTO, UlaziProizvodiSearchObject, Database.UlaziProizvodi, UlaziProizvodiUpsertRequest, UlaziProizvodiUpsertRequest>, IUlaziProizvodiService
    {
        public UlaziProizvodiService(_210011Context _context, IMapper _mapper) : base(_context, _mapper)
        {
        }

        public override IQueryable<Database.UlaziProizvodi> AddFilter(UlaziProizvodiSearchObject search, IQueryable<Database.UlaziProizvodi> query)
        {
            if (search.UlazId.HasValue)
            {
                query = query.Where(x => x.UlazId == search.UlazId.Value);
            }

            if (search.ProizvodId.HasValue)
            {
                query = query.Where(x => x.ProizvodId == search.ProizvodId.Value);
            }

            if (search.KolicinaFrom.HasValue)
            {
                query = query.Where(x => x.Kolicina >= search.KolicinaFrom.Value);
            }

            if (search.KolicinaTo.HasValue)
            {
                query = query.Where(x => x.Kolicina <= search.KolicinaTo.Value);
            }

            if (search?.isDeleted != null)
            {
                query = query.Where(x => x.IsDeleted == search.isDeleted);
            }

            return query;
        }

        public override void AfterInsert(UlaziProizvodiUpsertRequest request, Database.UlaziProizvodi entity)
        {
            var proizvod = context.Set<Database.Proizvodi>().Find(request.ProizvodId);

            if (proizvod != null)
            {
                proizvod.DostupnaKolicina += request.Kolicina;
                context.Update<Database.Proizvodi>(proizvod);
            }

            context.SaveChanges();

        }

        public override void BeforeDelete(int id, Database.UlaziProizvodi entity)
        {
            var proizvod = context.Set<Database.Proizvodi>().Find(entity.ProizvodId);

            if(proizvod != null)
            {
                proizvod.DostupnaKolicina -= entity.Kolicina;
                context.Update<Database.Proizvodi>(proizvod);
            }

            context.SaveChanges();
        }

    }
}
