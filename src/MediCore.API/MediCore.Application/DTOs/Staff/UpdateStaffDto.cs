namespace MediCore.Application.DTOs.Staff;

public class UpdateStaffDto
{
    public string FullName { get; set; } = string.Empty;
    public string? Phone { get; set; }
    public string Role { get; set; } = string.Empty;
}
