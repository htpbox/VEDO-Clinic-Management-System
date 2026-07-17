using MediCore.Application.Common;
using MediCore.Domain.Enums;

namespace MediCore.Application.Interfaces.Services;

public interface INotificationService
{
    /// <summary>
    /// Finds today's un-reminded, booked appointments (via the existing
    /// IAppointmentRepository.GetPendingRemindersAsync), sends a reminder to
    /// each patient with a phone/email on file, and marks ReminderSent.
    /// Returns how many were sent.
    /// </summary>
    Task<int> SendDueAppointmentRemindersAsync();

    Task<ApiResponse<string>> SendTestNotificationAsync(string to, NotificationChannel channel);
}
