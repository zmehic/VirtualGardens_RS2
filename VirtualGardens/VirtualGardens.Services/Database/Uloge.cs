using System;
using System.Collections.Generic;

namespace VirtualGardens.Services.Database;

public partial class Uloge
{
    public int UlogaId { get; set; }

    public string Naziv { get; set; } = null!;

    public string? Opis { get; set; }

    public virtual ICollection<KorisniciUloge> KorisniciUloges { get; set; } = new List<KorisniciUloge>();
}
