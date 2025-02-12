using System;
using System.Collections.Generic;
using System.Text;

namespace VirtualGardens.Models.Requests.Recenzije
{
    public class RecenzijeUpsertRequest
    {
        public int Ocjena { get; set; }

        public string? Komentar { get; set; }

        public int KorisnikId { get; set; }

        public int ProizvodId { get; set; }

    }
}
