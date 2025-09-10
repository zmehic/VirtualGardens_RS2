using System;

namespace VirtualGardens.Models.SearchObjects
{
    public class IzazovSearchObject : BaseSearchObject
    {
        public Status? Status { get; set; }
        public Tip? Tip { get; set; }
        public DateTime? Datum { get; set; }
    }
}
