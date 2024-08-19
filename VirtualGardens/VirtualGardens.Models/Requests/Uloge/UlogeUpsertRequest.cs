using System;
using System.Collections.Generic;
using System.Text;

namespace VirtualGardens.Models.Requests.Uloge
{
    public class UlogeUpdateRequest
    {
        public string Naziv { get; set; } = null!;

        public string? Opis { get; set; }
    }
}
