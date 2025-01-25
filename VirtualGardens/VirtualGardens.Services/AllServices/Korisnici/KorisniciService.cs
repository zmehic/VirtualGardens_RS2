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
using VirtualGardens.Models.Requests.Korisnici;
using VirtualGardens.Models.SearchObjects;
using VirtualGardens.Services.Auth;
using VirtualGardens.Services.BaseServices;
using VirtualGardens.Services.Database;

namespace VirtualGardens.Services.AllServices.Korisnici
{
    public class KorisniciService : BaseCRUDService<KorisniciDTO, KorisniciSearchObject, Database.Korisnici, KorisniciInsertRequest, KorisniciUpdateRequest>, IKorisniciService
    {
        private readonly ILogger<KorisniciService> logger;
        private readonly IPasswordService passwordService;

        public KorisniciService(_210011Context _context, IMapper _mapper, ILogger<KorisniciService> _logger, IPasswordService _passwordService) : base(_context, _mapper)
        {
            logger = _logger;
            passwordService = _passwordService;
        }

        public override IQueryable<Database.Korisnici> AddFilter(KorisniciSearchObject search, IQueryable<Database.Korisnici> query)
        {
            if (!string.IsNullOrEmpty(search?.ImeGTE))
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
                query = query.Where(x => x.Email == search.Email);
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

        public override void BeforeInsert(KorisniciInsertRequest request, Database.Korisnici entity)
        {
            logger.LogInformation($"Adding user: {entity.KorisnickoIme}");

            if (string.IsNullOrEmpty(request.Lozinka) || string.IsNullOrEmpty(request.LozinkaPotvrda))
                throw new Exception("Lozinka i potvrda lozinke moraju imati vrijednost");

            if (request.Lozinka != request.LozinkaPotvrda)
                throw new Exception("Lozinka i potvrda lozinke moraju biti iste");

            entity.LozinkaSalt = passwordService.GenerateSalt();
            entity.LozinkaHash = passwordService.GenerateHash(entity.LozinkaSalt, request.Lozinka);
            entity.DatumRegistracije = DateTime.Now;

        }

        public override void AfterInsert(KorisniciInsertRequest request, Database.Korisnici entity)
        {
            if (request.Uloge != null && request.Uloge.Count > 0)
            {
                foreach (var u in request.Uloge)
                {
                    context.KorisniciUloges.Add(new Database.KorisniciUloge
                    {
                        KorisnikId = entity.KorisnikId,
                        UlogaId = u
                    });
                }
                context.SaveChanges();
            }
            else if (request.Uloge == null)
            {
                var uloga = context.Uloges.Where(x => x.Naziv == "Kupac").FirstOrDefault();
                if (uloga != null)
                {
                    context.KorisniciUloges.Add(new Database.KorisniciUloge
                    {
                        KorisnikId = entity.KorisnikId,
                        UlogaId = uloga.UlogaId
                    });
                }

            }

        }

        public override void BeforeUpdate(KorisniciUpdateRequest request, Database.Korisnici entity)
        {

            if (request.Lozinka != null && !string.IsNullOrEmpty(request.Lozinka) && request.LozinkaPotvrda != null && !string.IsNullOrEmpty(request.LozinkaPotvrda))
            {
                if (request.StaraLozinka == null)
                    throw new UserException("Morate poslati staru lozinku!");
                var lozinkaCheck = passwordService.GenerateHash(entity.LozinkaSalt, request.StaraLozinka) == entity.LozinkaHash;
                if (lozinkaCheck == false)
                    throw new UserException("Pogrešna stara lozinka");
                if (request.Lozinka == request.LozinkaPotvrda)
                {
                    entity.LozinkaHash = passwordService.GenerateHash(entity.LozinkaSalt, request.Lozinka);
                }
            }
        }


        public KorisniciDTO Login(string username, string password)
        {
            var entity = context
                .Korisnicis
                .Include(x => x.KorisniciUloges)
                    .ThenInclude(y => y.Uloga).FirstOrDefault(x => x.KorisnickoIme == username);

            if (entity == null)
            {
                throw new UserException("Ne postoji korisnik u bazi sa tim korisničkim imenom");
            }

            var hash = passwordService.GenerateHash(entity.LozinkaSalt, password);

            if (hash != entity.LozinkaHash)
            {
                throw new UserException("Netačna lozinka ili korisničko ime");
            }
            entity.ZadnjiLogin = DateTime.Now;
            context.SaveChanges();
            var mapped = this.mapper.Map<KorisniciDTO>(entity);

            return mapped;
        }

    }
}
