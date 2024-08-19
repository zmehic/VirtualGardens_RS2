using System;
using System.Collections.Generic;
using System.Text;

namespace VirtualGardens.Models.Requests.Narudzbe
{
    public class NarudzbeUpsertRequest
    {
        public string BrojNarudzbe { get; set; } = null!;

        public int UkupnaCijena { get; set; }

        public int KorisnikId { get; set; }

        public int? NalogId { get; set; }

        // Optional: Include related entities if needed
        // For example, you might include DTOs or related IDs
        // public List<int>? PitanjaOdgovorisIds { get; set; }
        // public List<int>? SetovisIds { get; set; }
    }
}
