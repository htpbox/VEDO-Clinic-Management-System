using MediCore.Application.Common;
using MediCore.Application.DTOs.Inventory;
using MediCore.Application.DTOs.Invoice;
using MediCore.Application.DTOs.Pharmacy;
using MediCore.Application.Interfaces;
using MediCore.Domain.Entities.Pharmacy;
using MediCore.Domain.Enums;

namespace MediCore.Application.Services;

/// <summary>
/// Note on invoicing: the existing Invoice module requires a PatientId
/// (CreateInvoiceDto.PatientId is non-nullable) - it was designed around
/// every invoice belonging to a patient. A pharmacy retail sale with no
/// patient on file (walk-in, no chart) therefore cannot get an Invoice
/// through the existing service as-is; CreateSaleAsync skips invoice
/// creation in that case rather than fabricating a placeholder patient.
/// If walk-in retail invoicing is required, CreateInvoiceDto needs a
/// nullable PatientId - a decision that touches the Invoices module this
/// session was told to leave alone unless necessary.
/// </summary>
public class PharmacyService : IPharmacyService
{
    private readonly IUnitOfWork _unitOfWork;
    private readonly IStockService _stockService;
    private readonly IInvoiceService _invoiceService;

    public PharmacyService(IUnitOfWork unitOfWork, IStockService stockService, IInvoiceService invoiceService)
    {
        _unitOfWork = unitOfWork;
        _stockService = stockService;
        _invoiceService = invoiceService;
    }

    public async Task<ApiResponse<PharmacySaleDto>> CreateSaleAsync(
        Guid tenantId, Guid branchId, Guid soldBy, CreatePharmacySaleDto dto)
    {
        if (dto.Items.Count == 0)
            return ApiResponse<PharmacySaleDto>.Fail("يجب إضافة صنف واحد على الأقل");

        var sale = new PharmacySale
        {
            TenantId = tenantId,
            BranchId = branchId,
            WarehouseId = dto.WarehouseId,
            PatientId = dto.PatientId,
            PrescriptionId = dto.PrescriptionId,
            SaleType = dto.SaleType,
            Status = PharmacySaleStatus.Completed,
            SoldBy = soldBy,
        };

        decimal total = 0;
        var invoiceItems = new List<CreateInvoiceItemDto>();

        foreach (var line in dto.Items)
        {
            var item = await _unitOfWork.InventoryItems.GetByIdAsync(line.ItemId);
            if (item == null)
                return ApiResponse<PharmacySaleDto>.Fail("أحد الأصناف غير موجود");

            var issueResult = await _stockService.IssueStockAsync(new IssueStockRequest
            {
                TenantId = tenantId,
                WarehouseId = dto.WarehouseId,
                ItemId = line.ItemId,
                Quantity = line.Quantity,
                MovementType = dto.SaleType == PharmacySaleType.PrescriptionDispense
                    ? StockMovementType.Dispense
                    : StockMovementType.Sale,
                ReferenceType = nameof(PharmacySale),
                ReferenceId = sale.Id,
            });

            if (!issueResult.Success)
                return ApiResponse<PharmacySaleDto>.Fail($"{item.Name}: {issueResult.Message}");

            sale.Items.Add(new PharmacySaleItem
            {
                PharmacySaleId = sale.Id,
                ItemId = line.ItemId,
                PrescriptionItemId = line.PrescriptionItemId,
                Quantity = line.Quantity,
                UnitPrice = line.UnitPrice,
            });

            if (line.PrescriptionItemId.HasValue)
            {
                var prescriptionItem = await _unitOfWork.PrescriptionItems.GetByIdAsync(line.PrescriptionItemId.Value);
                if (prescriptionItem != null)
                {
                    prescriptionItem.IsDispensed = true;
                    await _unitOfWork.PrescriptionItems.UpdateAsync(prescriptionItem);
                }
            }

            var lineTotal = line.Quantity * line.UnitPrice;
            total += lineTotal;
            invoiceItems.Add(new CreateInvoiceItemDto
            {
                Description = item.Name,
                Quantity = line.Quantity,
                UnitPrice = line.UnitPrice,
            });
        }

        sale.TotalAmount = total;

        if (dto.CreateInvoice && dto.PatientId.HasValue)
        {
            var invoiceResult = await _invoiceService.CreateAsync(tenantId, branchId, soldBy, new CreateInvoiceDto
            {
                PatientId = dto.PatientId.Value,
                Items = invoiceItems,
            });

            if (invoiceResult.Success && invoiceResult.Data != null)
                sale.InvoiceId = invoiceResult.Data.Id;
        }

        await _unitOfWork.PharmacySales.AddAsync(sale);
        await _unitOfWork.SaveChangesAsync();

        return ApiResponse<PharmacySaleDto>.Ok(await BuildDtoAsync(sale), "تم إتمام عملية البيع بنجاح");
    }

    public async Task<ApiResponse<PharmacySaleDto>> GetByIdAsync(Guid tenantId, Guid saleId)
    {
        var sale = await _unitOfWork.PharmacySales.GetByIdWithItemsAsync(tenantId, saleId);
        if (sale == null)
            return ApiResponse<PharmacySaleDto>.Fail("عملية البيع غير موجودة");

        return ApiResponse<PharmacySaleDto>.Ok(await BuildDtoAsync(sale));
    }

    public async Task<ApiResponse<List<PharmacySaleDto>>> GetByPatientAsync(Guid tenantId, Guid patientId)
    {
        var sales = await _unitOfWork.PharmacySales.GetByPatientWithItemsAsync(tenantId, patientId);

        var dtos = new List<PharmacySaleDto>();
        foreach (var sale in sales)
            dtos.Add(await BuildDtoAsync(sale));

        return ApiResponse<List<PharmacySaleDto>>.Ok(dtos);
    }

    public async Task<ApiResponse<PharmacySaleDto>> ReturnSaleAsync(
        Guid tenantId, Guid saleId, Guid processedBy, ReturnPharmacySaleDto dto)
    {
        var sale = await _unitOfWork.PharmacySales.GetByIdWithItemsAsync(tenantId, saleId);
        if (sale == null)
            return ApiResponse<PharmacySaleDto>.Fail("عملية البيع غير موجودة");

        if (sale.Status == PharmacySaleStatus.Returned)
            return ApiResponse<PharmacySaleDto>.Fail("تم إرجاع هذه العملية بالكامل بالفعل");

        foreach (var returnLine in dto.Items)
        {
            var saleItem = sale.Items.FirstOrDefault(i => i.Id == returnLine.PharmacySaleItemId);
            if (saleItem == null) continue;

            await _stockService.ReceiveStockAsync(new ReceiveStockRequest
            {
                TenantId = tenantId,
                WarehouseId = sale.WarehouseId,
                ItemId = saleItem.ItemId,
                Quantity = returnLine.Quantity,
                UnitCost = saleItem.UnitPrice,
                ReferenceType = "PharmacyReturn",
                ReferenceId = sale.Id,
            });
        }

        var totalOriginalQty = sale.Items.Sum(i => i.Quantity);
        var totalReturnedQty = dto.Items.Sum(i => i.Quantity);
        sale.Status = totalReturnedQty >= totalOriginalQty
            ? PharmacySaleStatus.Returned
            : PharmacySaleStatus.PartiallyReturned;

        await _unitOfWork.PharmacySales.UpdateAsync(sale);
        await _unitOfWork.SaveChangesAsync();

        return ApiResponse<PharmacySaleDto>.Ok(await BuildDtoAsync(sale), "تم تسجيل عملية الإرجاع بنجاح");
    }

    private async Task<PharmacySaleDto> BuildDtoAsync(PharmacySale sale)
    {
        var itemDtos = new List<PharmacySaleItemDto>();
        foreach (var line in sale.Items)
        {
            var item = await _unitOfWork.InventoryItems.GetByIdAsync(line.ItemId);
            itemDtos.Add(new PharmacySaleItemDto
            {
                Id = line.Id,
                ItemId = line.ItemId,
                ItemName = item?.Name ?? "غير معروف",
                Quantity = line.Quantity,
                UnitPrice = line.UnitPrice,
            });
        }

        return new PharmacySaleDto
        {
            Id = sale.Id,
            WarehouseId = sale.WarehouseId,
            PatientId = sale.PatientId,
            PrescriptionId = sale.PrescriptionId,
            InvoiceId = sale.InvoiceId,
            SaleType = sale.SaleType,
            Status = sale.Status,
            SaleDate = sale.SaleDate,
            TotalAmount = sale.TotalAmount,
            Items = itemDtos,
        };
    }
}
