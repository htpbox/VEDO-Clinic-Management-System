using MediCore.Domain.Entities.Medical;

namespace MediCore.Application.Interfaces.Repositories;

public interface IAppointmentRepository : IGenericRepository<Appointment>
{
    Task<IEnumerable<Appointment>> GetQueueAsync(Guid tenantId, DateOnly date, Guid? doctorId);
    Task<IEnumerable<Appointment>> GetByDoctorAndDateAsync(Guid tenantId, Guid doctorId, DateOnly date);
    Task<IEnumerable<Appointment>> GetByPatientAsync(Guid tenantId, Guid patientId);
    Task<IEnumerable<Appointment>> GetTodayAppointmentsAsync(Guid tenantId, Guid branchId);
    Task<bool> HasConflictAsync(Guid doctorId, DateOnly date, TimeOnly startTime, TimeOnly endTime, Guid? excludeId = null);
    Task<IEnumerable<Appointment>> GetPendingRemindersAsync(Guid tenantId);
}