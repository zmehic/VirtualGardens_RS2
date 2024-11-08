using System;
using System.Collections.Generic;
using System.Text;

namespace VirtualGardens.Models.Requests
{
    public class KorisniciUpdateRequest
    {
        public string KorisnickoIme { get; set; }
        public string? Lozinka { get; set; }

        public string? LozinkaPotvrda { get; set; }
        public string? StaraLozinka { get; set; }

        public string Email { get; set; }

        public string Ime { get; set; } = null!;

        public string Prezime { get; set; } = null!;

        public string? BrojTelefona { get; set; }

        public string? Adresa { get; set; }

        public string? Grad { get; set; }

        public string? Drzava { get; set; }

        public DateTime? DatumRodjenja { get; set; }
        public byte[]? Slika { get; set; }

    }
}
