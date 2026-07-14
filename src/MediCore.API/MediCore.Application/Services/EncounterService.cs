using MediCore.Application.Common;
using MediCore.Application.DTOs.Encounter;
using MediCore.Application.Interfaces;
using MediCore.Application.Interfaces.Services;
using MediCore.Domain.Entities.Medical;

namespace MediCore.Application.Services;

public class EncounterService : IEncounterService
{
    private readonly IUnitOfWork _unitOfWork;

    public EncounterService(IUnitOfWork unitOfWork)
    {
        _unitOfWork = unitOfWork;
    }

    public async Task<ApiResponse<EncounterDto>> GetByIdAsync(Guid tenantId, Guid encounterId)
    {
        var encounter = await _unitOfWork.Encounters.GetByIdAsync(encounterId);

        if (encounter == null || encounter.TenantId != tenantId)
            return ApiResponse<EncounterDto>.Fail("الزيارة غير موجودة");

        return ApiResponse<EncounterDto>.Ok(MapToDto(encounter));
    }

    public async Task<ApiResponse<IEnumerable<EncounterDto>>> GetByPatientAsync(
        Guid tenantId, Guid patientId)
    {
        var encounters = await _unitOfWork.Encounters.FindAsync(e =>
            e.TenantId == tenantId && e.PatientId == patientId);

        var ordered = encounters.OrderByDescending(e => e.CreatedAt);
        return ApiResponse<IEnumerable<EncounterDto>>.Ok(ordered.Select(MapToDto));
    }

    public async Task<ApiResponse<EncounterDto>> CreateAsync(
        Guid tenantId, Guid branchId, Guid doctorId, CreateEncounterDto dto)
    {
        var encounter = new Encounter
        {
            TenantId = tenantId,
            BranchId = branchId,
            PatientId = dto.PatientId,
            DoctorId = doctorId,
            AppointmentId = dto.AppointmentId,
            EncounterType = dto.EncounterType,
            Status = "in_progress",
            ChiefComplaint = dto.ChiefComplaint,
            CreatedBy = doctorId
        };

        await _unitOfWork.Encounters.AddAsync(encounter);
        await _unitOfWork.SaveChangesAsync();

        return ApiResponse<EncounterDto>.Ok(MapToDto(encounter), "تم بدء الزيارة");
    }

    public async Task<ApiResponse<EncounterDto>> UpdateAsync(
        Guid tenantId, Guid encounterId, UpdateEncounterDto dto)
    {
        var encounter = await _unitOfWork.Encounters.GetByIdAsync(encounterId);

        if (encounter == null || encounter.TenantId != tenantId)
            return ApiResponse<EncounterDto>.Fail("الزيارة غير موجودة");

        if (encounter.IsLocked)
            return ApiResponse<EncounterDto>.Fail("لا يمكن تعديل زيارة مغلقة");

        encounter.ChiefComplaint = dto.ChiefComplaint ?? encounter.ChiefComplaint;
        encounter.Hpi = dto.Hpi ?? encounter.Hpi;
        encounter.PhysicalExam = dto.PhysicalExam ?? encounter.PhysicalExam;
        encounter.ClinicalNotes = dto.ClinicalNotes ?? encounter.ClinicalNotes;
        encounter.TreatmentPlan = dto.TreatmentPlan ?? encounter.TreatmentPlan;
        encounter.FollowUpDate = dto.FollowUpDate ?? encounter.FollowUpDate;
        encounter.FollowUpNotes = dto.FollowUpNotes ?? encounter.FollowUpNotes;

        await _unitOfWork.Encounters.UpdateAsync(encounter);
        await _unitOfWork.SaveChangesAsync();

        return ApiResponse<EncounterDto>.Ok(MapToDto(encounter), "تم تحديث بيانات الزيارة");
    }

    public async Task<ApiResponse<EncounterDto>> CloseAsync(Guid tenantId, Guid encounterId)
    {
        var encounter = await _unitOfWork.Encounters.GetByIdAsync(encounterId);

        if (encounter == null || encounter.TenantId != tenantId)
            return ApiResponse<EncounterDto>.Fail("الزيارة غير موجودة");

        encounter.Status = "completed";
        encounter.IsLocked = true;
        encounter.LockedAt = DateTime.UtcNow;

        await _unitOfWork.Encounters.UpdateAsync(encounter);
        await _unitOfWork.SaveChangesAsync();

        return ApiResponse<EncounterDto>.Ok(MapToDto(encounter), "تم إغلاق الزيارة");
    }

    private static EncounterDto MapToDto(Encounter encounter)
    {
        return new EncounterDto
        {
            Id = encounter.Id,
            PatientId = encounter.PatientId,
            DoctorId = encounter.DoctorId,
            AppointmentId = encounter.AppointmentId,
            EncounterType = encounter.EncounterType,
            Status = encounter.Status,
            ChiefComplaint = encounter.ChiefComplaint,
            Hpi = encounter.Hpi,
            PhysicalExam = encounter.PhysicalExam,
            ClinicalNotes = encounter.ClinicalNotes,
            TreatmentPlan = encounter.TreatmentPlan,
            FollowUpDate = encounter.FollowUpDate,
            FollowUpNotes = encounter.FollowUpNotes,
            IsLocked = encounter.IsLocked,
            CreatedAt = encounter.CreatedAt
        };
    }
}