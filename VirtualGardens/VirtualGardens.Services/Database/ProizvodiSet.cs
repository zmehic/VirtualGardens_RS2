using System;
using System.Collections.Generic;
using VirtualGardens.Services.BaseInterfaces;

namespace VirtualGardens.Services.Database;

public partial class ProizvodiSet : ISoftDeletable
{
    public int ProizvodSetId { get; set; }

    public int ProizvodId { get; set; }

    public int SetId { get; set; }

    public int Kolicina { get; set; }

    public virtual Proizvodi Proizvod { get; set; } = null!;

    public virtual Setovi Set { get; set; } = null!;

    public bool IsDeleted { get; set; } = false;
    public DateTime? VrijemeBrisanja { get; set; }
}
