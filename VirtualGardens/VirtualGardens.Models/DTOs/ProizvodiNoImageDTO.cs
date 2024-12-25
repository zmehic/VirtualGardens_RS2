using System;
using System.Collections.Generic;
using System.Text;

namespace VirtualGardens.Models.DTOs
{
    public class ProizvodiNoImageDTO
    {
        public int ProizvodId { get; set; }

        public string Naziv { get; set; } = null!;

        public string? Opis { get; set; }

        public float Cijena { get; set; }

        public int DostupnaKolicina { get; set; }

        public int JedinicaMjereId { get; set; }

        public int VrstaProizvodaId { get; set; }

        public virtual JediniceMjereDTO JedinicaMjere { get; set; } = null!;
        public virtual VrsteProizvodaDTO VrstaProizvoda { get; set; } = null!;
    }
}
