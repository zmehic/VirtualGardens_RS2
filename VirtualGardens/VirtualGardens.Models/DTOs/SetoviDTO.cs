using System;
using System.Collections.Generic;
using System.Text;

namespace VirtualGardens.Models.DTOs
{
    public class SetoviDTO
    {
        public int SetId { get; set; }

        public float Cijena { get; set; }

        public int? Popust { get; set; }

        public int? NarudzbaId { get; set; }

        public float? CijenaSaPopustom { get; set; }

        public virtual NarudzbeDTO Narudzba { get; set; } = null!;

        public virtual ICollection<ProizvodiSetDTO>? ProizvodiSets { get; set; }

        //public virtual ICollection<SetoviPonude> SetoviPonudes { get; set; } = new List<SetoviPonude>();
    }
}
