using FluentValidation;
using MediCore.Application.DTOs.Staff;
using MediCore.Domain.Enums;

namespace MediCore.Application.Validators;

public class UpdateStaffValidator : AbstractValidator<UpdateStaffDto>
{
    public UpdateStaffValidator()
    {
        RuleFor(x => x.FullName)
            .NotEmpty().WithMessage("اسم الموظف مطلوب")
            .MinimumLength(3).WithMessage("الاسم يجب أن يكون 3 أحرف على الأقل")
            .MaximumLength(200).WithMessage("الاسم طويل جداً");

        RuleFor(x => x.Phone)
            .Matches(@"^01[0125][0-9]{8}$")
            .WithMessage("رقم الهاتف غير صحيح")
            .When(x => !string.IsNullOrEmpty(x.Phone));

        RuleFor(x => x.Role)
            .NotEmpty().WithMessage("الدور الوظيفي مطلوب")
            .Must(r => Enum.TryParse<UserRole>(r, true, out _))
            .WithMessage("الدور الوظيفي غير صحيح");
    }
}
