using MediCore.Application.Common;
using MediCore.Application.DTOs.Appointment;

namespace MediCore.Application.Interfaces.Services;

public interface IAppointmentService
{
    Task<ApiResponse<AppointmentDto>> GetByIdAsync(Guid tenantId, Guid appointmentId);
    Task<ApiResponse<IEnumerable<AppointmentDto>>> SearchByDateAsync(
        Guid tenantId, DateOnly date, Guid? doctorId);
    Task<ApiResponse<AppointmentDto>> CreateAsync(
        Guid tenantId, Guid branchId, Guid createdBy, CreateAppointmentDto dto);
    Task<ApiResponse<AppointmentDto>> CancelAsync(
        Guid tenantId, Guid appointmentId, CancelAppointmentDto dto);
    Task<ApiResponse<IEnumerable<QueueAppointmentDto>>> GetQueueAsync(
        Guid tenantId, DateOnly date, Guid? doctorId);
    Task<ApiResponse<AppointmentDto>> CheckInAsync(Guid tenantId, Guid appointmentId);
    Task<ApiResponse<AppointmentDto>> AddToQueueAsync(Guid tenantId, Guid appointmentId);
    Task<ApiResponse<AppointmentDto>> CallPatientAsync(Guid tenantId, Guid appointmentId);
    Task<ApiResponse<AppointmentDto>> CompleteVisitAsync(Guid tenantId, Guid appointmentId);
}