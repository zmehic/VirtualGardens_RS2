using System;
using System.Collections.Generic;
using System.Text;

namespace VirtualGardens.Models.DTOs
{
    public class UlaziDTO
    {
        public int UlazId { get; set; }

        public string BrojUlaza { get; set; } = null!;

        public DateTime DatumUlaza { get; set; }

        public int KorisnikId { get; set; }

        public virtual KorisniciDTO Korisnik { get; set; } = null!;

        //public virtual ICollection<UlaziProizvodi> UlaziProizvodis { get; set; } = new List<UlaziProizvodi>();
    }
}
