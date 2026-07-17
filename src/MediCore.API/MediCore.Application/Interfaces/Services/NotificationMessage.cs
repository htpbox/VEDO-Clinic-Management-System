using MediCore.Domain.Enums;

namespace MediCore.Application.Interfaces.Services;

public class NotificationMessage
{
    public NotificationChannel Channel { get; set; }
    public string To { get; set; } = string.Empty;
    public string? Subject { get; set; }
    public string Body { get; set; } = string.Empty;
}
