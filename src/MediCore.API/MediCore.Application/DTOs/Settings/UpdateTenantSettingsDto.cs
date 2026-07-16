namespace MediCore.Application.DTOs.Settings;

public class UpdateTenantSettingsDto
{
    public string Name { get; set; } = string.Empty;
    public string? NameEn { get; set; }
    public string? Phone { get; set; }
    public string? Email { get; set; }
    public string? Address { get; set; }
    public string? City { get; set; }
    public string? Governorate { get; set; }
    public string? TaxNumber { get; set; }
}
