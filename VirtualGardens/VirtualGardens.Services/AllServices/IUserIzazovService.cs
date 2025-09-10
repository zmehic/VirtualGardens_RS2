using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using VirtualGardens.Models.DTOs;
using VirtualGardens.Models.Requests;
using VirtualGardens.Models.Requests.Nalozi;
using VirtualGardens.Models.SearchObjects;
using VirtualGardens.Services.BaseInterfaces;
using VirtualGardens.Services.Database;

namespace VirtualGardens.Services.AllServices
{
    public interface IUserIzazovService : ICRUDService<Models.DTOs.KorisnikIzazovDTO, IzazovSearchObject, IzazovUpsertRequest, IzazovUpsertRequest>
    {
        public bool CheckDuplicate(PeerIzazovUpsertRequest request);
        public ChallengeReward14072025? CheckNagrada(KorisnikIzazovDTO izazov);
        public List<StatistikaDTO> GetStatistika(IzazovSearchObject searchObject);
        public List<IzazovDTO> GetIzazovi();
        public bool Activate(int peerIzazovId);
        public bool InsertChallenge(PeerIzazovUpsertRequest request);
        public bool End(int peerIzazovId);
        public bool Begin(int peerIzazovId);
    }
}
