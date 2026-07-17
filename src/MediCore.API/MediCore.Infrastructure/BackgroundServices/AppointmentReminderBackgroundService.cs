using MediCore.Application.Interfaces.Services;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;

namespace MediCore.Infrastructure.BackgroundServices;

/// <summary>
/// Runs every 15 minutes, finds today's booked-and-not-yet-reminded
/// appointments, and sends reminders. Uses IServiceScopeFactory because
/// INotificationService/IUnitOfWork are scoped, while this hosted service
/// itself is a long-lived singleton.
/// </summary>
public class AppointmentReminderBackgroundService : BackgroundService
{
    private static readonly TimeSpan Interval = TimeSpan.FromMinutes(15);

    private readonly IServiceScopeFactory _scopeFactory;
    private readonly ILogger<AppointmentReminderBackgroundService> _logger;

    public AppointmentReminderBackgroundService(
        IServiceScopeFactory scopeFactory,
        ILogger<AppointmentReminderBackgroundService> logger)
    {
        _scopeFactory = scopeFactory;
        _logger = logger;
    }

    protected override async Task ExecuteAsync(CancellationToken stoppingToken)
    {
        while (!stoppingToken.IsCancellationRequested)
        {
            try
            {
                using var scope = _scopeFactory.CreateScope();
                var notificationService = scope.ServiceProvider
                    .GetRequiredService<INotificationService>();

                var sentCount = await notificationService.SendDueAppointmentRemindersAsync();
                if (sentCount > 0)
                    _logger.LogInformation("Sent {Count} appointment reminder(s)", sentCount);
            }
            catch (Exception ex)
            {
                // Never let a single failed run crash the background service.
                _logger.LogError(ex, "Appointment reminder background run failed");
            }

            try
            {
                await Task.Delay(Interval, stoppingToken);
            }
            catch (TaskCanceledException)
            {
                // Expected on shutdown.
            }
        }
    }
}
