using System;
using System.Collections.Generic;
using System.Text;

namespace VirtualGardens.Models.DTOs
{
    public class RecenzijeDTO
    {
        public int RecenzijaId { get; set; }

        public int Ocjena { get; set; }

        public string? Komentar { get; set; }

        public int KorisnikId { get; set; }

        public DateTime Datum { get; set; }

        public int ProizvodId { get; set; }

        public virtual KorisniciDTO Korisnik { get; set; } = null!;

        public virtual ProizvodiDTO Proizvod { get; set; } = null!;
    }
}
