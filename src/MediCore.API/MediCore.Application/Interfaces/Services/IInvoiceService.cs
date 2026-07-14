using MediCore.Application.Common;
using MediCore.Application.DTOs.Invoice;

namespace MediCore.Application.Interfaces.Services;

public interface IInvoiceService
{
    Task<ApiResponse<InvoiceDto>> GetByIdAsync(Guid tenantId, Guid invoiceId);
    Task<ApiResponse<IEnumerable<InvoiceDto>>> GetByPatientAsync(Guid tenantId, Guid patientId);
    Task<ApiResponse<InvoiceDto>> CreateAsync(
        Guid tenantId, Guid branchId, Guid createdBy, CreateInvoiceDto dto);
    Task<ApiResponse<InvoiceDto>> RecordPaymentAsync(
        Guid tenantId, Guid invoiceId, Guid receivedBy, RecordPaymentDto dto);
}