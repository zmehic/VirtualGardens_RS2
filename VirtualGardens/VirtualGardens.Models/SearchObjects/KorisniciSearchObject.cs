using System;
using System.Collections.Generic;
using System.Text;

namespace VirtualGardens.Models.SearchObjects
{
    public class KorisniciSearchObject : BaseSearchObject
    {
        public string? KorisnickoImeGTE { get; set; }

        public string? ImeGTE { get; set; }

        public string? PrezimeGTE { get; set; }

        public string? Email { get; set; }

        public string? BrojTelefona { get; set; }

        public int? UlogaId { get; set; }

    }
}
