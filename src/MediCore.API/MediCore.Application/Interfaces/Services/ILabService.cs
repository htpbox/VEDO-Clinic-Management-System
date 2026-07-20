using MediCore.Application.Common;
using MediCore.Application.DTOs.Laboratory;

namespace MediCore.Application.Interfaces.Services;

public interface ILabService
{
    Task<ApiResponse<List<LabTestCatalogDto>>> GetCatalogAsync(Guid tenantId);
    Task<ApiResponse<LabTestCatalogDto>> CreateCatalogEntryAsync(Guid tenantId, CreateLabTestCatalogDto dto);

    Task<ApiResponse<LabOrderDto>> CreateOrderAsync(
        Guid tenantId, Guid branchId, Guid doctorId, CreateLabOrderDto dto);
    Task<ApiResponse<LabOrderDto>> GetByIdAsync(Guid tenantId, Guid orderId);
    Task<ApiResponse<List<LabOrderDto>>> GetByPatientAsync(Guid tenantId, Guid patientId);

    /// <summary>Orders not yet fully reviewed by a doctor - the lab technician's worklist.</summary>
    Task<ApiResponse<List<LabOrderDto>>> GetPendingOrdersAsync(Guid tenantId);

    /// <summary>Enters a result and auto-computes the Normal/Low/High/Critical flag from the test's reference/critical ranges.</summary>
    Task<ApiResponse<LabOrderDto>> EnterResultAsync(Guid tenantId, Guid enteredBy, EnterLabResultDto dto);

    Task<ApiResponse<LabOrderDto>> ReviewResultAsync(
        Guid tenantId, Guid labOrderItemId, Guid reviewedBy, ReviewLabResultDto dto);
}
