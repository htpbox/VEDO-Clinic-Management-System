using FluentValidation;
using MediCore.Application.DTOs.Settings;

namespace MediCore.Application.Validators;

public class UpdateTenantSettingsValidator : AbstractValidator<UpdateTenantSettingsDto>
{
    public UpdateTenantSettingsValidator()
    {
        RuleFor(x => x.Name)
            .NotEmpty().WithMessage("اسم العيادة مطلوب")
            .MaximumLength(200).WithMessage("اسم العيادة طويل جداً");

        RuleFor(x => x.Phone)
            .Matches(@"^01[0125][0-9]{8}$")
            .WithMessage("رقم الهاتف غير صحيح")
            .When(x => !string.IsNullOrEmpty(x.Phone));

        RuleFor(x => x.Email)
            .EmailAddress().WithMessage("صيغة البريد الإلكتروني غير صحيحة")
            .When(x => !string.IsNullOrEmpty(x.Email));
    }
}
