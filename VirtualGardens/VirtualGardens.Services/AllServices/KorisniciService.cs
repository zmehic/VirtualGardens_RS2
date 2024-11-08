using MapsterMapper;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.InteropServices;
using System.Text;
using System.Threading.Tasks;
using VirtualGardens.Models.DTOs;
using VirtualGardens.Models.Exceptions;
using VirtualGardens.Models.Requests;
using VirtualGardens.Models.SearchObjects;
using VirtualGardens.Services.Auth;
using VirtualGardens.Services.BaseServices;
using VirtualGardens.Services.Database;

namespace VirtualGardens.Services.AllServices
{
    public class KorisniciService : BaseCRUDService<Models.DTOs.KorisniciDTO, KorisniciSearchObject, Database.Korisnici, KorisniciInsertRequest, KorisniciUpdateRequest>, IKorisniciService
    {
        private readonly ILogger<KorisniciService> _logger;
        private readonly IPasswordService _passwordService;

        public KorisniciService(_210011Context context, IMapper mapper, ILogger<KorisniciService> logger, IPasswordService passwordService) : base(context,mapper)
        {
            _logger = logger;
            this._passwordService = passwordService;
        }

        public override IQueryable<Korisnici> AddFilter(KorisniciSearchObject search, IQueryable<Korisnici> query)
        {
            if(!string.IsNullOrEmpty(search?.ImeGTE))
            {
                query = query.Where(x => x.Ime.ToLower().StartsWith(search.ImeGTE.ToLower()));
            }

            if (!string.IsNullOrEmpty(search?.PrezimeGTE))
            {
                query = query.Where(x => x.Prezime.ToLower().StartsWith(search.PrezimeGTE.ToLower()));
            }

            if (!string.IsNullOrEmpty(search?.KorisnickoImeGTE))
            {
                query = query.Where(x => x.KorisnickoIme.ToLower().StartsWith(search.KorisnickoImeGTE.ToLower()));
            }

            if (!string.IsNullOrEmpty(search?.Email))
            {
                query = query.Where(x => x.Email==search.Email);
            }

            if (!string.IsNullOrEmpty(search?.BrojTelefona))
            {
                query = query.Where(x => x.BrojTelefona == search.BrojTelefona);
            }

            if (search?.isDeleted != null)
            {
                query = query.Where(x => x.IsDeleted == search.isDeleted);
            }


            return query;
        }

        public override void BeforeInsert(KorisniciInsertRequest request, Korisnici entity)
        {
            _logger.LogInformation($"Adding user: {entity.KorisnickoIme}");

            if (string.IsNullOrEmpty(request.Lozinka) || string.IsNullOrEmpty(request.LozinkaPotvrda))
                throw new Exception("Lozinka i potvrda lozinke moraju imati vrijednost");

            if (request.Lozinka != request.LozinkaPotvrda)
                throw new Exception("Lozinka i potvrda lozinke moraju biti iste");

            entity.LozinkaSalt = _passwordService.GenerateSalt();
            entity.LozinkaHash = _passwordService.GenerateHash(entity.LozinkaSalt, request.Lozinka);
            entity.DatumRegistracije = DateTime.Now;
        }

        public override void AfterInsert(KorisniciInsertRequest request, Korisnici entity)
        {
            if (request.Uloge != null && request.Uloge.Count > 0)
            {
                foreach (var u in request.Uloge)
                {
                    Context.KorisniciUloges.Add(new Database.KorisniciUloge
                    {
                        KorisnikId = entity.KorisnikId,
                        UlogaId = u
                    });
                }
                Context.SaveChanges();
            }

        }

        public override void BeforeUpdate(KorisniciUpdateRequest request, Korisnici entity)
        {

            if ((request.Lozinka != null && !string.IsNullOrEmpty(request.Lozinka)) && (request.LozinkaPotvrda != null && !string.IsNullOrEmpty(request.LozinkaPotvrda)))
            {
                if (request.StaraLozinka == null)
                    throw new UserException("Morate poslati staru lozinku!");
                var lozinkaCheck = _passwordService.GenerateHash(entity.LozinkaSalt, request.StaraLozinka) == entity.LozinkaHash;
                if (lozinkaCheck == false)
                    throw new UserException("Pogrešna stara lozinka");
                if (request.Lozinka == request.LozinkaPotvrda)
                {
                    entity.LozinkaHash = _passwordService.GenerateHash(entity.LozinkaSalt, request.Lozinka);
                }
            }
        }


        public Models.DTOs.KorisniciDTO Login(string username, string password)
        {
            var entity = Context
                .Korisnicis
                .Include(x => x.KorisniciUloges)
                    .ThenInclude(y => y.Uloga).FirstOrDefault(x => x.KorisnickoIme == username);

            if (entity == null)
            {
                return null;
            }

            var hash = _passwordService.GenerateHash(entity.LozinkaSalt, password);

            if (hash != entity.LozinkaHash)
            {
                return null;
            }
            entity.ZadnjiLogin = DateTime.Now;
            Context.SaveChanges();
            var mapped = this.Mapper.Map<Models.DTOs.KorisniciDTO>(entity);

            return mapped;
        }

    }
}
