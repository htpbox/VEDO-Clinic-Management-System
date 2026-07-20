using MediCore.Application.Interfaces.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace MediCore.API.Controllers;

[ApiController]
[Route("api/[controller]")]
[Authorize(Roles = "SuperAdmin,ClinicAdmin")]
public class NotificationsController : ControllerBase
{
    private readonly INotificationService _notificationService;

    public NotificationsController(INotificationService notificationService)
    {
        _notificationService = notificationService;
    }

    [HttpPost("test")]
    public async Task<IActionResult> SendTest([FromBody] SendTestNotificationRequest request)
    {
        if (!Enum.TryParse<Domain.Enums.NotificationChannel>(request.Channel, true, out var channel))
            return BadRequest("قناة الإشعار غير صحيحة");

        var result = await _notificationService.SendTestNotificationAsync(request.To, channel);
        return result.Success ? Ok(result) : BadRequest(result);
    }

    /// <summary>
    /// Manually triggers the same reminder pass the background job runs every
    /// 15 minutes - useful for testing without waiting for the interval.
    /// </summary>
    [HttpPost("reminders/run-now")]
    public async Task<IActionResult> RunRemindersNow()
    {
        var count = await _notificationService.SendDueAppointmentRemindersAsync();
        return Ok(new { sent = count });
    }
}

public class SendTestNotificationRequest
{
    public string To { get; set; } = string.Empty;
    public string Channel { get; set; } = "Sms";
}
