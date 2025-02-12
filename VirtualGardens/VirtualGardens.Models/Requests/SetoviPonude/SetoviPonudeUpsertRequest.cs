using System;
using System.Collections.Generic;
using System.Text;

namespace VirtualGardens.Models.Requests.SetoviPonude
{
    public class SetoviPonudeUpsertRequest
    {
        public int SetId { get; set; }

        public int PonudaId { get; set; }
    }
}
