using FluentValidation;
using MediCore.Application.Interfaces.Services;
using MediCore.Application.Services;
using MediCore.Application.Validators;
using Microsoft.Extensions.DependencyInjection;

namespace MediCore.Application.Extensions;

public static class ApplicationServiceExtensions
{
    public static IServiceCollection AddApplicationServices(
        this IServiceCollection services)
    {
        // Services
        services.AddScoped<IPatientService, PatientService>();
        services.AddScoped<IAuthService, AuthService>();
        services.AddScoped<IAppointmentService, AppointmentService>();
        services.AddScoped<IEncounterService, EncounterService>();
        services.AddScoped<IPrescriptionService, PrescriptionService>();
        services.AddScoped<IInvoiceService, InvoiceService>();
        services.AddScoped<IStaffService, StaffService>();
        services.AddScoped<IReportService, ReportService>();
        services.AddScoped<ISettingsService, SettingsService>();
        services.AddScoped<INotificationService, NotificationService>();

        // FluentValidation
        services.AddValidatorsFromAssemblyContaining<LoginValidator>();

        return services;
    }
}
