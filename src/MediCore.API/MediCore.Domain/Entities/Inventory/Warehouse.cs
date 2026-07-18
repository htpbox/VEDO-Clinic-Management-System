using MediCore.Domain.Common;

namespace MediCore.Domain.Entities.Inventory;

public class Warehouse : BaseEntity
{
    public Guid TenantId { get; set; }
    public Guid BranchId { get; set; }
    public string Name { get; set; } = string.Empty;
    public string? Location { get; set; }
    public bool IsActive { get; set; } = true;

    public Branch Branch { get; set; } = null!;
}
