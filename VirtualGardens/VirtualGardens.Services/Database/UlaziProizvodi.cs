using System;
using System.Collections.Generic;
using VirtualGardens.Services.BaseInterfaces;

namespace VirtualGardens.Services.Database;

public partial class UlaziProizvodi: ISoftDeletable
{
    public int UlaziProizvodiId { get; set; }

    public int UlazId { get; set; }

    public int ProizvodId { get; set; }

    public int Kolicina { get; set; }

    public virtual Proizvodi Proizvod { get; set; } = null!;

    public virtual Ulazi Ulaz { get; set; } = null!;

    public bool IsDeleted { get; set; } = false;
    public DateTime? VrijemeBrisanja { get; set; }
}
