using MediCore.Application.Common;
using MediCore.Application.DTOs.Backup;

namespace MediCore.Application.Interfaces.Services;

public interface IBackupService
{
    Task<ApiResponse<BackupFileDto>> CreateBackupAsync();
    Task<ApiResponse<List<BackupFileDto>>> ListBackupsAsync();
    Task<(byte[] Content, string FileName)?> GetBackupFileAsync(string fileName);
    Task<ApiResponse<string>> RestoreBackupAsync(string fileName, string confirmationPhrase);
    Task<ApiResponse<string>> DeleteBackupAsync(string fileName);
}
