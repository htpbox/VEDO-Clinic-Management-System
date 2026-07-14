using MediCore.Application.Common;
using MediCore.Application.DTOs.Appointment;
using MediCore.Application.Interfaces;
using MediCore.Application.Interfaces.Services;
using MediCore.Domain.Entities.Medical;
using MediCore.Domain.Enums;

namespace MediCore.Application.Services;

public class AppointmentService : IAppointmentService
{
    private readonly IUnitOfWork _unitOfWork;

    public AppointmentService(IUnitOfWork unitOfWork)
    {
        _unitOfWork = unitOfWork;
    }

    public async Task<ApiResponse<AppointmentDto>> GetByIdAsync(Guid tenantId, Guid appointmentId)
    {
        var appointment = await _unitOfWork.Appointments.GetByIdAsync(appointmentId);

        if (appointment == null || appointment.TenantId != tenantId)
            return ApiResponse<AppointmentDto>.Fail("الموعد غير موجود");

        return ApiResponse<AppointmentDto>.Ok(MapToDto(appointment));
    }

    public async Task<ApiResponse<IEnumerable<AppointmentDto>>> SearchByDateAsync(
        Guid tenantId, DateOnly date, Guid? doctorId)
    {
        var appointments = await _unitOfWork.Appointments.FindAsync(a =>
            a.TenantId == tenantId &&
            a.AppointmentDate == date &&
            (doctorId == null || a.DoctorId == doctorId));

        var ordered = appointments.OrderBy(a => a.StartTime);
        return ApiResponse<IEnumerable<AppointmentDto>>.Ok(ordered.Select(MapToDto));
    }

    public async Task<ApiResponse<AppointmentDto>> CreateAsync(
        Guid tenantId, Guid branchId, Guid createdBy, CreateAppointmentDto dto)
    {
        var existingAppointments = await _unitOfWork.Appointments.FindAsync(a =>
            a.TenantId == tenantId &&
            a.DoctorId == dto.DoctorId &&
            a.AppointmentDate == dto.AppointmentDate &&
            a.Status != AppointmentStatus.Cancelled);

        var hasConflict = existingAppointments.Any(a =>
            dto.StartTime < a.EndTime && dto.EndTime > a.StartTime);

        if (hasConflict)
            return ApiResponse<AppointmentDto>.Fail("يوجد تعارض في الموعد مع حجز آخر لنفس الطبيب");

        var appointment = new Appointment
        {
            TenantId = tenantId,
            BranchId = branchId,
            PatientId = dto.PatientId,
            DoctorId = dto.DoctorId,
            AppointmentDate = dto.AppointmentDate,
            StartTime = dto.StartTime,
            EndTime = dto.EndTime,
            ChiefComplaint = dto.ChiefComplaint,
            Notes = dto.Notes,
            Status = AppointmentStatus.Booked,
            CreatedBy = createdBy
        };

        await _unitOfWork.Appointments.AddAsync(appointment);
        await _unitOfWork.SaveChangesAsync();

        return ApiResponse<AppointmentDto>.Ok(MapToDto(appointment), "تم حجز الموعد بنجاح");
    }

    public async Task<ApiResponse<AppointmentDto>> CancelAsync(
        Guid tenantId, Guid appointmentId, CancelAppointmentDto dto)
    {
        var appointment = await _unitOfWork.Appointments.GetByIdAsync(appointmentId);

        if (appointment == null || appointment.TenantId != tenantId)
            return ApiResponse<AppointmentDto>.Fail("الموعد غير موجود");

        if (appointment.Status == AppointmentStatus.Done || appointment.Status == AppointmentStatus.Cancelled)
            return ApiResponse<AppointmentDto>.Fail("لا يمكن إلغاء موعد منتهٍ أو ملغى بالفعل");

        appointment.Status = AppointmentStatus.Cancelled;
        appointment.CancellationReason = dto.CancellationReason;

        await _unitOfWork.Appointments.UpdateAsync(appointment);
        await _unitOfWork.SaveChangesAsync();

        return ApiResponse<AppointmentDto>.Ok(MapToDto(appointment), "تم إلغاء الموعد");
    }

    public async Task<ApiResponse<IEnumerable<QueueAppointmentDto>>> GetQueueAsync(
        Guid tenantId, DateOnly date, Guid? doctorId)
    {
        var appointments = await _unitOfWork.Appointments.GetQueueAsync(tenantId, date, doctorId);
        var doctors = await _unitOfWork.Users.GetByTenantAsync(tenantId);
        var doctorNames = doctors.ToDictionary(d => d.Id, d => d.FullName);

        var items = appointments.Select(a => new QueueAppointmentDto
        {
            Id = a.Id,
            PatientId = a.PatientId,
            PatientFullName = a.Patient.FullName,
            PatientFileNumber = a.Patient.FileNumber,
            PatientPhone = a.Patient.Phone,
            DoctorId = a.DoctorId,
            DoctorFullName = doctorNames.TryGetValue(a.DoctorId, out var name) ? name : "-",
            StartTime = a.StartTime.ToString("HH:mm"),
            EndTime = a.EndTime.ToString("HH:mm"),
            Status = a.Status.ToString(),
            ChiefComplaint = a.ChiefComplaint,
            ArrivedAt = a.ArrivedAt,
            StartedAt = a.StartedAt
        });

        return ApiResponse<IEnumerable<QueueAppointmentDto>>.Ok(items);
    }

    public async Task<ApiResponse<AppointmentDto>> CheckInAsync(Guid tenantId, Guid appointmentId)
    {
        var appointment = await _unitOfWork.Appointments.GetByIdAsync(appointmentId);
        if (appointment == null || appointment.TenantId != tenantId)
            return ApiResponse<AppointmentDto>.Fail("الموعد غير موجود");

        if (appointment.Status != AppointmentStatus.Booked)
            return ApiResponse<AppointmentDto>.Fail("لا يمكن تسجيل الوصول إلا لموعد بحالة (محجوز)");

        appointment.Status = AppointmentStatus.Arrived;
        appointment.ArrivedAt = DateTime.UtcNow;

        await _unitOfWork.Appointments.UpdateAsync(appointment);
        await _unitOfWork.SaveChangesAsync();

        return ApiResponse<AppointmentDto>.Ok(MapToDto(appointment), "تم تسجيل وصول المريض");
    }

    public async Task<ApiResponse<AppointmentDto>> AddToQueueAsync(Guid tenantId, Guid appointmentId)
    {
        var appointment = await _unitOfWork.Appointments.GetByIdAsync(appointmentId);
        if (appointment == null || appointment.TenantId != tenantId)
            return ApiResponse<AppointmentDto>.Fail("الموعد غير موجود");

        if (appointment.Status != AppointmentStatus.Arrived)
            return ApiResponse<AppointmentDto>.Fail("لا يمكن الإضافة للطابور إلا لمريض بحالة (حضر)");

        appointment.Status = AppointmentStatus.Waiting;

        await _unitOfWork.Appointments.UpdateAsync(appointment);
        await _unitOfWork.SaveChangesAsync();

        return ApiResponse<AppointmentDto>.Ok(MapToDto(appointment), "تمت إضافة المريض للطابور");
    }

    public async Task<ApiResponse<AppointmentDto>> CallPatientAsync(Guid tenantId, Guid appointmentId)
    {
        var appointment = await _unitOfWork.Appointments.GetByIdAsync(appointmentId);
        if (appointment == null || appointment.TenantId != tenantId)
            return ApiResponse<AppointmentDto>.Fail("الموعد غير موجود");

        if (appointment.Status != AppointmentStatus.Waiting)
            return ApiResponse<AppointmentDto>.Fail("لا يمكن استدعاء المريض إلا وهو بحالة (في الانتظار)");

        appointment.Status = AppointmentStatus.InProgress;
        appointment.StartedAt = DateTime.UtcNow;

        await _unitOfWork.Appointments.UpdateAsync(appointment);
        await _unitOfWork.SaveChangesAsync();

        return ApiResponse<AppointmentDto>.Ok(MapToDto(appointment), "تم استدعاء المريض");
    }

    public async Task<ApiResponse<AppointmentDto>> CompleteVisitAsync(Guid tenantId, Guid appointmentId)
    {
        var appointment = await _unitOfWork.Appointments.GetByIdAsync(appointmentId);
        if (appointment == null || appointment.TenantId != tenantId)
            return ApiResponse<AppointmentDto>.Fail("الموعد غير موجود");

        if (appointment.Status != AppointmentStatus.InProgress)
            return ApiResponse<AppointmentDto>.Fail("لا يمكن إنهاء الزيارة إلا وهي بحالة (مع الطبيب)");

        appointment.Status = AppointmentStatus.Done;
        appointment.EndedAt = DateTime.UtcNow;

        await _unitOfWork.Appointments.UpdateAsync(appointment);
        await _unitOfWork.SaveChangesAsync();

        return ApiResponse<AppointmentDto>.Ok(MapToDto(appointment), "تم إنهاء الزيارة");
    }

    private static AppointmentDto MapToDto(Appointment appointment)
    {
        return new AppointmentDto
        {
            Id = appointment.Id,
            PatientId = appointment.PatientId,
            DoctorId = appointment.DoctorId,
            AppointmentDate = appointment.AppointmentDate,
            StartTime = appointment.StartTime,
            EndTime = appointment.EndTime,
            Status = appointment.Status.ToString(),
            ChiefComplaint = appointment.ChiefComplaint,
            Notes = appointment.Notes,
            CancellationReason = appointment.CancellationReason,
            CreatedAt = appointment.CreatedAt
        };
    }
}