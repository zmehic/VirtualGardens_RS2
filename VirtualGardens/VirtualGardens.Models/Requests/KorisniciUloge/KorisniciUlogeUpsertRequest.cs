using System;
using System.Collections.Generic;
using System.Text;

namespace VirtualGardens.Models.Requests.KorisniciUloge
{
    public class KorisniciUlogeUpsertRequest
    {
        public int UlogaId { get; set; }

        public int KorisnikId { get; set; }

    }
}
