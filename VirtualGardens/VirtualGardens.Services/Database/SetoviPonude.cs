using System;
using System.Collections.Generic;
using VirtualGardens.Services.BaseInterfaces;

namespace VirtualGardens.Services.Database;

public partial class SetoviPonude : ISoftDeletable
{
    public int SetoviPonudeId { get; set; }

    public int SetId { get; set; }

    public int PonudaId { get; set; }

    public virtual Ponude Ponuda { get; set; } = null!;

    public virtual Setovi Set { get; set; } = null!;
    public bool IsDeleted { get; set; } = false;
    public DateTime? VrijemeBrisanja { get; set; }
}
