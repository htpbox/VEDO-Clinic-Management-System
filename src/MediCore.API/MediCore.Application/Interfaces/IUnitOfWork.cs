using MediCore.Application.Interfaces.Repositories;

namespace MediCore.Application.Interfaces;

public interface IUnitOfWork : IDisposable
{
    // Repositories
    IPatientRepository Patients { get; }
    IAppointmentRepository Appointments { get; }
    IEncounterRepository Encounters { get; }
    IPrescriptionRepository Prescriptions { get; }
    IInvoiceRepository Invoices { get; }
    IPaymentRepository Payments { get; }
    IUserRepository Users { get; }

    // Transaction Management
    Task<int> SaveChangesAsync(CancellationToken cancellationToken = default);
    Task BeginTransactionAsync();
    Task CommitTransactionAsync();
    Task RollbackTransactionAsync();
}