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
    private IPrescriptionItemRepository? _prescriptionItems;
    private IInvoiceRepository? _invoices;
    private IPaymentRepository? _payments;
    private IUserRepository? _users;
    private ITenantRepository? _tenants;

    private IWarehouseRepository? _warehouses;
    private IInventoryCategoryRepository? _inventoryCategories;
    private IInventoryItemRepository? _inventoryItems;
    private ISupplierRepository? _suppliers;
    private IStockLevelRepository? _stockLevels;
    private IStockBatchRepository? _stockBatches;
    private IStockMovementRepository? _stockMovements;
    private IStockAdjustmentRepository? _stockAdjustments;
    private IStockTransferRepository? _stockTransfers;
    private IPurchaseOrderRepository? _purchaseOrders;
    private IGoodsReceiptRepository? _goodsReceipts;
    private IPurchaseReturnRepository? _purchaseReturns;
    private ISupplierPaymentRepository? _supplierPayments;
    private IPhysicalStockCountRepository? _physicalStockCounts;

    private IPharmacySaleRepository? _pharmacySales;

    private ILabTestCatalogRepository? _labTestCatalog;
    private ILabOrderRepository? _labOrders;
    private ILabOrderItemRepository? _labOrderItems;
    private ILabResultRepository? _labResults;

    private IRadiologyTestCatalogRepository? _radiologyTestCatalog;
    private IRadiologyOrderRepository? _radiologyOrders;
    private IRadiologyReportRepository? _radiologyReports;

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
    public IPrescriptionItemRepository PrescriptionItems
        => _prescriptionItems ??= new PrescriptionItemRepository(_context);
    public IInvoiceRepository Invoices
        => _invoices ??= new InvoiceRepository(_context);
    public IPaymentRepository Payments
        => _payments ??= new PaymentRepository(_context);
    public IUserRepository Users
        => _users ??= new UserRepository(_context);
    public ITenantRepository Tenants
        => _tenants ??= new TenantRepository(_context);

    public IWarehouseRepository Warehouses
        => _warehouses ??= new WarehouseRepository(_context);
    public IInventoryCategoryRepository InventoryCategories
        => _inventoryCategories ??= new InventoryCategoryRepository(_context);
    public IInventoryItemRepository InventoryItems
        => _inventoryItems ??= new InventoryItemRepository(_context);
    public ISupplierRepository Suppliers
        => _suppliers ??= new SupplierRepository(_context);
    public IStockLevelRepository StockLevels
        => _stockLevels ??= new StockLevelRepository(_context);
    public IStockBatchRepository StockBatches
        => _stockBatches ??= new StockBatchRepository(_context);
    public IStockMovementRepository StockMovements
        => _stockMovements ??= new StockMovementRepository(_context);
    public IStockAdjustmentRepository StockAdjustments
        => _stockAdjustments ??= new StockAdjustmentRepository(_context);
    public IStockTransferRepository StockTransfers
        => _stockTransfers ??= new StockTransferRepository(_context);
    public IPurchaseOrderRepository PurchaseOrders
        => _purchaseOrders ??= new PurchaseOrderRepository(_context);
    public IGoodsReceiptRepository GoodsReceipts
        => _goodsReceipts ??= new GoodsReceiptRepository(_context);
    public IPurchaseReturnRepository PurchaseReturns
        => _purchaseReturns ??= new PurchaseReturnRepository(_context);
    public ISupplierPaymentRepository SupplierPayments
        => _supplierPayments ??= new SupplierPaymentRepository(_context);
    public IPhysicalStockCountRepository PhysicalStockCounts
        => _physicalStockCounts ??= new PhysicalStockCountRepository(_context);

    public IPharmacySaleRepository PharmacySales
        => _pharmacySales ??= new PharmacySaleRepository(_context);

    public ILabTestCatalogRepository LabTestCatalog
        => _labTestCatalog ??= new LabTestCatalogRepository(_context);
    public ILabOrderRepository LabOrders
        => _labOrders ??= new LabOrderRepository(_context);
    public ILabOrderItemRepository LabOrderItems
        => _labOrderItems ??= new LabOrderItemRepository(_context);
    public ILabResultRepository LabResults
        => _labResults ??= new LabResultRepository(_context);

    public IRadiologyTestCatalogRepository RadiologyTestCatalog
        => _radiologyTestCatalog ??= new RadiologyTestCatalogRepository(_context);
    public IRadiologyOrderRepository RadiologyOrders
        => _radiologyOrders ??= new RadiologyOrderRepository(_context);
    public IRadiologyReportRepository RadiologyReports
        => _radiologyReports ??= new RadiologyReportRepository(_context);

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