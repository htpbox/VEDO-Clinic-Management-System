using MediCore.Domain.Entities;
using MediCore.Domain.Entities.Medical;
using MediCore.Domain.Entities.Financial;
using Microsoft.EntityFrameworkCore;

namespace MediCore.Infrastructure.Data;

public class MediCoreDbContext : DbContext
{
    public MediCoreDbContext(DbContextOptions<MediCoreDbContext> options)
        : base(options) { }

    // Core
    public DbSet<Tenant> Tenants => Set<Tenant>();
    public DbSet<Branch> Branches => Set<Branch>();
    public DbSet<UserProfile> UserProfiles => Set<UserProfile>();

    // Medical
    public DbSet<Patient> Patients => Set<Patient>();
    public DbSet<MedicalRecord> MedicalRecords => Set<MedicalRecord>();
    public DbSet<Appointment> Appointments => Set<Appointment>();
    public DbSet<Encounter> Encounters => Set<Encounter>();
    public DbSet<VitalSigns> VitalSigns => Set<VitalSigns>();
    public DbSet<Prescription> Prescriptions => Set<Prescription>();
    public DbSet<PrescriptionItem> PrescriptionItems => Set<PrescriptionItem>();

    // Financial
    public DbSet<Invoice> Invoices => Set<Invoice>();
    public DbSet<InvoiceItem> InvoiceItems => Set<InvoiceItem>();
    public DbSet<Payment> Payments => Set<Payment>();

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        base.OnModelCreating(modelBuilder);
        modelBuilder.ApplyConfigurationsFromAssembly(typeof(MediCoreDbContext).Assembly);
    }
}