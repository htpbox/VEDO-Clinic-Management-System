using MediCore.Application.Common;
using MediCore.Application.DTOs.Inventory;
using MediCore.Application.Interfaces;
using MediCore.Domain.Entities.Inventory;

namespace MediCore.Application.Services;

public class InventoryService : IInventoryService
{
    private readonly IUnitOfWork _unitOfWork;

    public InventoryService(IUnitOfWork unitOfWork)
    {
        _unitOfWork = unitOfWork;
    }

    public async Task<ApiResponse<List<InventoryItemDto>>> GetItemsAsync(Guid tenantId, string? search)
    {
        var items = string.IsNullOrWhiteSpace(search)
            ? await _unitOfWork.InventoryItems.FindAsync(i => i.TenantId == tenantId)
            : await _unitOfWork.InventoryItems.FindAsync(i => i.TenantId == tenantId
                && (i.Name.Contains(search) || i.Sku.Contains(search) || (i.Barcode != null && i.Barcode.Contains(search))));

        var categories = (await _unitOfWork.InventoryCategories.FindAsync(c => c.TenantId == tenantId))
            .ToDictionary(c => c.Id, c => c.Name);

        return ApiResponse<List<InventoryItemDto>>.Ok(
            items.Select(i => MapToDto(i, categories)).ToList());
    }

    public async Task<ApiResponse<InventoryItemDto>> GetItemByIdAsync(Guid tenantId, Guid itemId)
    {
        var item = await _unitOfWork.InventoryItems.GetByIdAsync(itemId);
        if (item == null || item.TenantId != tenantId)
            return ApiResponse<InventoryItemDto>.Fail("الصنف غير موجود");

        string? categoryName = null;
        if (item.CategoryId.HasValue)
        {
            var category = await _unitOfWork.InventoryCategories.GetByIdAsync(item.CategoryId.Value);
            categoryName = category?.Name;
        }

        return ApiResponse<InventoryItemDto>.Ok(MapToDto(item, categoryName));
    }

    public async Task<ApiResponse<InventoryItemDto>> CreateItemAsync(Guid tenantId, CreateInventoryItemDto dto)
    {
        if (await _unitOfWork.InventoryItems.ExistsAsync(i => i.TenantId == tenantId && i.Sku == dto.Sku))
            return ApiResponse<InventoryItemDto>.Fail("رمز الصنف (SKU) مستخدم بالفعل");

        var item = new InventoryItem
        {
            TenantId = tenantId,
            Name = dto.Name,
            Sku = dto.Sku,
            Barcode = dto.Barcode,
            CategoryId = dto.CategoryId,
            UnitOfMeasure = dto.UnitOfMeasure,
            IsPharmacyItem = dto.IsPharmacyItem,
            TracksBatches = dto.TracksBatches,
            CostPrice = dto.CostPrice,
            SalePrice = dto.SalePrice,
            ReorderPoint = dto.ReorderPoint,
            SafetyStock = dto.SafetyStock,
        };

        await _unitOfWork.InventoryItems.AddAsync(item);
        await _unitOfWork.SaveChangesAsync();

        return ApiResponse<InventoryItemDto>.Ok(MapToDto(item, (string?)null), "تم إضافة الصنف بنجاح");
    }

    public async Task<ApiResponse<InventoryItemDto>> UpdateItemAsync(Guid tenantId, Guid itemId, UpdateInventoryItemDto dto)
    {
        var item = await _unitOfWork.InventoryItems.GetByIdAsync(itemId);
        if (item == null || item.TenantId != tenantId)
            return ApiResponse<InventoryItemDto>.Fail("الصنف غير موجود");

        item.Name = dto.Name;
        item.Barcode = dto.Barcode;
        item.CategoryId = dto.CategoryId;
        item.UnitOfMeasure = dto.UnitOfMeasure;
        item.CostPrice = dto.CostPrice;
        item.SalePrice = dto.SalePrice;
        item.ReorderPoint = dto.ReorderPoint;
        item.SafetyStock = dto.SafetyStock;
        item.IsActive = dto.IsActive;

        await _unitOfWork.InventoryItems.UpdateAsync(item);
        await _unitOfWork.SaveChangesAsync();

        return ApiResponse<InventoryItemDto>.Ok(MapToDto(item, (string?)null), "تم تحديث الصنف بنجاح");
    }

    public async Task<ApiResponse<List<WarehouseDto>>> GetWarehousesAsync(Guid tenantId)
    {
        var warehouses = await _unitOfWork.Warehouses.FindAsync(w => w.TenantId == tenantId);
        return ApiResponse<List<WarehouseDto>>.Ok(warehouses.Select(w => new WarehouseDto
        {
            Id = w.Id,
            Name = w.Name,
            Location = w.Location,
            IsActive = w.IsActive,
        }).ToList());
    }

    public async Task<ApiResponse<WarehouseDto>> CreateWarehouseAsync(Guid tenantId, Guid branchId, CreateWarehouseDto dto)
    {
        var warehouse = new Warehouse
        {
            TenantId = tenantId,
            BranchId = branchId,
            Name = dto.Name,
            Location = dto.Location,
        };

        await _unitOfWork.Warehouses.AddAsync(warehouse);
        await _unitOfWork.SaveChangesAsync();

        return ApiResponse<WarehouseDto>.Ok(new WarehouseDto
        {
            Id = warehouse.Id,
            Name = warehouse.Name,
            Location = warehouse.Location,
            IsActive = warehouse.IsActive,
        }, "تم إضافة المخزن بنجاح");
    }

    public async Task<ApiResponse<List<InventoryCategoryDto>>> GetCategoriesAsync(Guid tenantId)
    {
        var categories = await _unitOfWork.InventoryCategories.FindAsync(c => c.TenantId == tenantId);
        return ApiResponse<List<InventoryCategoryDto>>.Ok(categories.Select(c => new InventoryCategoryDto
        {
            Id = c.Id,
            Name = c.Name,
            ParentCategoryId = c.ParentCategoryId,
        }).ToList());
    }

    public async Task<ApiResponse<InventoryCategoryDto>> CreateCategoryAsync(Guid tenantId, CreateInventoryCategoryDto dto)
    {
        var category = new InventoryCategory
        {
            TenantId = tenantId,
            Name = dto.Name,
            ParentCategoryId = dto.ParentCategoryId,
        };

        await _unitOfWork.InventoryCategories.AddAsync(category);
        await _unitOfWork.SaveChangesAsync();

        return ApiResponse<InventoryCategoryDto>.Ok(new InventoryCategoryDto
        {
            Id = category.Id,
            Name = category.Name,
            ParentCategoryId = category.ParentCategoryId,
        }, "تم إضافة التصنيف بنجاح");
    }

    public async Task<ApiResponse<List<SupplierDto>>> GetSuppliersAsync(Guid tenantId)
    {
        var suppliers = await _unitOfWork.Suppliers.FindAsync(s => s.TenantId == tenantId);
        return ApiResponse<List<SupplierDto>>.Ok(suppliers.Select(MapSupplierToDto).ToList());
    }

    public async Task<ApiResponse<SupplierDto>> CreateSupplierAsync(Guid tenantId, CreateSupplierDto dto)
    {
        var supplier = new Supplier
        {
            TenantId = tenantId,
            Name = dto.Name,
            ContactPerson = dto.ContactPerson,
            Phone = dto.Phone,
            Email = dto.Email,
            Address = dto.Address,
            TaxNumber = dto.TaxNumber,
        };

        await _unitOfWork.Suppliers.AddAsync(supplier);
        await _unitOfWork.SaveChangesAsync();

        return ApiResponse<SupplierDto>.Ok(MapSupplierToDto(supplier), "تم إضافة المورد بنجاح");
    }

    public async Task<ApiResponse<List<StockLevelDto>>> GetStockLevelsAsync(Guid tenantId, Guid? warehouseId, Guid? itemId)
    {
        var levels = await _unitOfWork.StockLevels.FindAsync(sl =>
            sl.TenantId == tenantId
            && (!warehouseId.HasValue || sl.WarehouseId == warehouseId.Value)
            && (!itemId.HasValue || sl.ItemId == itemId.Value));

        var levelsList = levels.ToList();
        if (levelsList.Count == 0)
            return ApiResponse<List<StockLevelDto>>.Ok(new List<StockLevelDto>());

        var itemIds = levelsList.Select(l => l.ItemId).Distinct().ToList();
        var warehouseIds = levelsList.Select(l => l.WarehouseId).Distinct().ToList();

        var items = (await _unitOfWork.InventoryItems.FindAsync(i => itemIds.Contains(i.Id)))
            .ToDictionary(i => i.Id, i => i.Name);
        var warehouses = (await _unitOfWork.Warehouses.FindAsync(w => warehouseIds.Contains(w.Id)))
            .ToDictionary(w => w.Id, w => w.Name);

        return ApiResponse<List<StockLevelDto>>.Ok(levelsList.Select(l => new StockLevelDto
        {
            ItemId = l.ItemId,
            ItemName = items.GetValueOrDefault(l.ItemId, "غير معروف"),
            WarehouseId = l.WarehouseId,
            WarehouseName = warehouses.GetValueOrDefault(l.WarehouseId, "غير معروف"),
            QuantityOnHand = l.QuantityOnHand,
            AverageCost = l.AverageCost,
        }).ToList());
    }

    private static InventoryItemDto MapToDto(InventoryItem item, Dictionary<Guid, string> categories)
        => MapToDto(item, item.CategoryId.HasValue ? categories.GetValueOrDefault(item.CategoryId.Value) : null);

    private static InventoryItemDto MapToDto(InventoryItem item, string? categoryName) => new()
    {
        Id = item.Id,
        Name = item.Name,
        Sku = item.Sku,
        Barcode = item.Barcode,
        CategoryId = item.CategoryId,
        CategoryName = categoryName,
        UnitOfMeasure = item.UnitOfMeasure,
        IsPharmacyItem = item.IsPharmacyItem,
        TracksBatches = item.TracksBatches,
        CostPrice = item.CostPrice,
        SalePrice = item.SalePrice,
        ReorderPoint = item.ReorderPoint,
        SafetyStock = item.SafetyStock,
        IsActive = item.IsActive,
    };

    private static SupplierDto MapSupplierToDto(Supplier s) => new()
    {
        Id = s.Id,
        Name = s.Name,
        ContactPerson = s.ContactPerson,
        Phone = s.Phone,
        Email = s.Email,
        Address = s.Address,
        TaxNumber = s.TaxNumber,
        IsActive = s.IsActive,
    };
}
