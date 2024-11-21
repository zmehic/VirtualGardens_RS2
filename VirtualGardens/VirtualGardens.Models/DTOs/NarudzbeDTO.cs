using System;
using System.Collections.Generic;
using System.Text;

namespace VirtualGardens.Models.DTOs
{
    public class NarudzbeDTO
    {
        public int NarudzbaId { get; set; }

        public string BrojNarudzbe { get; set; } = null!;

        public bool? Otkazana { get; set; }

        public DateTime Datum { get; set; }

        public bool Placeno { get; set; }

        public bool? Status { get; set; }
        public string? StateMachine { get; set; }

        public int UkupnaCijena { get; set; }

        public int KorisnikId { get; set; }

        public int? NalogId { get; set; }

        // Optional: Include simplified versions of related entities if needed
        public KorisniciDTO? Korisnik { get; set; }

        // public NaloziDTO? Nalog { get; set; }

        // Optional: Include simplified lists if needed
        //public List<PitanjaOdgovoriDTO>? PitanjaOdgovoris { get; set; }

        //public List<SetoviDTO>? Setovis { get; set; }
    }
}
