using MediCore.Application.Common;
using MediCore.Application.DTOs.Encounter;

namespace MediCore.Application.Interfaces.Services;

public interface IEncounterService
{
    Task<ApiResponse<EncounterDto>> GetByIdAsync(Guid tenantId, Guid encounterId);
    Task<ApiResponse<IEnumerable<EncounterDto>>> GetByPatientAsync(Guid tenantId, Guid patientId);
    Task<ApiResponse<EncounterDto>> CreateAsync(
        Guid tenantId, Guid branchId, Guid doctorId, CreateEncounterDto dto);
    Task<ApiResponse<EncounterDto>> UpdateAsync(
        Guid tenantId, Guid encounterId, UpdateEncounterDto dto);
    Task<ApiResponse<EncounterDto>> CloseAsync(Guid tenantId, Guid encounterId);
}