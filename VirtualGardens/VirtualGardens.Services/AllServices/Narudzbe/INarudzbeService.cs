using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using VirtualGardens.Models.DTOs;
using VirtualGardens.Models.Requests;
using VirtualGardens.Models.Requests.Narudzbe;
using VirtualGardens.Models.SearchObjects;
using VirtualGardens.Services.BaseInterfaces;

namespace VirtualGardens.Services.AllServices.Narudzbe
{
    public interface INarudzbeService : ICRUDService<Models.DTOs.NarudzbeDTO, NarudzbeSearchObject, NarudzbeUpsertRequest, NarudzbeUpsertRequest>
    {
        public NarudzbeDTO InProgress(int id);
        public NarudzbeDTO Edit(int id);
        public NarudzbeDTO Finish(int id);
        public List<string> AllowedActions(int id);
        List<int> MonthlyStatistics(int year);
        public List<string> CheckOrderValidity(int orderId);
    }
}
