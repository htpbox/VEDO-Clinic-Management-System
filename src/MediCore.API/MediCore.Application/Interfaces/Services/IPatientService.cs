using MediCore.Application.Common;
using MediCore.Application.DTOs.Patient;

namespace MediCore.Application.Interfaces.Services;

public interface IPatientService
{
    Task<ApiResponse<PatientDto>> GetByIdAsync(Guid tenantId, Guid patientId);
    Task<ApiResponse<IEnumerable<PatientDto>>> SearchAsync(Guid tenantId, string searchTerm);
    Task<ApiResponse<PatientDto>> CreateAsync(Guid tenantId, Guid branchId, Guid createdBy, CreatePatientDto dto);
    Task<ApiResponse<PatientDto>> UpdateAsync(Guid tenantId, Guid patientId, Guid updatedBy, UpdatePatientDto dto);
    Task<ApiResponse<bool>> DeleteAsync(Guid tenantId, Guid patientId, Guid deletedBy);
}