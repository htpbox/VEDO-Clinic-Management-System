namespace MediCore.Application.Interfaces.Services;

/// <summary>
/// Abstraction over the actual delivery mechanism for a notification.
/// Swap the registered implementation (see InfrastructureServiceExtensions)
/// once a real Email/SMS/WhatsApp provider is chosen. Until then,
/// LoggingNotificationSender is registered by default: it logs what would
/// have been sent and returns success, so the rest of the system (reminder
/// scheduling, ReminderSent flags, retry logic) can be built and exercised
/// without a live vendor account.
/// </summary>
public interface INotificationSender
{
    Task<bool> SendAsync(NotificationMessage message);
}
