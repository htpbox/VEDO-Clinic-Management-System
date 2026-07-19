using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using MediCore.Application.DTOs.Inventory;
using MediCore.Application.Interfaces.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace MediCore.API.Controllers;

[ApiController]
[Route("api/[controller]")]
[Authorize]
public class InventoryController : ControllerBase
{
    private readonly IInventoryService _inventoryService;
    private readonly IStockService _stockService;

    public InventoryController(IInventoryService inventoryService, IStockService stockService)
    {
        _inventoryService = inventoryService;
        _stockService = stockService;
    }

    // Items - reads open to all authenticated staff (everyone may need to check availability)

    [HttpGet("items")]
    public async Task<IActionResult> GetItems([FromQuery] string? search)
    {
        var result = await _inventoryService.GetItemsAsync(GetTenantId(), search);
        return Ok(result);
    }

    [HttpGet("items/{id:guid}")]
    public async Task<IActionResult> GetItem(Guid id)
    {
        var result = await _inventoryService.GetItemByIdAsync(GetTenantId(), id);
        return result.Success ? Ok(result) : NotFound(result);
    }

    [HttpPost("items")]
    [Authorize(Roles = "SuperAdmin,ClinicAdmin,Pharmacist")]
    public async Task<IActionResult> CreateItem([FromBody] CreateInventoryItemDto dto)
    {
        var result = await _inventoryService.CreateItemAsync(GetTenantId(), dto);
        return result.Success ? Ok(result) : BadRequest(result);
    }

    [HttpPut("items/{id:guid}")]
    [Authorize(Roles = "SuperAdmin,ClinicAdmin,Pharmacist")]
    public async Task<IActionResult> UpdateItem(Guid id, [FromBody] UpdateInventoryItemDto dto)
    {
        var result = await _inventoryService.UpdateItemAsync(GetTenantId(), id, dto);
        return result.Success ? Ok(result) : BadRequest(result);
    }

    // Warehouses

    [HttpGet("warehouses")]
    public async Task<IActionResult> GetWarehouses()
    {
        var result = await _inventoryService.GetWarehousesAsync(GetTenantId());
        return Ok(result);
    }

    [HttpPost("warehouses")]
    [Authorize(Roles = "SuperAdmin,ClinicAdmin")]
    public async Task<IActionResult> CreateWarehouse([FromBody] CreateWarehouseDto dto)
    {
        var branchId = GetBranchId();
        if (branchId == null)
            return BadRequest("لا يوجد فرع محدد لهذا المستخدم");

        var result = await _inventoryService.CreateWarehouseAsync(GetTenantId(), branchId.Value, dto);
        return result.Success ? Ok(result) : BadRequest(result);
    }

    // Categories

    [HttpGet("categories")]
    public async Task<IActionResult> GetCategories()
    {
        var result = await _inventoryService.GetCategoriesAsync(GetTenantId());
        return Ok(result);
    }

    [HttpPost("categories")]
    [Authorize(Roles = "SuperAdmin,ClinicAdmin,Pharmacist")]
    public async Task<IActionResult> CreateCategory([FromBody] CreateInventoryCategoryDto dto)
    {
        var result = await _inventoryService.CreateCategoryAsync(GetTenantId(), dto);
        return result.Success ? Ok(result) : BadRequest(result);
    }

    // Suppliers - procurement, admin/accountant only (even to view contact/pricing terms)

    [HttpGet("suppliers")]
    [Authorize(Roles = "SuperAdmin,ClinicAdmin,Accountant,Pharmacist")]
    public async Task<IActionResult> GetSuppliers()
    {
        var result = await _inventoryService.GetSuppliersAsync(GetTenantId());
        return Ok(result);
    }

    [HttpPost("suppliers")]
    [Authorize(Roles = "SuperAdmin,ClinicAdmin,Accountant")]
    public async Task<IActionResult> CreateSupplier([FromBody] CreateSupplierDto dto)
    {
        var result = await _inventoryService.CreateSupplierAsync(GetTenantId(), dto);
        return result.Success ? Ok(result) : BadRequest(result);
    }

    // Stock levels and movements

    [HttpGet("stock-levels")]
    public async Task<IActionResult> GetStockLevels([FromQuery] Guid? warehouseId, [FromQuery] Guid? itemId)
    {
        var result = await _inventoryService.GetStockLevelsAsync(GetTenantId(), warehouseId, itemId);
        return Ok(result);
    }

    [HttpGet("stock/low-stock")]
    [Authorize(Roles = "SuperAdmin,ClinicAdmin,Pharmacist")]
    public async Task<IActionResult> GetLowStock([FromQuery] Guid? warehouseId)
    {
        var result = await _stockService.GetLowStockItemsAsync(GetTenantId(), warehouseId);
        return Ok(result);
    }

    [HttpGet("stock/expiring")]
    [Authorize(Roles = "SuperAdmin,ClinicAdmin,Pharmacist")]
    public async Task<IActionResult> GetExpiring([FromQuery] int withinDays = 30)
    {
        var result = await _stockService.GetExpiringBatchesAsync(GetTenantId(), withinDays);
        return Ok(result);
    }

    [HttpPost("stock/receive")]
    [Authorize(Roles = "SuperAdmin,ClinicAdmin,Pharmacist")]
    public async Task<IActionResult> ReceiveStock([FromBody] ReceiveStockRequest request)
    {
        request.TenantId = GetTenantId();
        var result = await _stockService.ReceiveStockAsync(request);
        return result.Success ? Ok(result) : BadRequest(result);
    }

    [HttpPost("stock/adjust")]
    [Authorize(Roles = "SuperAdmin,ClinicAdmin,Pharmacist")]
    public async Task<IActionResult> AdjustStock([FromBody] AdjustStockDto dto)
    {
        var result = await _stockService.AdjustStockAsync(
            GetTenantId(), dto.WarehouseId, dto.ItemId, dto.NewQuantity, dto.Reason, GetUserId());
        return result.Success ? Ok(result) : BadRequest(result);
    }

    [HttpPost("stock/transfer")]
    [Authorize(Roles = "SuperAdmin,ClinicAdmin,Pharmacist")]
    public async Task<IActionResult> TransferStock([FromBody] TransferStockDto dto)
    {
        var result = await _stockService.TransferStockAsync(
            GetTenantId(), dto.FromWarehouseId, dto.ToWarehouseId, dto.ItemId, dto.Quantity, GetUserId());
        return result.Success ? Ok(result) : BadRequest(result);
    }

    private Guid GetTenantId()
    {
        var value = User.FindFirst("tenant_id")?.Value;
        return Guid.Parse(value!);
    }

    private Guid? GetBranchId()
    {
        var value = User.FindFirst("branch_id")?.Value;
        return string.IsNullOrEmpty(value) ? null : Guid.Parse(value);
    }

    private Guid GetUserId()
    {
        var value = User.FindFirst(ClaimTypes.NameIdentifier)?.Value
            ?? User.FindFirst(JwtRegisteredClaimNames.Sub)?.Value;
        return Guid.Parse(value!);
    }
}
