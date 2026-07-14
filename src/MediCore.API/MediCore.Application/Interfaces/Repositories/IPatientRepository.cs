using MediCore.Domain.Entities.Medical;

namespace MediCore.Application.Interfaces.Repositories;

public interface IPatientRepository : IGenericRepository<Patient>
{
    Task<Patient?> GetByFileNumberAsync(Guid tenantId, string fileNumber);
    Task<Patient?> GetByNationalIdAsync(Guid tenantId, string nationalId);
    Task<IEnumerable<Patient>> SearchAsync(Guid tenantId, string searchTerm);
    Task<Patient?> GetWithMedicalRecordAsync(Guid tenantId, Guid patientId);
    Task<string> GenerateFileNumberAsync(Guid tenantId);
    Task<bool> FileNumberExistsAsync(Guid tenantId, string fileNumber);
}