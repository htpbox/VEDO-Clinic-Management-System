using MediCore.Application.Interfaces.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace MediCore.API.Controllers;

[ApiController]
[Route("api/[controller]")]
[Authorize(Roles = "SuperAdmin")]
public class BackupController : ControllerBase
{
    private readonly IBackupService _backupService;

    public BackupController(IBackupService backupService)
    {
        _backupService = backupService;
    }

    [HttpGet]
    public async Task<IActionResult> List()
    {
        var result = await _backupService.ListBackupsAsync();
        return Ok(result);
    }

    [HttpPost]
    public async Task<IActionResult> Create()
    {
        var result = await _backupService.CreateBackupAsync();
        return result.Success ? Ok(result) : BadRequest(result);
    }

    [HttpGet("{fileName}/download")]
    public async Task<IActionResult> Download(string fileName)
    {
        var file = await _backupService.GetBackupFileAsync(fileName);
        if (file == null) return NotFound();

        return File(file.Value.Content, "application/octet-stream", file.Value.FileName);
    }

    [HttpPost("{fileName}/restore")]
    public async Task<IActionResult> Restore(string fileName, [FromBody] RestoreBackupRequest request)
    {
        var result = await _backupService.RestoreBackupAsync(fileName, request.ConfirmationPhrase);
        return result.Success ? Ok(result) : BadRequest(result);
    }

    [HttpDelete("{fileName}")]
    public async Task<IActionResult> Delete(string fileName)
    {
        var result = await _backupService.DeleteBackupAsync(fileName);
        return result.Success ? Ok(result) : BadRequest(result);
    }
}

public class RestoreBackupRequest
{
    public string ConfirmationPhrase { get; set; } = string.Empty;
}
