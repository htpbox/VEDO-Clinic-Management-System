using MediCore.Application.Common;
using MediCore.Application.DTOs.Prescription;
using MediCore.Application.Interfaces;
using MediCore.Application.Interfaces.Services;
using MediCore.Domain.Entities.Medical;

namespace MediCore.Application.Services;

public class PrescriptionService : IPrescriptionService
{
    private readonly IUnitOfWork _unitOfWork;

    public PrescriptionService(IUnitOfWork unitOfWork)
    {
        _unitOfWork = unitOfWork;
    }

    public async Task<ApiResponse<PrescriptionDto>> GetByIdAsync(Guid tenantId, Guid prescriptionId)
    {
        var prescription = await _unitOfWork.Prescriptions.GetByIdAsync(prescriptionId);

        if (prescription == null || prescription.TenantId != tenantId)
            return ApiResponse<PrescriptionDto>.Fail("الروشتة غير موجودة");

        return ApiResponse<PrescriptionDto>.Ok(MapToDto(prescription));
    }

    public async Task<ApiResponse<IEnumerable<PrescriptionDto>>> GetByPatientAsync(
        Guid tenantId, Guid patientId)
    {
        var prescriptions = await _unitOfWork.Prescriptions.FindAsync(p =>
            p.TenantId == tenantId && p.PatientId == patientId);

        var ordered = prescriptions.OrderByDescending(p => p.CreatedAt);
        return ApiResponse<IEnumerable<PrescriptionDto>>.Ok(ordered.Select(MapToDto));
    }

    public async Task<ApiResponse<PrescriptionDto>> CreateAsync(
        Guid tenantId, Guid doctorId, CreatePrescriptionDto dto)
    {
        var prescriptionNumber = $"RX-{DateTime.UtcNow:yyyyMMddHHmmss}";

        var prescription = new Prescription
        {
            TenantId = tenantId,
            EncounterId = dto.EncounterId,
            PatientId = dto.PatientId,
            DoctorId = doctorId,
            PrescriptionNumber = prescriptionNumber,
            Status = "issued",
            Notes = dto.Notes,
            CreatedBy = doctorId,
            Items = dto.Items.Select((item, index) => new PrescriptionItem
            {
                TenantId = tenantId,
                DrugName = item.DrugName,
                ActiveIngredient = item.ActiveIngredient,
                Dose = item.Dose,
                Frequency = item.Frequency,
                Route = item.Route,
                DurationDays = item.DurationDays,
                Quantity = item.Quantity,
                Instructions = item.Instructions,
                SortOrder = index,
                CreatedBy = doctorId
            }).ToList()
        };

        await _unitOfWork.Prescriptions.AddAsync(prescription);
        await _unitOfWork.SaveChangesAsync();

        return ApiResponse<PrescriptionDto>.Ok(MapToDto(prescription), "تم إنشاء الروشتة بنجاح");
    }

    private static PrescriptionDto MapToDto(Prescription prescription)
    {
        return new PrescriptionDto
        {
            Id = prescription.Id,
            EncounterId = prescription.EncounterId,
            PatientId = prescription.PatientId,
            DoctorId = prescription.DoctorId,
            PrescriptionNumber = prescription.PrescriptionNumber,
            Status = prescription.Status,
            Notes = prescription.Notes,
            Items = prescription.Items.Select(i => new PrescriptionItemDto
            {
                Id = i.Id,
                DrugName = i.DrugName,
                ActiveIngredient = i.ActiveIngredient,
                Dose = i.Dose,
                Frequency = i.Frequency,
                Route = i.Route,
                DurationDays = i.DurationDays,
                Quantity = i.Quantity,
                Instructions = i.Instructions
            }).ToList(),
            CreatedAt = prescription.CreatedAt
        };
    }
}