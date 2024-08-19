using System;
using System.Collections.Generic;
using System.Text;

namespace VirtualGardens.Models.DTOs
{
    public class ZaposleniciDTO
    {
        public int ZaposlenikId { get; set; }

        public string Email { get; set; } = null!;

        public string Ime { get; set; } = null!;

        public string Prezime { get; set; } = null!;

        public string? BrojTelefona { get; set; }

        public string? Adresa { get; set; }

        public string? Grad { get; set; }

        public string? Drzava { get; set; }

        public bool JeAktivan { get; set; }

        public DateTime? DatumRodjenja { get; set; }

        //public virtual ICollection<NaloziDTO> Nalozis { get; set; } = new List<NaloziDTO>();
    }
}
