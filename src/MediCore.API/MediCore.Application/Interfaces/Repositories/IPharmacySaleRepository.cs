using MediCore.Domain.Entities.Pharmacy;

namespace MediCore.Application.Interfaces.Repositories;

public interface IPharmacySaleRepository : IGenericRepository<PharmacySale>
{
    /// <summary>
    /// The generic repository's FirstOrDefaultAsync/FindAsync do not eager-load
    /// navigation properties - anything that needs sale.Items populated (return
    /// processing, building the response DTO) must go through this instead.
    /// </summary>
    Task<PharmacySale?> GetByIdWithItemsAsync(Guid tenantId, Guid saleId);
    Task<List<PharmacySale>> GetByPatientWithItemsAsync(Guid tenantId, Guid patientId);
}
