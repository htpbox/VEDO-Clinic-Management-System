using MediCore.Application.Interfaces.Repositories;
using MediCore.Domain.Entities.Medical;
using MediCore.Infrastructure.Data;
using Microsoft.EntityFrameworkCore;

namespace MediCore.Infrastructure.Repositories;

public class AppointmentRepository : GenericRepository<Appointment>, IAppointmentRepository
{
    private new readonly MediCoreDbContext _context;

    public AppointmentRepository(MediCoreDbContext context) : base(context)
    {
        _context = context;
    }

    public async Task<IEnumerable<Appointment>> GetQueueAsync(
        Guid tenantId, DateOnly date, Guid? doctorId)
    {
        var query = _context.Set<Appointment>()
            .Include(a => a.Patient)
            .Where(a => a.TenantId == tenantId
                && a.AppointmentDate == date
                && !a.IsDeleted);

        if (doctorId.HasValue)
            query = query.Where(a => a.DoctorId == doctorId.Value);

        return await query.OrderBy(a => a.StartTime).ToListAsync();
    }

    public async Task<IEnumerable<Appointment>> GetByDoctorAndDateAsync(
        Guid tenantId, Guid doctorId, DateOnly date)
    {
        return await _context.Set<Appointment>()
            .Where(a => a.TenantId == tenantId
                && a.DoctorId == doctorId
                && a.AppointmentDate == date
                && !a.IsDeleted)
            .OrderBy(a => a.StartTime)
            .ToListAsync();
    }

    public async Task<IEnumerable<Appointment>> GetByPatientAsync(Guid tenantId, Guid patientId)
    {
        return await _context.Set<Appointment>()
            .Where(a => a.TenantId == tenantId
                && a.PatientId == patientId
                && !a.IsDeleted)
            .OrderByDescending(a => a.AppointmentDate)
            .ThenByDescending(a => a.StartTime)
            .ToListAsync();
    }

    public async Task<IEnumerable<Appointment>> GetTodayAppointmentsAsync(Guid tenantId, Guid branchId)
    {
        var today = DateOnly.FromDateTime(DateTime.UtcNow);
        return await _context.Set<Appointment>()
            .Include(a => a.Patient)
            .Where(a => a.TenantId == tenantId
                && a.BranchId == branchId
                && a.AppointmentDate == today
                && !a.IsDeleted)
            .OrderBy(a => a.StartTime)
            .ToListAsync();
    }

    public async Task<bool> HasConflictAsync(
        Guid doctorId, DateOnly date, TimeOnly startTime, TimeOnly endTime, Guid? excludeId = null)
    {
        var query = _context.Set<Appointment>()
            .Where(a => a.DoctorId == doctorId
                && a.AppointmentDate == date
                && a.Status != Domain.Enums.AppointmentStatus.Cancelled
                && !a.IsDeleted
                && startTime < a.EndTime
                && endTime > a.StartTime);

        if (excludeId.HasValue)
            query = query.Where(a => a.Id != excludeId.Value);

        return await query.AnyAsync();
    }

    public async Task<IEnumerable<Appointment>> GetPendingRemindersAsync(Guid tenantId)
    {
        var today = DateOnly.FromDateTime(DateTime.UtcNow);
        return await _context.Set<Appointment>()
            .Include(a => a.Patient)
            .Where(a => a.TenantId == tenantId
                && a.AppointmentDate == today
                && !a.ReminderSent
                && a.Status == Domain.Enums.AppointmentStatus.Booked
                && !a.IsDeleted)
            .ToListAsync();
    }
}