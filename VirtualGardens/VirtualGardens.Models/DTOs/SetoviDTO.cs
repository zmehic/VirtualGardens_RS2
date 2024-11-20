using System;
using System.Collections.Generic;
using System.Text;

namespace VirtualGardens.Models.DTOs
{
    public class SetoviDTO
    {
        public int SetId { get; set; }

        public int Cijena { get; set; }

        public int? Popust { get; set; }

        public int? NarudzbaId { get; set; }

        public int? CijenaSaPopustom { get; set; }

        public virtual NarudzbeDTO Narudzba { get; set; } = null!;

        public virtual ICollection<ProizvodiSetDTO> ProizvodiSets { get; set; } = new List<ProizvodiSetDTO>();

        //public virtual ICollection<SetoviPonude> SetoviPonudes { get; set; } = new List<SetoviPonude>();
    }
}
