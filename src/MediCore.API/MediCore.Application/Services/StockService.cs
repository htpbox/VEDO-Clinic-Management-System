using MediCore.Application.Common;
using MediCore.Application.DTOs.Inventory;
using MediCore.Application.Interfaces;
using MediCore.Domain.Entities.Inventory;
using MediCore.Domain.Enums;

namespace MediCore.Application.Services;

public class StockService : IStockService
{
    private readonly IUnitOfWork _unitOfWork;

    public StockService(IUnitOfWork unitOfWork)
    {
        _unitOfWork = unitOfWork;
    }

    public async Task<ApiResponse<string>> ReceiveStockAsync(ReceiveStockRequest request)
    {
        if (request.Quantity <= 0)
            return ApiResponse<string>.Fail("الكمية يجب أن تكون أكبر من صفر");

        var item = await _unitOfWork.InventoryItems.GetByIdAsync(request.ItemId);
        if (item == null)
            return ApiResponse<string>.Fail("الصنف غير موجود");

        var stockLevel = await _unitOfWork.StockLevels.GetForItemAsync(
            request.TenantId, request.WarehouseId, request.ItemId);

        if (stockLevel == null)
        {
            stockLevel = new StockLevel
            {
                TenantId = request.TenantId,
                WarehouseId = request.WarehouseId,
                ItemId = request.ItemId,
                QuantityOnHand = 0,
                AverageCost = 0,
            };
            await _unitOfWork.StockLevels.AddAsync(stockLevel);
        }

        // Moving weighted-average cost.
        var totalValueBefore = stockLevel.QuantityOnHand * stockLevel.AverageCost;
        var incomingValue = request.Quantity * request.UnitCost;
        var newQuantity = stockLevel.QuantityOnHand + request.Quantity;

        stockLevel.AverageCost = newQuantity > 0
            ? (totalValueBefore + incomingValue) / newQuantity
            : 0;
        stockLevel.QuantityOnHand = newQuantity;
        await _unitOfWork.StockLevels.UpdateAsync(stockLevel);

        if (item.TracksBatches)
        {
            var batch = new StockBatch
            {
                TenantId = request.TenantId,
                WarehouseId = request.WarehouseId,
                ItemId = request.ItemId,
                BatchNumber = request.BatchNumber ?? $"AUTO-{DateTime.UtcNow:yyyyMMddHHmmss}",
                ExpiryDate = request.ExpiryDate,
                QuantityReceived = request.Quantity,
                QuantityRemaining = request.Quantity,
                UnitCost = request.UnitCost,
            };
            await _unitOfWork.StockBatches.AddAsync(batch);
        }

        await _unitOfWork.StockMovements.AddAsync(new StockMovement
        {
            TenantId = request.TenantId,
            WarehouseId = request.WarehouseId,
            ItemId = request.ItemId,
            MovementType = StockMovementType.Receipt,
            Quantity = request.Quantity,
            UnitCost = request.UnitCost,
            ReferenceType = request.ReferenceType,
            ReferenceId = request.ReferenceId,
        });

        await _unitOfWork.SaveChangesAsync();
        return ApiResponse<string>.Ok("تم استلام الكمية بنجاح");
    }

    public async Task<ApiResponse<string>> IssueStockAsync(IssueStockRequest request)
    {
        if (request.Quantity <= 0)
            return ApiResponse<string>.Fail("الكمية يجب أن تكون أكبر من صفر");

        var item = await _unitOfWork.InventoryItems.GetByIdAsync(request.ItemId);
        if (item == null)
            return ApiResponse<string>.Fail("الصنف غير موجود");

        var stockLevel = await _unitOfWork.StockLevels.GetForItemAsync(
            request.TenantId, request.WarehouseId, request.ItemId);

        if (stockLevel == null || stockLevel.QuantityOnHand < request.Quantity)
            return ApiResponse<string>.Fail("الكمية المتاحة غير كافية");

        if (item.TracksBatches)
        {
            var batches = await _unitOfWork.StockBatches.GetConsumableBatchesAsync(
                request.TenantId, request.WarehouseId, request.ItemId);

            var remainingToConsume = request.Quantity;
            foreach (var batch in batches)
            {
                if (remainingToConsume <= 0) break;

                var consumeFromThisBatch = Math.Min(batch.QuantityRemaining, remainingToConsume);
                batch.QuantityRemaining -= consumeFromThisBatch;
                remainingToConsume -= consumeFromThisBatch;
                await _unitOfWork.StockBatches.UpdateAsync(batch);
            }

            if (remainingToConsume > 0)
                return ApiResponse<string>.Fail("الكمية المتاحة في الدفعات غير كافية");
        }

        stockLevel.QuantityOnHand -= request.Quantity;
        await _unitOfWork.StockLevels.UpdateAsync(stockLevel);

        await _unitOfWork.StockMovements.AddAsync(new StockMovement
        {
            TenantId = request.TenantId,
            WarehouseId = request.WarehouseId,
            ItemId = request.ItemId,
            MovementType = request.MovementType,
            Quantity = -request.Quantity,
            UnitCost = stockLevel.AverageCost,
            ReferenceType = request.ReferenceType,
            ReferenceId = request.ReferenceId,
        });

        await _unitOfWork.SaveChangesAsync();
        return ApiResponse<string>.Ok("تم صرف الكمية بنجاح");
    }

    public async Task<ApiResponse<string>> AdjustStockAsync(
        Guid tenantId, Guid warehouseId, Guid itemId, decimal newQuantity, string reason, Guid adjustedBy)
    {
        if (newQuantity < 0)
            return ApiResponse<string>.Fail("الكمية لا يمكن أن تكون سالبة");

        var stockLevel = await _unitOfWork.StockLevels.GetForItemAsync(tenantId, warehouseId, itemId);
        var quantityBefore = stockLevel?.QuantityOnHand ?? 0;

        if (stockLevel == null)
        {
            stockLevel = new StockLevel
            {
                TenantId = tenantId,
                WarehouseId = warehouseId,
                ItemId = itemId,
                QuantityOnHand = 0,
                AverageCost = 0,
            };
            await _unitOfWork.StockLevels.AddAsync(stockLevel);
        }

        stockLevel.QuantityOnHand = newQuantity;
        await _unitOfWork.StockLevels.UpdateAsync(stockLevel);

        await _unitOfWork.StockAdjustments.AddAsync(new StockAdjustment
        {
            TenantId = tenantId,
            WarehouseId = warehouseId,
            ItemId = itemId,
            QuantityBefore = quantityBefore,
            QuantityAfter = newQuantity,
            Reason = reason,
            AdjustedBy = adjustedBy,
        });

        await _unitOfWork.StockMovements.AddAsync(new StockMovement
        {
            TenantId = tenantId,
            WarehouseId = warehouseId,
            ItemId = itemId,
            MovementType = StockMovementType.Adjustment,
            Quantity = newQuantity - quantityBefore,
            UnitCost = stockLevel.AverageCost,
            ReferenceType = nameof(StockAdjustment),
            Notes = reason,
        });

        await _unitOfWork.SaveChangesAsync();
        return ApiResponse<string>.Ok("تم تعديل الكمية بنجاح");
    }

    public async Task<ApiResponse<string>> TransferStockAsync(
        Guid tenantId, Guid fromWarehouseId, Guid toWarehouseId, Guid itemId, decimal quantity, Guid transferredBy)
    {
        if (fromWarehouseId == toWarehouseId)
            return ApiResponse<string>.Fail("لا يمكن التحويل لنفس المخزن");

        await _unitOfWork.BeginTransactionAsync();
        try
        {
            var issueResult = await IssueStockAsync(new IssueStockRequest
            {
                TenantId = tenantId,
                WarehouseId = fromWarehouseId,
                ItemId = itemId,
                Quantity = quantity,
                MovementType = StockMovementType.TransferOut,
                ReferenceType = "StockTransfer",
            });

            if (!issueResult.Success)
            {
                await _unitOfWork.RollbackTransactionAsync();
                return issueResult;
            }

            var sourceStock = await _unitOfWork.StockLevels.GetForItemAsync(tenantId, fromWarehouseId, itemId);
            var transferCost = sourceStock?.AverageCost ?? 0;

            var receiveResult = await ReceiveStockAsync(new ReceiveStockRequest
            {
                TenantId = tenantId,
                WarehouseId = toWarehouseId,
                ItemId = itemId,
                Quantity = quantity,
                UnitCost = transferCost,
                ReferenceType = "StockTransfer",
            });

            if (!receiveResult.Success)
            {
                await _unitOfWork.RollbackTransactionAsync();
                return receiveResult;
            }

            await _unitOfWork.CommitTransactionAsync();
            return ApiResponse<string>.Ok("تم تحويل الكمية بنجاح");
        }
        catch
        {
            await _unitOfWork.RollbackTransactionAsync();
            throw;
        }
    }

    public async Task<ApiResponse<List<LowStockItemDto>>> GetLowStockItemsAsync(Guid tenantId, Guid? warehouseId)
    {
        var items = await _unitOfWork.StockLevels.GetLowStockAsync(tenantId, warehouseId);
        return ApiResponse<List<LowStockItemDto>>.Ok(items);
    }

    public async Task<ApiResponse<List<ExpiringBatchDto>>> GetExpiringBatchesAsync(Guid tenantId, int withinDays)
    {
        var batches = await _unitOfWork.StockBatches.GetExpiringSoonAsync(tenantId, withinDays);
        return ApiResponse<List<ExpiringBatchDto>>.Ok(batches);
    }
}
