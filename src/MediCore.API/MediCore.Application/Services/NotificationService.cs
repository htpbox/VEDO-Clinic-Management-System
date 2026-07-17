using MediCore.Application.Common;
using MediCore.Application.Interfaces;
using MediCore.Domain.Entities.Medical;
using MediCore.Domain.Enums;
using Microsoft.Extensions.Logging;

namespace MediCore.Application.Services;

public class NotificationService : INotificationService
{
    private readonly IUnitOfWork _unitOfWork;
    private readonly INotificationSender _sender;
    private readonly ILogger<NotificationService> _logger;

    public NotificationService(
        IUnitOfWork unitOfWork,
        INotificationSender sender,
        ILogger<NotificationService> logger)
    {
        _unitOfWork = unitOfWork;
        _sender = sender;
        _logger = logger;
    }

    public async Task<int> SendDueAppointmentRemindersAsync()
    {
        var tenants = await _unitOfWork.Tenants.GetAllAsync();
        var sentCount = 0;

        foreach (var tenant in tenants)
        {
            var appointments = await _unitOfWork.Appointments.GetPendingRemindersAsync(tenant.Id);
            sentCount += await SendRemindersForAsync(appointments);
        }

        return sentCount;
    }

    private async Task<int> SendRemindersForAsync(IEnumerable<Appointment> appointments)
    {
        var sentCount = 0;

        foreach (var appointment in appointments)
        {
            var patient = appointment.Patient;
            if (patient == null) continue;

            var body = $"تذكير بموعدك في {appointment.AppointmentDate:yyyy-MM-dd} " +
                       $"الساعة {appointment.StartTime}";

            var sent = false;

            if (!string.IsNullOrWhiteSpace(patient.Phone))
            {
                sent = await _sender.SendAsync(new NotificationMessage
                {
                    Channel = NotificationChannel.Sms,
                    To = patient.Phone,
                    Body = body,
                });
            }
            else if (!string.IsNullOrWhiteSpace(patient.Email))
            {
                sent = await _sender.SendAsync(new NotificationMessage
                {
                    Channel = NotificationChannel.Email,
                    To = patient.Email,
                    Subject = "تذكير بموعدك",
                    Body = body,
                });
            }
            else
            {
                _logger.LogWarning(
                    "Appointment {AppointmentId} has no patient phone/email on file - reminder skipped",
                    appointment.Id);
                continue;
            }

            if (sent)
            {
                appointment.ReminderSent = true;
                await _unitOfWork.Appointments.UpdateAsync(appointment);
                sentCount++;
            }
        }

        if (sentCount > 0)
            await _unitOfWork.SaveChangesAsync();

        return sentCount;
    }

    public async Task<ApiResponse<string>> SendTestNotificationAsync(string to, NotificationChannel channel)
    {
        var sent = await _sender.SendAsync(new NotificationMessage
        {
            Channel = channel,
            To = to,
            Subject = "رسالة اختبار من MediCore",
            Body = "هذه رسالة اختبار للتأكد من عمل نظام الإشعارات.",
        });

        return sent
            ? ApiResponse<string>.Ok("تم إرسال الإشعار التجريبي")
            : ApiResponse<string>.Fail("فشل إرسال الإشعار التجريبي");
    }
}
