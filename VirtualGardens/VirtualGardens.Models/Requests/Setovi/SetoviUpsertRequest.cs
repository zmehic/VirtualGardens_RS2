using System;
using System.Collections.Generic;
using System.Text;
using VirtualGardens.Models.Requests.ProizvodiSetovi;

namespace VirtualGardens.Models.Requests.Setovi
{
    public class SetoviUpsertRequest
    {
        public float Cijena { get; set; }

        public int? Popust { get; set; }

        public int? NarudzbaId { get; set; }

        public float? CijenaSaPopustom { get; set; }

        public List<ProizvodiSetoviUpsertRequest>? ProizvodiSets { get; set; }
    }
}
