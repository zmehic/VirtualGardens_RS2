using System;
using System.Collections.Generic;
using System.Text;

namespace VirtualGardens.Models.DTOs
{
    public class PitanjaOdgovoriDTO
    {
        public int PitanjeId { get; set; }

        public string Tekst { get; set; } = null!;

        public DateTime Datum { get; set; }

        public int KorisnikId { get; set; }

        public int NarudzbaId { get; set; }

        public virtual KorisniciDTO Korisnik { get; set; } = null!;

        public virtual NarudzbeDTO Narudzba { get; set; } = null!;
    }
}
