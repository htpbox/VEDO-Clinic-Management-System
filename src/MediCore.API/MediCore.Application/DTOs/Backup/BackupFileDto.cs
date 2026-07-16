namespace MediCore.Application.DTOs.Backup;

public class BackupFileDto
{
    public string FileName { get; set; } = string.Empty;
    public long SizeBytes { get; set; }
    public DateTime CreatedAt { get; set; }
}
