using FluentValidation;
using MediCore.Application.DTOs.Patient;

namespace MediCore.Application.Validators;

public class CreatePatientValidator : AbstractValidator<CreatePatientDto>
{
    public CreatePatientValidator()
    {
        RuleFor(x => x.FullName)
            .NotEmpty().WithMessage("اسم المريض مطلوب")
            .MinimumLength(3).WithMessage("الاسم يجب أن يكون 3 أحرف على الأقل")
            .MaximumLength(200).WithMessage("الاسم طويل جداً");

        RuleFor(x => x.Gender)
            .NotEmpty().WithMessage("الجنس مطلوب")
            .Must(g => g == "Male" || g == "Female")
            .WithMessage("الجنس يجب أن يكون Male أو Female");

        RuleFor(x => x.Phone)
            .Matches(@"^01[0125][0-9]{8}$")
            .WithMessage("رقم الهاتف غير صحيح")
            .When(x => !string.IsNullOrEmpty(x.Phone));

        RuleFor(x => x.NationalId)
            .Length(14).WithMessage("الرقم القومي يجب أن يكون 14 رقماً")
            .Matches(@"^\d{14}$").WithMessage("الرقم القومي يجب أن يحتوي أرقاماً فقط")
            .When(x => !string.IsNullOrEmpty(x.NationalId));

        RuleFor(x => x.Email)
            .EmailAddress().WithMessage("صيغة البريد الإلكتروني غير صحيحة")
            .When(x => !string.IsNullOrEmpty(x.Email));

        RuleFor(x => x.DateOfBirth)
            .LessThan(DateOnly.FromDateTime(DateTime.Today))
            .WithMessage("تاريخ الميلاد غير صحيح")
            .When(x => x.DateOfBirth.HasValue);
    }
}