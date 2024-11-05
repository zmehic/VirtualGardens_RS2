using System;
using System.Collections.Generic;
using VirtualGardens.Services.BaseInterfaces;

namespace VirtualGardens.Services.Database;

public partial class Nalozi:ISoftDeletable
{
    public int NalogId { get; set; }

    public string BrojNaloga { get; set; } = null!;

    public DateTime DatumKreiranja { get; set; } = DateTime.Now;

    public int ZaposlenikId { get; set; }

    public bool Zavrsen { get; set; } = false;

    public virtual ICollection<Narudzbe> Narudzbes { get; set; } = new List<Narudzbe>();

    public virtual Zaposlenici Zaposlenik { get; set; } = null!;
    public bool IsDeleted { get; set; } = false;
    public DateTime? VrijemeBrisanja { get; set; }
}
