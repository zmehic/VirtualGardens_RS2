using System;
using System.Collections.Generic;
using VirtualGardens.Services.BaseInterfaces;

namespace VirtualGardens.Services.Database;

public partial class Setovi : ISoftDeletable
{
    public int SetId { get; set; }

    public float Cijena { get; set; }

    public int? Popust { get; set; }

    public int? NarudzbaId { get; set; }

    public float? CijenaSaPopustom { get; set; }

    public virtual Narudzbe Narudzba { get; set; } = null!;

    public virtual ICollection<ProizvodiSet> ProizvodiSets { get; set; } = new List<ProizvodiSet>();

    public virtual ICollection<SetoviPonude> SetoviPonudes { get; set; } = new List<SetoviPonude>();

    public bool IsDeleted { get; set; } = false;
    public DateTime? VrijemeBrisanja { get; set; }
}
