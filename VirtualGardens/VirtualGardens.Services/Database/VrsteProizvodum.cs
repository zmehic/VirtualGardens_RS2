using System;
using System.Collections.Generic;

namespace VirtualGardens.Services.Database;

public partial class VrsteProizvodum
{
    public int VrstaProizvodaId { get; set; }

    public string Naziv { get; set; } = null!;

    public virtual ICollection<Proizvodi> Proizvodis { get; set; } = new List<Proizvodi>();
}
