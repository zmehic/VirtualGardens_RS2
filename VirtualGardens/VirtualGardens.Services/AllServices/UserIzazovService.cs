using MapsterMapper;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using VirtualGardens.Models;
using VirtualGardens.Models.DTOs;
using VirtualGardens.Models.Exceptions;
using VirtualGardens.Models.Requests;
using VirtualGardens.Models.Requests.Nalozi;
using VirtualGardens.Models.SearchObjects;
using VirtualGardens.Services.AllServices.Nalozi;
using VirtualGardens.Services.BaseServices;
using VirtualGardens.Services.Database;

namespace VirtualGardens.Services.AllServices
{
    public class UserIzazovService : BaseCRUDService<Models.DTOs.KorisnikIzazovDTO, IzazovSearchObject, Database.UserChallenge14072024, IzazovUpsertRequest, IzazovUpsertRequest>, IUserIzazovService
    {
        public UserIzazovService(_210011Context _context, IMapper _mapper) : base(_context, _mapper)
        {
        }

        public bool Activate(int peerIzazovId)
        {
            var izazov = context.PeerChallenges.Where(x=>x.Id == peerIzazovId).FirstOrDefault();

            izazov.Status = PeerStatus.Prihvacen;

            var userIzazov = new UserChallenge14072024
            {
                DatumPrihvatanja = DateTime.UtcNow,
                BrojPonavljanja = 0,
                IzazovId = izazov.IzazovId,
                KorisnikId = izazov.KorisnikIzazvaniId,
                Status = Status.Prihvacen,

            };

            context.UserChallenges.Add(userIzazov);

            context.SaveChanges();
            return true;
        }

        public override IQueryable<UserChallenge14072024> AddFilter(IzazovSearchObject search, IQueryable<UserChallenge14072024> query)
        {
            if (search != null)
            {
                if (search.Datum.HasValue)
                {
                    query = query.Where(x => x.DatumPrihvatanja == search.Datum.Value);
                }

                if (search.Status.HasValue)
                {
                    query = query.Where(x => x.Status == search.Status.Value);
                }

                if (search.Tip.HasValue)
                {
                    query = query.Where(x => x.Izazov.Tip == search.Tip.Value);
                }
            }

            return query;
        }

        public bool CheckDuplicate(PeerIzazovUpsertRequest request)
        {
            var aktivniIzazov = context.PeerChallenges.Where(x => x.KorisnikIzazvaniId == request.KorisnikIzazvaniId && x.KorisnikIzazivac == x.KorisnikIzazivac && x.Status == Models.PeerStatus.Prihvacen).FirstOrDefault();

            if (aktivniIzazov == null)
                return false;
            return true;
        }

        public ChallengeReward14072025? CheckNagrada(KorisnikIzazovDTO izazov)
        {
            var nagrada = context.ChallengeRewards.Where(x => x.IzazovId == izazov.Id).FirstOrDefault();

            if (nagrada == null)
                return null;

            if (izazov.BrojPonavljanja == nagrada.BrojPonavljanja)
                return nagrada;

            return null;
        }

        public bool End(int peerIzazovId)
        {
            var izazov = context.UserChallenges.Where(x => x.Id == peerIzazovId).FirstOrDefault();

            if (izazov == null)
                return false;

            izazov.Status = Status.Zavrsen;
            izazov.VrijemeZavrsetka = DateTime.UtcNow;

            var nagrada = CheckNagrada(new KorisnikIzazovDTO
            {
                Status = izazov.Status,
                BrojPonavljanja = izazov.BrojPonavljanja,
                DatumPrihvatanja = izazov.DatumPrihvatanja,
                IzazovId = izazov.IzazovId,
                KorisnikId = izazov.KorisnikId,
                VrijemeZavrsetka = izazov.VrijemeZavrsetka
            });

            if(nagrada!= null)
            {

            }

            context.SaveChanges();
            return true;
        }

        public bool Begin(int peerIzazovId)
        {
            var izazov = context.UserChallenges.Where(x => x.Id == peerIzazovId).FirstOrDefault();

            if (izazov == null)
                return false;

            izazov.Status = Status.UToku;

            context.SaveChanges();
            return true;
        }

        public List<IzazovDTO> GetIzazovi()
        {
            var izazovi = context.Challenges.Select(x => new IzazovDTO
            {
                Id = x.Id,
                Naziv = x.Naziv,
                PraviloUspjeha = x.PraviloUspjeha,
                Tip = x.Tip
            }).ToList();

            return izazovi;
        }

        public List<StatistikaDTO> GetStatistika(IzazovSearchObject searchObject)
        {
            var izazovi = context.UserChallenges.Include(x => x.Izazov).AsQueryable();
            izazovi = AddFilter(searchObject,izazovi);
            var statistika = izazovi.Select(x => new
            {
                Tipp = x.Izazov.Tip,
                Idd = x.Id
            }).GroupBy(x => x.Tipp, x => x.Idd, (key, g) => new StatistikaDTO
            {
                Naziv = key == Tip.Fizicki ? "Fizicki" : key == Tip.Edukativni ? "Edukativni" : "Drustveni",
                Broj = g.Count()
            }).ToList();

            return statistika;
        }

        public bool InsertChallenge(PeerIzazovUpsertRequest request)
        {
            var challenge = new PeerChallenge14072025
            {
                DatumKreiranja = request.DatumKreiranja,
                IzazovId = request.IzazovId,
                KorisnikIzazivacId = request.KorisnikIzazivacId,
                KorisnikIzazvaniId = request.KorisnikIzazvaniId,
                Poruka = request.Poruka,
                Status = PeerStatus.Poslan
            };

            var result = CheckDuplicate(request);

            if (result == true)
                throw new UserException("Ovaj izazov vec postoji");
            context.PeerChallenges.Add(challenge);

            context.SaveChanges();

            return true;
        }
    }
}
