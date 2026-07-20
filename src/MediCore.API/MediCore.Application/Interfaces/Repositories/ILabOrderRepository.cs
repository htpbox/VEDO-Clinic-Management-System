using MediCore.Domain.Entities.Laboratory;

namespace MediCore.Application.Interfaces.Repositories;

public interface ILabOrderRepository : IGenericRepository<LabOrder>
{
    /// <summary>Includes Items, each item's LabTestCatalog, and each item's Result - the generic repository does not eager-load navigation properties.</summary>
    Task<LabOrder?> GetByIdWithDetailsAsync(Guid tenantId, Guid orderId);
    Task<List<LabOrder>> GetByPatientWithDetailsAsync(Guid tenantId, Guid patientId);
    Task<List<LabOrder>> GetPendingWithDetailsAsync(Guid tenantId);
}
