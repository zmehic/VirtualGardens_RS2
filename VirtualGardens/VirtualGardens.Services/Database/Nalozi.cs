using System;
using System.Collections.Generic;

namespace VirtualGardens.Services.Database;

public partial class Nalozi
{
    public int NalogId { get; set; }

    public string BrojNaloga { get; set; } = null!;

    public DateTime DatumKreiranja { get; set; } = DateTime.Now;

    public int ZaposlenikId { get; set; }

    public bool Zavrsen { get; set; } = false;

    public virtual ICollection<Narudzbe> Narudzbes { get; set; } = new List<Narudzbe>();

    public virtual Zaposlenici Zaposlenik { get; set; } = null!;
}
