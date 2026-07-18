using MediCore.Domain.Common;

namespace MediCore.Domain.Entities.Inventory;

public class InventoryCategory : BaseEntity
{
    public Guid TenantId { get; set; }
    public string Name { get; set; } = string.Empty;
    public Guid? ParentCategoryId { get; set; }

    public InventoryCategory? ParentCategory { get; set; }
}
