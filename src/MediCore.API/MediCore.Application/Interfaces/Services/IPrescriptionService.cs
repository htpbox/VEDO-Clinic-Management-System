using MediCore.Application.Common;
using MediCore.Application.DTOs.Prescription;

namespace MediCore.Application.Interfaces.Services;

public interface IPrescriptionService
{
    Task<ApiResponse<PrescriptionDto>> GetByIdAsync(Guid tenantId, Guid prescriptionId);
    Task<ApiResponse<IEnumerable<PrescriptionDto>>> GetByPatientAsync(Guid tenantId, Guid patientId);
    Task<ApiResponse<PrescriptionDto>> CreateAsync(
        Guid tenantId, Guid doctorId, CreatePrescriptionDto dto);
}