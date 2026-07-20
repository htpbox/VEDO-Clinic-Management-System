using MediCore.Application.Interfaces.Repositories;

namespace MediCore.Application.Interfaces;

public interface IUnitOfWork : IDisposable
{
    // Repositories
    IPatientRepository Patients { get; }
    IAppointmentRepository Appointments { get; }
    IEncounterRepository Encounters { get; }
    IPrescriptionRepository Prescriptions { get; }
    IPrescriptionItemRepository PrescriptionItems { get; }
    IInvoiceRepository Invoices { get; }
    IPaymentRepository Payments { get; }
    IUserRepository Users { get; }
    ITenantRepository Tenants { get; }

    // Inventory
    IWarehouseRepository Warehouses { get; }
    IInventoryCategoryRepository InventoryCategories { get; }
    IInventoryItemRepository InventoryItems { get; }
    ISupplierRepository Suppliers { get; }
    IStockLevelRepository StockLevels { get; }
    IStockBatchRepository StockBatches { get; }
    IStockMovementRepository StockMovements { get; }
    IStockAdjustmentRepository StockAdjustments { get; }
    IStockTransferRepository StockTransfers { get; }
    IPurchaseOrderRepository PurchaseOrders { get; }
    IGoodsReceiptRepository GoodsReceipts { get; }
    IPurchaseReturnRepository PurchaseReturns { get; }
    ISupplierPaymentRepository SupplierPayments { get; }
    IPhysicalStockCountRepository PhysicalStockCounts { get; }

    // Pharmacy
    IPharmacySaleRepository PharmacySales { get; }

    // Laboratory
    ILabTestCatalogRepository LabTestCatalog { get; }
    ILabOrderRepository LabOrders { get; }
    ILabOrderItemRepository LabOrderItems { get; }
    ILabResultRepository LabResults { get; }

    // Radiology
    IRadiologyTestCatalogRepository RadiologyTestCatalog { get; }
    IRadiologyOrderRepository RadiologyOrders { get; }
    IRadiologyReportRepository RadiologyReports { get; }

    // Transaction Management
    Task<int> SaveChangesAsync(CancellationToken cancellationToken = default);
    Task BeginTransactionAsync();
    Task CommitTransactionAsync();
    Task RollbackTransactionAsync();
}