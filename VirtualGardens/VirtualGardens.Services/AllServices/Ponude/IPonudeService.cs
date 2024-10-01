using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using VirtualGardens.Models.DTOs;
using VirtualGardens.Models.Requests;
using VirtualGardens.Models.Requests.Ponude;
using VirtualGardens.Models.Requests.SetoviPonude;
using VirtualGardens.Models.SearchObjects;
using VirtualGardens.Services.AllServices.SetoviPonude;
using VirtualGardens.Services.BaseInterfaces;

namespace VirtualGardens.Services.AllServices.Ponude
{
    public interface IPonudeService : ICRUDService<Models.DTOs.PonudeDTO, PonudeSearchObject, PonudeUpsertRequest, PonudeUpsertRequest>
    {
        public PonudeDTO Activate(int id);
        public PonudeDTO Edit(int id);
        public PonudeDTO Finish(int id);
        public PonudeDTO AddSet(SetoviPonudeUpsertRequest request);
        public List<string> AllowedActions(int id);
    }
}
