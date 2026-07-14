using MediCore.Domain.Common;

namespace MediCore.Domain.Entities;

public class Tenant : BaseEntity
{
    public string Name { get; set; } = string.Empty;
    public string? NameEn { get; set; }
    public string Slug { get; set; } = string.Empty;
    public string? LogoUrl { get; set; }
    public string? Phone { get; set; }
    public string? Email { get; set; }
    public string? Address { get; set; }
    public string? City { get; set; }
    public string? Governorate { get; set; }
    public string? TaxNumber { get; set; }
    public bool IsActive { get; set; } = true;

    // Navigation Properties — ستُضاف بعد إنشاء باقي الكيانات
}