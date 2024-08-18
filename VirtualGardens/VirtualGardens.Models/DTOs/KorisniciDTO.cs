using System;
using System.Collections.Generic;
using System.Text;

namespace VirtualGardens.Models.DTOs
{
    public class KorisniciDTO
    {
        public int KorisnikId { get; set; }

        public string KorisnickoIme { get; set; }

        public string Lozinka { get; set; }

        public string Email { get; set; }

        public string Ime { get; set; } 

        public string Prezime { get; set; }

        public string? BrojTelefona { get; set; }

        public string? Adresa { get; set; }

        public string? Grad { get; set; }

        public string? Drzava { get; set; }

        public DateTime DatumRegistracije { get; set; }

        public DateTime? ZadnjiLogin { get; set; }

        public bool JeAktivan { get; set; }

        public DateTime? DatumRodjenja { get; set; }

        public virtual ICollection<KorisniciUlogeDTO> KorisniciUloges { get; set; } = new List<KorisniciUlogeDTO>();

        //public virtual ICollection<Narudzbe> Narudzbes { get; set; } = new List<Narudzbe>();

        //public virtual ICollection<PitanjaOdgovori> PitanjaOdgovoris { get; set; } = new List<PitanjaOdgovori>();

        //public virtual ICollection<Recenzije> Recenzijes { get; set; } = new List<Recenzije>();

        //public virtual ICollection<Ulazi> Ulazis { get; set; } = new List<Ulazi>();
    }
}
