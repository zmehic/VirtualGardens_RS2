using System;
using System.Collections.Generic;
using System.Text;

namespace VirtualGardens.Models.DTOs
{
    public class UlaziProizvodiDTO
    {
        public int UlaziProizvodiId { get; set; }

        public int UlazId { get; set; }

        public int ProizvodId { get; set; }

        public int Kolicina { get; set; }

        public virtual ProizvodiDTO Proizvod { get; set; } = null!;

        public virtual UlaziDTO Ulaz { get; set; } = null!;
    }
}
