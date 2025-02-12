using System;
using System.Collections.Generic;
using VirtualGardens.Services.BaseInterfaces;

namespace VirtualGardens.Services.Database;

public partial class JediniceMjere:ISoftDeletable
{
    public int JedinicaMjereId { get; set; }

    public string Naziv { get; set; } = null!;

    public string? Skracenica { get; set; }

    public string? Opis { get; set; }

    public virtual ICollection<Proizvodi> Proizvodis { get; set; } = new List<Proizvodi>();
    public bool IsDeleted { get; set; } = false;
    public DateTime? VrijemeBrisanja { get; set; }
}
