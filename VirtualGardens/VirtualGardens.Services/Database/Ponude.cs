using System;
using System.Collections.Generic;
using VirtualGardens.Services.BaseInterfaces;

namespace VirtualGardens.Services.Database;

public partial class Ponude : ISoftDeletable
{
    public int PonudaId { get; set; }

    public string Naziv { get; set; } = null!;

    public int? Popust { get; set; }
    public string? StateMachine { get; set; }

    public DateTime DatumKreiranja { get; set; } = DateTime.Now;

    public virtual ICollection<SetoviPonude> SetoviPonudes { get; set; } = new List<SetoviPonude>();

    public bool IsDeleted { get; set; } = false;
    public DateTime? VrijemeBrisanja { get; set; }
}
