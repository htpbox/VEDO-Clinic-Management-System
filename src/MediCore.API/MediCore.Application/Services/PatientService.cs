using MediCore.Application.Common;
using MediCore.Application.DTOs.Patient;
using MediCore.Application.Interfaces;
using MediCore.Application.Interfaces.Services;
using MediCore.Domain.Entities.Medical;
using MediCore.Domain.Enums;

namespace MediCore.Application.Services;

public class PatientService : IPatientService
{
    private readonly IUnitOfWork _unitOfWork;

    public PatientService(IUnitOfWork unitOfWork)
    {
        _unitOfWork = unitOfWork;
    }

    public async Task<ApiResponse<PatientDto>> GetByIdAsync(Guid tenantId, Guid patientId)
    {
        var patient = await _unitOfWork.Patients.GetByIdAsync(patientId);

        if (patient == null || patient.TenantId != tenantId)
            return ApiResponse<PatientDto>.Fail("المريض غير موجود");

        return ApiResponse<PatientDto>.Ok(MapToDto(patient));
    }

    public async Task<ApiResponse<IEnumerable<PatientDto>>> SearchAsync(Guid tenantId, string searchTerm)
    {
        var patients = await _unitOfWork.Patients.SearchAsync(tenantId, searchTerm);
        return ApiResponse<IEnumerable<PatientDto>>.Ok(patients.Select(MapToDto));
    }

    public async Task<ApiResponse<PatientDto>> CreateAsync(
        Guid tenantId, Guid branchId, Guid createdBy, CreatePatientDto dto)
    {
        // التحقق من تكرار الرقم القومي
        if (!string.IsNullOrEmpty(dto.NationalId))
        {
            var exists = await _unitOfWork.Patients
                .GetByNationalIdAsync(tenantId, dto.NationalId);
            if (exists != null)
                return ApiResponse<PatientDto>.Fail("الرقم القومي مسجل مسبقاً");
        }

        // توليد رقم الملف
        var fileNumber = await _unitOfWork.Patients.GenerateFileNumberAsync(tenantId);

        var patient = new Patient
        {
            TenantId = tenantId,
            BranchId = branchId,
            FileNumber = fileNumber,
            FullName = dto.FullName,
            Gender = Enum.Parse<Gender>(dto.Gender, true),
            DateOfBirth = dto.DateOfBirth,
            NationalId = dto.NationalId,
            Phone = dto.Phone,
            PhoneSecondary = dto.PhoneSecondary,
            Email = dto.Email,
            Address = dto.Address,
            Governorate = dto.Governorate,
            BloodType = dto.BloodType,
            EmergencyContactName = dto.EmergencyContactName,
            EmergencyContactPhone = dto.EmergencyContactPhone,
            EmergencyContactRelation = dto.EmergencyContactRelation,
            InsuranceCompany = dto.InsuranceCompany,
            InsuranceNumber = dto.InsuranceNumber,
            InsuranceExpiry = dto.InsuranceExpiry,
            Notes = dto.Notes,
            CreatedBy = createdBy
        };

        await _unitOfWork.Patients.AddAsync(patient);
        await _unitOfWork.SaveChangesAsync();

        return ApiResponse<PatientDto>.Ok(MapToDto(patient), "تم إضافة المريض بنجاح");
    }

    public async Task<ApiResponse<PatientDto>> UpdateAsync(
        Guid tenantId, Guid patientId, Guid updatedBy, UpdatePatientDto dto)
    {
        var patient = await _unitOfWork.Patients.GetByIdAsync(patientId);

        if (patient == null || patient.TenantId != tenantId)
            return ApiResponse<PatientDto>.Fail("المريض غير موجود");

        patient.FullName = dto.FullName;
        patient.DateOfBirth = dto.DateOfBirth;
        patient.Phone = dto.Phone;
        patient.PhoneSecondary = dto.PhoneSecondary;
        patient.Email = dto.Email;
        patient.Address = dto.Address;
        patient.Governorate = dto.Governorate;
        patient.BloodType = dto.BloodType;
        patient.EmergencyContactName = dto.EmergencyContactName;
        patient.EmergencyContactPhone = dto.EmergencyContactPhone;
        patient.EmergencyContactRelation = dto.EmergencyContactRelation;
        patient.InsuranceCompany = dto.InsuranceCompany;
        patient.InsuranceNumber = dto.InsuranceNumber;
        patient.InsuranceExpiry = dto.InsuranceExpiry;
        patient.Notes = dto.Notes;
        patient.UpdatedBy = updatedBy;

        await _unitOfWork.Patients.UpdateAsync(patient);
        await _unitOfWork.SaveChangesAsync();

        return ApiResponse<PatientDto>.Ok(MapToDto(patient), "تم تحديث بيانات المريض");
    }

    public async Task<ApiResponse<bool>> DeleteAsync(Guid tenantId, Guid patientId, Guid deletedBy)
    {
        var patient = await _unitOfWork.Patients.GetByIdAsync(patientId);

        if (patient == null || patient.TenantId != tenantId)
            return ApiResponse<bool>.Fail("المريض غير موجود");

        await _unitOfWork.Patients.SoftDeleteAsync(patient, deletedBy);
        await _unitOfWork.SaveChangesAsync();

        return ApiResponse<bool>.Ok(true, "تم حذف المريض");
    }

    private static PatientDto MapToDto(Patient patient)
    {
        var age = patient.DateOfBirth.HasValue
            ? DateTime.Today.Year - patient.DateOfBirth.Value.Year
            : (int?)null;

        return new PatientDto
        {
            Id = patient.Id,
            FileNumber = patient.FileNumber,
            FullName = patient.FullName,
            Gender = patient.Gender.ToString(),
            DateOfBirth = patient.DateOfBirth,
            Age = age,
            Phone = patient.Phone,
            Email = patient.Email,
            BloodType = patient.BloodType,
            InsuranceCompany = patient.InsuranceCompany,
            Status = patient.Status.ToString(),
            CreatedAt = patient.CreatedAt
        };
    }
}