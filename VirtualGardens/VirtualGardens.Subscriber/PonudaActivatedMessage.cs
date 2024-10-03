using System;
using System.Collections.Generic;
using System.Text;

namespace VirtualGardens.Subscriber
{
    public class PonudaActivatedMessage
    {
        public string ime { get; set; }
        public string prezime { get; set; }
        public string email { get; set; }
        public string nazivPonude { get; set; }
        public int? popust { get; set; }
    }
}
