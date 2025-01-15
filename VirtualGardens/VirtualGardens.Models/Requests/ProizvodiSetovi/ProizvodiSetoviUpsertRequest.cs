using System;
using System.Collections.Generic;
using System.Text;

namespace VirtualGardens.Models.Requests.ProizvodiSetovi
{
    public class ProizvodiSetoviUpsertRequest
    {
        public int ProizvodId { get; set; }

        public int? SetId { get; set; }

        public int Kolicina { get; set; }
    }
}
