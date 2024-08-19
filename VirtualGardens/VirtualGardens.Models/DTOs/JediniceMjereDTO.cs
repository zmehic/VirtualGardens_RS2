using System;
using System.Collections.Generic;
using System.Text;

namespace VirtualGardens.Models.DTOs
{
    public class JediniceMjereDTO
    {
        public int JedinicaMjereId { get; set; }

        public string Naziv { get; set; } = null!;

        public string? Skracenica { get; set; }

        public string? Opis { get; set; }
    }
}
