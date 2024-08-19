﻿using MapsterMapper;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using VirtualGardens.Models.Requests;
using VirtualGardens.Models.Requests.Proizvodi;
using VirtualGardens.Models.SearchObjects;
using VirtualGardens.Services.AllServices;
using VirtualGardens.Services.BaseServices;
using VirtualGardens.Services.Database;

namespace VirtualGardens.Services
{
    public class ProizvodiService : BaseCRUDService<Models.DTOs.ProizvodiDTO, ProizvodiSearchObject, Database.Proizvodi, ProizvodiUpsertRequest, ProizvodiUpsertRequest>, IProizvodiService
    {
        public ProizvodiService(_210011Context context, IMapper mapper) : base(context, mapper)
        {
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

            return query;
        }
    }
}
