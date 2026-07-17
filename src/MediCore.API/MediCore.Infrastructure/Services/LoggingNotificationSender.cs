using MediCore.Application.Interfaces.Services;
using Microsoft.Extensions.Logging;

namespace MediCore.Infrastructure.Services;

/// <summary>
/// Default INotificationSender: does not actually deliver anything, just
/// logs what would have been sent. This exists so the notification
/// scheduling/business logic (reminder detection, ReminderSent tracking,
/// retry semantics) can be built, wired, and exercised without committing
/// to a specific Email/SMS/WhatsApp vendor.
///
/// To go live: implement INotificationSender against a real provider
/// (e.g. Twilio/Vonage for SMS, WhatsApp Business API, SendGrid/SMTP for
/// email) and swap the DI registration in InfrastructureServiceExtensions.
/// That is a vendor and cost decision for the clinic owner - this
/// implementation deliberately does not guess at one.
/// </summary>
public class LoggingNotificationSender : INotificationSender
{
    private readonly ILogger<LoggingNotificationSender> _logger;

    public LoggingNotificationSender(ILogger<LoggingNotificationSender> logger)
    {
        _logger = logger;
    }

    public Task<bool> SendAsync(NotificationMessage message)
    {
        _logger.LogInformation(
            "[NOTIFICATION - NOT ACTUALLY SENT, no provider configured] Channel={Channel} To={To} Subject={Subject} Body={Body}",
            message.Channel, message.To, message.Subject, message.Body);

        return Task.FromResult(true);
    }
}
