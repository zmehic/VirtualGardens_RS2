using System;
using System.Collections.Generic;
using System.Text;

namespace VirtualGardens.Models.DTOs
{
    public class NaloziDTO
    {
        public int NalogId { get; set; }

        public string BrojNaloga { get; set; } = null!;

        public DateTime DatumKreiranja { get; set; }

        public int ZaposlenikId { get; set; }

        public bool Zavrsen { get; set; }
        
        public virtual ICollection<NarudzbeDTO> Narudzbes { get; set; } = new List<NarudzbeDTO>();

        public virtual ZaposleniciDTO Zaposlenik { get; set; } = null!;
    }
}
