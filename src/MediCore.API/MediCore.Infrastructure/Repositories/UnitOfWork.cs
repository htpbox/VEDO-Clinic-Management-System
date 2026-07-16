using MediCore.Application.Interfaces;
using MediCore.Application.Interfaces.Repositories;
using MediCore.Infrastructure.Data;
using Microsoft.EntityFrameworkCore.Storage;

namespace MediCore.Infrastructure.Repositories;

public class UnitOfWork : IUnitOfWork
{
    private readonly MediCoreDbContext _context;
    private IDbContextTransaction? _transaction;

    private IPatientRepository? _patients;
    private IAppointmentRepository? _appointments;
    private IEncounterRepository? _encounters;
    private IPrescriptionRepository? _prescriptions;
    private IInvoiceRepository? _invoices;
    private IPaymentRepository? _payments;
    private IUserRepository? _users;
    private ITenantRepository? _tenants;

    public UnitOfWork(MediCoreDbContext context)
    {
        _context = context;
    }

    public IPatientRepository Patients
        => _patients ??= new PatientRepository(_context);

    public IAppointmentRepository Appointments
        => _appointments ??= new AppointmentRepository(_context);
    public IEncounterRepository Encounters
        => _encounters ??= new EncounterRepository(_context);
    public IPrescriptionRepository Prescriptions
        => _prescriptions ??= new PrescriptionRepository(_context);
    public IInvoiceRepository Invoices
        => _invoices ??= new InvoiceRepository(_context);
    public IPaymentRepository Payments
        => _payments ??= new PaymentRepository(_context);
    public IUserRepository Users
        => _users ??= new UserRepository(_context);
    public ITenantRepository Tenants
        => _tenants ??= new TenantRepository(_context);

    public async Task<int> SaveChangesAsync(CancellationToken cancellationToken = default)
        => await _context.SaveChangesAsync(cancellationToken);

    public async Task BeginTransactionAsync()
        => _transaction = await _context.Database.BeginTransactionAsync();

    public async Task CommitTransactionAsync()
    {
        if (_transaction != null)
        {
            await _transaction.CommitAsync();
            await _transaction.DisposeAsync();
            _transaction = null;
        }
    }

    public async Task RollbackTransactionAsync()
    {
        if (_transaction != null)
        {
            await _transaction.RollbackAsync();
            await _transaction.DisposeAsync();
            _transaction = null;
        }
    }

    public void Dispose()
    {
        _transaction?.Dispose();
        _context.Dispose();
    }
}