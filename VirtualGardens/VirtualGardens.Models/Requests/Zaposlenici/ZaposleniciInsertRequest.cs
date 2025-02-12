using System;
using System.Collections.Generic;
using System.Text;

namespace VirtualGardens.Models.Requests.Zaposlenici
{
    public class ZaposleniciInsertRequest
    {
        public string Email { get; set; }

        public string Ime { get; set; }

        public string Prezime { get; set; }

        public string? BrojTelefona { get; set; }

        public string? Adresa { get; set; }

        public string? Grad { get; set; }

        public string? Drzava { get; set; }
        public bool JeAktivan { get; set; }

        public DateTime? DatumRodjenja { get; set; }
    }
}
