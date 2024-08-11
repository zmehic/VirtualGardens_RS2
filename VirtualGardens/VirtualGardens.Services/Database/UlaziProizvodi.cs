using System;
using System.Collections.Generic;

namespace VirtualGardens.Services.Database;

public partial class UlaziProizvodi
{
    public int UlaziProizvodiId { get; set; }

    public int UlazId { get; set; }

    public int ProizvodId { get; set; }

    public int Kolicina { get; set; }

    public virtual Proizvodi Proizvod { get; set; } = null!;

    public virtual Ulazi Ulaz { get; set; } = null!;
}
