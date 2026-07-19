using MediCore.Application.Common;
using MediCore.Application.DTOs.Inventory;

namespace MediCore.Application.Interfaces.Services;

public interface IInventoryService
{
    Task<ApiResponse<List<InventoryItemDto>>> GetItemsAsync(Guid tenantId, string? search);
    Task<ApiResponse<InventoryItemDto>> GetItemByIdAsync(Guid tenantId, Guid itemId);
    Task<ApiResponse<InventoryItemDto>> CreateItemAsync(Guid tenantId, CreateInventoryItemDto dto);
    Task<ApiResponse<InventoryItemDto>> UpdateItemAsync(Guid tenantId, Guid itemId, UpdateInventoryItemDto dto);

    Task<ApiResponse<List<WarehouseDto>>> GetWarehousesAsync(Guid tenantId);
    Task<ApiResponse<WarehouseDto>> CreateWarehouseAsync(Guid tenantId, Guid branchId, CreateWarehouseDto dto);

    Task<ApiResponse<List<InventoryCategoryDto>>> GetCategoriesAsync(Guid tenantId);
    Task<ApiResponse<InventoryCategoryDto>> CreateCategoryAsync(Guid tenantId, CreateInventoryCategoryDto dto);

    Task<ApiResponse<List<SupplierDto>>> GetSuppliersAsync(Guid tenantId);
    Task<ApiResponse<SupplierDto>> CreateSupplierAsync(Guid tenantId, CreateSupplierDto dto);

    Task<ApiResponse<List<StockLevelDto>>> GetStockLevelsAsync(Guid tenantId, Guid? warehouseId, Guid? itemId);
}
