using System;
using System.Collections.Generic;
using System.Text;

namespace VirtualGardens.Models.Requests.Ponude
{
    public class PonudeUpsertRequest
    {
        public string Naziv { get; set; } = null!;

        public int? Popust { get; set; }

    }
}
