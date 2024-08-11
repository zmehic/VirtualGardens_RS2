using System;
using System.Collections.Generic;

namespace VirtualGardens.Services.Database;

public partial class JediniceMjere
{
    public int JedinicaMjereId { get; set; }

    public string Naziv { get; set; } = null!;

    public string? Skracenica { get; set; }

    public string? Opis { get; set; }

    public virtual ICollection<Proizvodi> Proizvodis { get; set; } = new List<Proizvodi>();
}
