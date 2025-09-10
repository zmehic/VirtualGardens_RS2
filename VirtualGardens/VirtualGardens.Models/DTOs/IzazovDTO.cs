using System;
using System.Collections.Generic;
using System.Text;

namespace VirtualGardens.Models.DTOs
{
    public class IzazovDTO
    {
        public int Id { get; set; }
        public string Naziv { get; set; }
        public string PraviloUspjeha { get; set; }
        public Tip Tip { get; set; }
    }
}
