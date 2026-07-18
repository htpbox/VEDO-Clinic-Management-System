using MediCore.Domain.Entities;
using MediCore.Domain.Entities.Medical;
using MediCore.Domain.Entities.Financial;
using MediCore.Domain.Entities.Inventory;
using MediCore.Domain.Entities.Pharmacy;
using MediCore.Domain.Entities.Laboratory;
using MediCore.Domain.Entities.Radiology;
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

    // Inventory
    public DbSet<Warehouse> Warehouses => Set<Warehouse>();
    public DbSet<InventoryCategory> InventoryCategories => Set<InventoryCategory>();
    public DbSet<InventoryItem> InventoryItems => Set<InventoryItem>();
    public DbSet<Supplier> Suppliers => Set<Supplier>();
    public DbSet<StockLevel> StockLevels => Set<StockLevel>();
    public DbSet<StockBatch> StockBatches => Set<StockBatch>();
    public DbSet<StockMovement> StockMovements => Set<StockMovement>();
    public DbSet<StockAdjustment> StockAdjustments => Set<StockAdjustment>();
    public DbSet<StockTransfer> StockTransfers => Set<StockTransfer>();
    public DbSet<StockTransferItem> StockTransferItems => Set<StockTransferItem>();
    public DbSet<PurchaseOrder> PurchaseOrders => Set<PurchaseOrder>();
    public DbSet<PurchaseOrderItem> PurchaseOrderItems => Set<PurchaseOrderItem>();
    public DbSet<GoodsReceipt> GoodsReceipts => Set<GoodsReceipt>();
    public DbSet<GoodsReceiptItem> GoodsReceiptItems => Set<GoodsReceiptItem>();
    public DbSet<PurchaseReturn> PurchaseReturns => Set<PurchaseReturn>();
    public DbSet<PurchaseReturnItem> PurchaseReturnItems => Set<PurchaseReturnItem>();
    public DbSet<SupplierPayment> SupplierPayments => Set<SupplierPayment>();
    public DbSet<PhysicalStockCount> PhysicalStockCounts => Set<PhysicalStockCount>();
    public DbSet<PhysicalStockCountItem> PhysicalStockCountItems => Set<PhysicalStockCountItem>();

    // Pharmacy
    public DbSet<PharmacySale> PharmacySales => Set<PharmacySale>();
    public DbSet<PharmacySaleItem> PharmacySaleItems => Set<PharmacySaleItem>();

    // Laboratory
    public DbSet<LabTestCatalog> LabTestCatalog => Set<LabTestCatalog>();
    public DbSet<LabOrder> LabOrders => Set<LabOrder>();
    public DbSet<LabOrderItem> LabOrderItems => Set<LabOrderItem>();
    public DbSet<LabResult> LabResults => Set<LabResult>();

    // Radiology
    public DbSet<RadiologyTestCatalog> RadiologyTestCatalog => Set<RadiologyTestCatalog>();
    public DbSet<RadiologyOrder> RadiologyOrders => Set<RadiologyOrder>();
    public DbSet<RadiologyReport> RadiologyReports => Set<RadiologyReport>();
    public DbSet<RadiologyImage> RadiologyImages => Set<RadiologyImage>();

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        base.OnModelCreating(modelBuilder);
        modelBuilder.ApplyConfigurationsFromAssembly(typeof(MediCoreDbContext).Assembly);
    }
}