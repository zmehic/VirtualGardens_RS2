using System;
using System.Collections.Generic;
using System.Text;

namespace VirtualGardens.Models.Requests.Nalozi
{
    public class NaloziUpdateRequest
    {
        public string BrojNaloga { get; set; } = null!;

        public int ZaposlenikId { get; set; }

        public bool Zavrsen { get; set; }

        public List<int> Narudzbe { get; set; }
    }
}
