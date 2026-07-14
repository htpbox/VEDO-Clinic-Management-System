using MediCore.Domain.Entities;
using MediCore.Domain.Entities.Medical;
using MediCore.Domain.Enums;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Logging;

namespace MediCore.Infrastructure.Data.Seeders;

public class DatabaseSeeder
{
    private readonly MediCoreDbContext _context;
    private readonly IConfiguration _configuration;
    private readonly ILogger<DatabaseSeeder> _logger;

    public DatabaseSeeder(
        MediCoreDbContext context,
        IConfiguration configuration,
        ILogger<DatabaseSeeder> logger)
    {
        _context = context;
        _configuration = configuration;
        _logger = logger;
    }

    public async Task SeedAsync()
    {
        try
        {
            // تطبيق أي Migrations معلقة
            await _context.Database.MigrateAsync();

            await SeedTenantAsync();
            await _context.SaveChangesAsync();

            _logger.LogInformation("Database seeding completed successfully.");
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error during database seeding.");
            throw;
        }
    }

    private async Task SeedTenantAsync()
    {
        // التحقق من وجود Tenant مسبقاً (Idempotent)
        var tenantSlug = _configuration["SeedData:TenantSlug"] ?? "default-clinic";

        if (await _context.Tenants.AnyAsync(t => t.Slug == tenantSlug))
        {
            _logger.LogInformation("Seed data already exists. Skipping.");
            return;
        }

        _logger.LogInformation("Seeding initial data...");

        // 1. إنشاء Tenant
        var tenant = new Tenant
        {
            Id = Guid.NewGuid(),
            Name = _configuration["SeedData:TenantName"] ?? "عيادة MediCore",
            NameEn = _configuration["SeedData:TenantNameEn"] ?? "MediCore Clinic",
            Slug = tenantSlug,
            Phone = _configuration["SeedData:TenantPhone"] ?? "01000000000",
            Email = _configuration["SeedData:TenantEmail"] ?? "admin@medicore.com",
            IsActive = true,
            CreatedAt = DateTime.UtcNow
        };
        await _context.Tenants.AddAsync(tenant);

        // 2. إنشاء Branch رئيسي
        var branch = new Branch
        {
            Id = Guid.NewGuid(),
            TenantId = tenant.Id,
            Name = "الفرع الرئيسي",
            IsMain = true,
            IsActive = true,
            CreatedAt = DateTime.UtcNow
        };
        await _context.Branches.AddAsync(branch);

        // 3. إنشاء Admin User
        var adminEmail = _configuration["SeedData:AdminEmail"] ?? "admin@medicore.com";
        var adminPassword = _configuration["SeedData:AdminPassword"]
            ?? throw new InvalidOperationException("SeedData:AdminPassword must be set in configuration.");

        var adminUser = new UserProfile
        {
            Id = Guid.NewGuid(),
            TenantId = tenant.Id,
            BranchId = branch.Id,
            FullName = _configuration["SeedData:AdminName"] ?? "System Administrator",
            Email = adminEmail,
            PasswordHash = BCrypt.Net.BCrypt.HashPassword(adminPassword, workFactor: 12),
            Role = UserRole.ClinicAdmin,
            IsActive = true,
            MustChangePassword = true,
            TwoFactorEnabled = false,
            CreatedAt = DateTime.UtcNow
        };
        await _context.UserProfiles.AddAsync(adminUser);

        _logger.LogInformation(
            "Seeded: Tenant={Tenant}, Branch={Branch}, Admin={Email}",
            tenant.Name, branch.Name, adminEmail);
    }
}