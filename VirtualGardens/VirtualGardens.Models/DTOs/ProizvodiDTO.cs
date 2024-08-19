using System;
using System.Collections.Generic;
using System.Text;

namespace VirtualGardens.Models.DTOs
{
    public class ProizvodiDTO
    {
        public int ProizvodId { get; set; }

        public string Naziv { get; set; } = null!;

        public string? Opis { get; set; }

        public float Cijena { get; set; }

        public int DostupnaKolicina { get; set; }

        public byte[]? Slika { get; set; }

        public int JedinicaMjereId { get; set; }

        public int VrstaProizvodaId { get; set; }

        public byte[]? SlikaThumb { get; set; }

        public virtual JediniceMjereDTO JedinicaMjere { get; set; } = null!;

        //public virtual ICollection<ProizvodiSet> ProizvodiSets { get; set; } = new List<ProizvodiSet>();

        //public virtual ICollection<Recenzije> Recenzijes { get; set; } = new List<Recenzije>();

        //public virtual ICollection<UlaziProizvodi> UlaziProizvodis { get; set; } = new List<UlaziProizvodi>();

        public virtual VrsteProizvodaDTO VrstaProizvoda { get; set; } = null!;
    }
}
