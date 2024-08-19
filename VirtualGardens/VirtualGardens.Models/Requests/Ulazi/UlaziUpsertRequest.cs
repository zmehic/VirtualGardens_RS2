using System;
using System.Collections.Generic;
using System.Text;

namespace VirtualGardens.Models.Requests.Ulazi
{
    public class UlaziUpsertRequest
    {
        public string BrojUlaza { get; set; } = null!;

        public DateTime DatumUlaza { get; set; }

        public int KorisnikId { get; set; }

    }
}
