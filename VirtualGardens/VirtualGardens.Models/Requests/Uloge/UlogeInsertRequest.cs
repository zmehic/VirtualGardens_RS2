using System;
using System.Collections.Generic;
using System.Text;

namespace VirtualGardens.Models.Requests.Uloge
{
    public class UlogeInsertRequest
    {
        public string Naziv { get; set; }

        public string? Opis { get; set; }
    }
}
