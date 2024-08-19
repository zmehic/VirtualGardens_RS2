using System;
using System.Collections.Generic;

namespace VirtualGardens.Services.Database;

public partial class Ponude
{
    public int PonudaId { get; set; }

    public string Naziv { get; set; } = null!;

    public int? Popust { get; set; }

    public DateTime DatumKreiranja { get; set; } = DateTime.Now;

    public virtual ICollection<SetoviPonude> SetoviPonudes { get; set; } = new List<SetoviPonude>();
}
