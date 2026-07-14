using MediCore.Domain.Common;

namespace MediCore.Domain.Entities;

public class Branch : BaseEntity
{
    public Guid TenantId { get; set; }
    public string Name { get; set; } = string.Empty;
    public string? Address { get; set; }
    public string? Phone { get; set; }
    public bool IsMain { get; set; } = false;
    public bool IsActive { get; set; } = true;

    // Navigation Properties
    public Tenant Tenant { get; set; } = null!;
}