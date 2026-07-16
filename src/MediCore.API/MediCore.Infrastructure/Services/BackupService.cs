using System.Diagnostics;
using System.Text.RegularExpressions;
using MediCore.Application.Common;
using MediCore.Application.DTOs.Backup;
using MediCore.Application.Interfaces.Services;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Logging;
using Npgsql;

namespace MediCore.Infrastructure.Services;

/// <summary>
/// Creates/restores whole-database backups via pg_dump/pg_restore (custom format).
/// This affects ALL tenants sharing this database instance - callers must
/// restrict this to SuperAdmin only (enforced at the controller).
///
/// Requires the `pg_dump` and `pg_restore` client binaries to be installed
/// and on PATH on whatever host runs the API. This has not been executed in
/// the development sandbox (no PostgreSQL/pg_dump available there) - verify
/// against a staging database before relying on this in production,
/// especially the restore path, which drops and recreates existing objects.
/// </summary>
public class BackupService : IBackupService
{
    private static readonly Regex SafeFileNamePattern =
        new(@"^medicore_backup_[0-9]{8}_[0-9]{6}\.dump$", RegexOptions.Compiled);

    private readonly IConfiguration _configuration;
    private readonly ILogger<BackupService> _logger;
    private readonly string _backupDirectory;

    public BackupService(IConfiguration configuration, ILogger<BackupService> logger)
    {
        _configuration = configuration;
        _logger = logger;
        _backupDirectory = configuration["Backup:Directory"] ?? "backups";
        Directory.CreateDirectory(_backupDirectory);
    }

    public async Task<ApiResponse<BackupFileDto>> CreateBackupAsync()
    {
        var builder = GetConnectionBuilder();
        var fileName = $"medicore_backup_{DateTime.UtcNow:yyyyMMdd_HHmmss}.dump";
        var filePath = Path.Combine(_backupDirectory, fileName);

        var args = new List<string>
        {
            "-h", builder.Host ?? "localhost",
            "-p", builder.Port.ToString(),
            "-U", builder.Username ?? "postgres",
            "-d", builder.Database ?? "",
            "-F", "c",
            "-f", filePath,
        };

        var (exitCode, error) = await RunProcessAsync("pg_dump", args, builder.Password);

        if (exitCode != 0)
        {
            _logger.LogError("pg_dump failed with exit code {ExitCode}: {Error}", exitCode, error);
            return ApiResponse<BackupFileDto>.Fail("فشل إنشاء النسخة الاحتياطية: " + error);
        }

        var info = new FileInfo(filePath);
        return ApiResponse<BackupFileDto>.Ok(new BackupFileDto
        {
            FileName = fileName,
            SizeBytes = info.Length,
            CreatedAt = info.CreationTimeUtc,
        }, "تم إنشاء النسخة الاحتياطية بنجاح");
    }

    public Task<ApiResponse<List<BackupFileDto>>> ListBackupsAsync()
    {
        var files = Directory.Exists(_backupDirectory)
            ? Directory.GetFiles(_backupDirectory, "medicore_backup_*.dump")
                .Select(p => new FileInfo(p))
                .OrderByDescending(f => f.CreationTimeUtc)
                .Select(f => new BackupFileDto
                {
                    FileName = f.Name,
                    SizeBytes = f.Length,
                    CreatedAt = f.CreationTimeUtc,
                })
                .ToList()
            : new List<BackupFileDto>();

        return Task.FromResult(ApiResponse<List<BackupFileDto>>.Ok(files));
    }

    public async Task<(byte[] Content, string FileName)?> GetBackupFileAsync(string fileName)
    {
        if (!IsSafeFileName(fileName)) return null;

        var filePath = Path.Combine(_backupDirectory, fileName);
        if (!File.Exists(filePath)) return null;

        var content = await File.ReadAllBytesAsync(filePath);
        return (content, fileName);
    }

    public async Task<ApiResponse<string>> RestoreBackupAsync(string fileName, string confirmationPhrase)
    {
        if (confirmationPhrase != "RESTORE")
        {
            return ApiResponse<string>.Fail(
                "يجب تأكيد عملية الاستعادة عن طريق إرسال العبارة \"RESTORE\" - هذا الإجراء سيستبدل البيانات الحالية");
        }

        if (!IsSafeFileName(fileName))
            return ApiResponse<string>.Fail("اسم الملف غير صالح");

        var filePath = Path.Combine(_backupDirectory, fileName);
        if (!File.Exists(filePath))
            return ApiResponse<string>.Fail("ملف النسخة الاحتياطية غير موجود");

        var builder = GetConnectionBuilder();
        var args = new List<string>
        {
            "-h", builder.Host ?? "localhost",
            "-p", builder.Port.ToString(),
            "-U", builder.Username ?? "postgres",
            "-d", builder.Database ?? "",
            "--clean",
            "--if-exists",
            filePath,
        };

        var (exitCode, error) = await RunProcessAsync("pg_restore", args, builder.Password);

        if (exitCode != 0)
        {
            _logger.LogError("pg_restore failed with exit code {ExitCode}: {Error}", exitCode, error);
            return ApiResponse<string>.Fail("فشلت عملية الاستعادة: " + error);
        }

        _logger.LogWarning("Database restored from backup file {FileName}", fileName);
        return ApiResponse<string>.Ok("تمت استعادة قاعدة البيانات بنجاح");
    }

    public Task<ApiResponse<string>> DeleteBackupAsync(string fileName)
    {
        if (!IsSafeFileName(fileName))
            return Task.FromResult(ApiResponse<string>.Fail("اسم الملف غير صالح"));

        var filePath = Path.Combine(_backupDirectory, fileName);
        if (!File.Exists(filePath))
            return Task.FromResult(ApiResponse<string>.Fail("ملف النسخة الاحتياطية غير موجود"));

        File.Delete(filePath);
        return Task.FromResult(ApiResponse<string>.Ok("تم حذف النسخة الاحتياطية"));
    }

    private static bool IsSafeFileName(string fileName) =>
        !string.IsNullOrEmpty(fileName)
        && fileName == Path.GetFileName(fileName)
        && SafeFileNamePattern.IsMatch(fileName);

    private NpgsqlConnectionStringBuilder GetConnectionBuilder()
    {
        var connectionString = _configuration.GetConnectionString("DefaultConnection")
            ?? throw new InvalidOperationException("Database connection string is not configured");
        return new NpgsqlConnectionStringBuilder(connectionString);
    }

    private static async Task<(int ExitCode, string Error)> RunProcessAsync(
        string fileName, List<string> arguments, string? pgPassword)
    {
        var startInfo = new ProcessStartInfo
        {
            FileName = fileName,
            RedirectStandardError = true,
            RedirectStandardOutput = true,
            UseShellExecute = false,
            CreateNoWindow = true,
        };

        foreach (var arg in arguments)
            startInfo.ArgumentList.Add(arg);

        if (!string.IsNullOrEmpty(pgPassword))
            startInfo.EnvironmentVariables["PGPASSWORD"] = pgPassword;

        using var process = new Process { StartInfo = startInfo };

        try
        {
            process.Start();
        }
        catch (System.ComponentModel.Win32Exception ex)
        {
            // pg_dump/pg_restore binary not found on PATH
            return (-1, $"لم يتم العثور على أداة {fileName} على الخادم: {ex.Message}");
        }

        var stdErr = await process.StandardError.ReadToEndAsync();
        await process.WaitForExitAsync();

        return (process.ExitCode, stdErr);
    }
}
