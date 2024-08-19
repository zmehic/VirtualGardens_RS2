using System;
using System.Collections.Generic;
using System.Text;

namespace VirtualGardens.Models.Requests.UlaziProizvodi
{
    public class UlaziProizvodiUpsertRequest
    {
        public int UlazId { get; set; }

        public int ProizvodId { get; set; }

        public int Kolicina { get; set; }

    }
}
