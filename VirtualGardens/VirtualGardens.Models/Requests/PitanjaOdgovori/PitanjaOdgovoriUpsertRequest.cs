using System;
using System.Collections.Generic;
using System.Text;

namespace VirtualGardens.Models.Requests.PitanjaOdgovori
{
    public class PitanjaOdgovoriUpsertRequest
    {
        public string Tekst { get; set; } = null!;

        public int KorisnikId { get; set; }

        public int NarudzbaId { get; set; }

    }
}
