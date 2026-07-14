using MediCore.Domain.Common;
using MediCore.Domain.Enums;

namespace MediCore.Domain.Entities;

public class UserProfile : BaseEntity
{
    public Guid TenantId { get; set; }
    public Guid? BranchId { get; set; }
    public string FullName { get; set; } = string.Empty;
    public string Email { get; set; } = string.Empty;
    public string PasswordHash { get; set; } = string.Empty;
    public string? Phone { get; set; }
    public string? AvatarUrl { get; set; }
    public UserRole Role { get; set; }
    public bool IsActive { get; set; } = true;
    public bool MustChangePassword { get; set; } = true;
    public bool TwoFactorEnabled { get; set; } = false;
    public DateTime? LastLoginAt { get; set; }

    // Navigation Properties
    public Tenant Tenant { get; set; } = null!;
    public Branch? Branch { get; set; }
}