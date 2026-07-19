using MediCore.Application.Common;
using MediCore.Application.DTOs.Pharmacy;

namespace MediCore.Application.Interfaces.Services;

public interface IPharmacyService
{
    /// <summary>
    /// Creates a sale (retail or prescription-dispense), issues stock for
    /// every line via IStockService, marks referenced PrescriptionItems as
    /// dispensed, and - if CreateInvoice is true - creates and links an
    /// Invoice through the existing IInvoiceService rather than duplicating
    /// billing logic.
    /// </summary>
    Task<ApiResponse<PharmacySaleDto>> CreateSaleAsync(
        Guid tenantId, Guid branchId, Guid soldBy, CreatePharmacySaleDto dto);

    Task<ApiResponse<PharmacySaleDto>> GetByIdAsync(Guid tenantId, Guid saleId);
    Task<ApiResponse<List<PharmacySaleDto>>> GetByPatientAsync(Guid tenantId, Guid patientId);

    /// <summary>Returns some or all items of a completed sale, restocking the returned quantities.</summary>
    Task<ApiResponse<PharmacySaleDto>> ReturnSaleAsync(
        Guid tenantId, Guid saleId, Guid processedBy, ReturnPharmacySaleDto dto);
}
