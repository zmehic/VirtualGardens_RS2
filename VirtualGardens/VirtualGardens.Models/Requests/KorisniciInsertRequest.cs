using System;
using System.Collections.Generic;
using System.Text;

namespace VirtualGardens.Models.Requests
{
    public class KorisniciInsertRequest
    {
        public string KorisnickoIme { get; set; }

        public string Lozinka { get; set; }

        public string LozinkaPotvrda { get; set; }

        public string Email { get; set; }

        public string Ime { get; set; }

        public string Prezime { get; set; }

        public string? BrojTelefona { get; set; }

        public string? Adresa { get; set; }

        public string? Grad { get; set; }

        public string? Drzava { get; set; }

        public DateTime? DatumRodjenja { get; set; }
        public List<int> Uloge { get; set; }
    }
}
