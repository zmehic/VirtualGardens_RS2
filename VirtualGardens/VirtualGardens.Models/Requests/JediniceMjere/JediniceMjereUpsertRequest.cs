using System;
using System.Collections.Generic;
using System.Text;

namespace VirtualGardens.Models.Requests.JediniceMjere
{
    public class JediniceMjereUpsertRequest
    {
        public string Naziv { get; set; } = null!;

        public string? Skracenica { get; set; }

        public string? Opis { get; set; }
    }
}
