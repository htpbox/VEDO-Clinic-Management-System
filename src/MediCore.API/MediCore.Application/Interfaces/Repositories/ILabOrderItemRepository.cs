using MediCore.Domain.Entities.Laboratory;

namespace MediCore.Application.Interfaces.Repositories;

public interface ILabOrderItemRepository : IGenericRepository<LabOrderItem>
{
    /// <summary>Includes LabTestCatalog (for reference ranges) and LabOrder (for tenant/status checks).</summary>
    Task<LabOrderItem?> GetByIdWithDetailsAsync(Guid id);
}
