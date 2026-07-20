using MediCore.Application.Common;
using MediCore.Application.DTOs.Invoice;
using MediCore.Application.DTOs.Laboratory;
using MediCore.Application.Interfaces;
using MediCore.Domain.Entities.Laboratory;
using MediCore.Domain.Enums;

namespace MediCore.Application.Services;

public class LabService : ILabService
{
    private readonly IUnitOfWork _unitOfWork;
    private readonly IInvoiceService _invoiceService;

    public LabService(IUnitOfWork unitOfWork, IInvoiceService invoiceService)
    {
        _unitOfWork = unitOfWork;
        _invoiceService = invoiceService;
    }

    public async Task<ApiResponse<List<LabTestCatalogDto>>> GetCatalogAsync(Guid tenantId)
    {
        var catalog = await _unitOfWork.LabTestCatalog.FindAsync(c => c.TenantId == tenantId && c.IsActive);
        return ApiResponse<List<LabTestCatalogDto>>.Ok(catalog.Select(c => new LabTestCatalogDto
        {
            Id = c.Id,
            Code = c.Code,
            Name = c.Name,
            Unit = c.Unit,
            ReferenceLow = c.ReferenceLow,
            ReferenceHigh = c.ReferenceHigh,
            Price = c.Price,
        }).ToList());
    }

    public async Task<ApiResponse<LabTestCatalogDto>> CreateCatalogEntryAsync(Guid tenantId, CreateLabTestCatalogDto dto)
    {
        var entry = new LabTestCatalog
        {
            TenantId = tenantId,
            Code = dto.Code,
            Name = dto.Name,
            Unit = dto.Unit,
            ReferenceLow = dto.ReferenceLow,
            ReferenceHigh = dto.ReferenceHigh,
            CriticalLow = dto.CriticalLow,
            CriticalHigh = dto.CriticalHigh,
            Price = dto.Price,
        };

        await _unitOfWork.LabTestCatalog.AddAsync(entry);
        await _unitOfWork.SaveChangesAsync();

        return ApiResponse<LabTestCatalogDto>.Ok(new LabTestCatalogDto
        {
            Id = entry.Id,
            Code = entry.Code,
            Name = entry.Name,
            Unit = entry.Unit,
            ReferenceLow = entry.ReferenceLow,
            ReferenceHigh = entry.ReferenceHigh,
            Price = entry.Price,
        }, "تم إضافة الفحص بنجاح");
    }

    public async Task<ApiResponse<LabOrderDto>> CreateOrderAsync(
        Guid tenantId, Guid branchId, Guid doctorId, CreateLabOrderDto dto)
    {
        if (dto.LabTestCatalogIds.Count == 0)
            return ApiResponse<LabOrderDto>.Fail("يجب اختيار فحص واحد على الأقل");

        var order = new LabOrder
        {
            TenantId = tenantId,
            BranchId = branchId,
            PatientId = dto.PatientId,
            DoctorId = doctorId,
            EncounterId = dto.EncounterId,
            ClinicalNotes = dto.ClinicalNotes,
        };

        var invoiceItems = new List<CreateInvoiceItemDto>();

        foreach (var catalogId in dto.LabTestCatalogIds)
        {
            var catalogEntry = await _unitOfWork.LabTestCatalog.GetByIdAsync(catalogId);
            if (catalogEntry == null)
                return ApiResponse<LabOrderDto>.Fail("أحد الفحوصات المطلوبة غير موجود");

            order.Items.Add(new LabOrderItem
            {
                LabOrderId = order.Id,
                LabTestCatalogId = catalogId,
            });

            invoiceItems.Add(new CreateInvoiceItemDto
            {
                Description = catalogEntry.Name,
                Quantity = 1,
                UnitPrice = catalogEntry.Price,
            });
        }

        if (dto.CreateInvoice)
        {
            var invoiceResult = await _invoiceService.CreateAsync(tenantId, branchId, doctorId, new CreateInvoiceDto
            {
                PatientId = dto.PatientId,
                EncounterId = dto.EncounterId,
                Items = invoiceItems,
            });

            if (invoiceResult.Success && invoiceResult.Data != null)
                order.InvoiceId = invoiceResult.Data.Id;
        }

        await _unitOfWork.LabOrders.AddAsync(order);
        await _unitOfWork.SaveChangesAsync();

        var saved = await _unitOfWork.LabOrders.GetByIdWithDetailsAsync(tenantId, order.Id);
        return ApiResponse<LabOrderDto>.Ok(MapToDto(saved!), "تم إنشاء طلب التحليل بنجاح");
    }

    public async Task<ApiResponse<LabOrderDto>> GetByIdAsync(Guid tenantId, Guid orderId)
    {
        var order = await _unitOfWork.LabOrders.GetByIdWithDetailsAsync(tenantId, orderId);
        if (order == null)
            return ApiResponse<LabOrderDto>.Fail("طلب التحليل غير موجود");

        return ApiResponse<LabOrderDto>.Ok(MapToDto(order));
    }

    public async Task<ApiResponse<List<LabOrderDto>>> GetByPatientAsync(Guid tenantId, Guid patientId)
    {
        var orders = await _unitOfWork.LabOrders.GetByPatientWithDetailsAsync(tenantId, patientId);
        return ApiResponse<List<LabOrderDto>>.Ok(orders.Select(MapToDto).ToList());
    }

    public async Task<ApiResponse<List<LabOrderDto>>> GetPendingOrdersAsync(Guid tenantId)
    {
        var orders = await _unitOfWork.LabOrders.GetPendingWithDetailsAsync(tenantId);
        return ApiResponse<List<LabOrderDto>>.Ok(orders.Select(MapToDto).ToList());
    }

    public async Task<ApiResponse<LabOrderDto>> EnterResultAsync(Guid tenantId, Guid enteredBy, EnterLabResultDto dto)
    {
        var item = await _unitOfWork.LabOrderItems.GetByIdWithDetailsAsync(dto.LabOrderItemId);
        if (item == null || item.LabOrder.TenantId != tenantId)
            return ApiResponse<LabOrderDto>.Fail("عنصر الطلب غير موجود");

        var flag = ComputeFlag(dto.NumericValue, item.LabTestCatalog);

        if (item.Result == null)
        {
            item.Result = new LabResult
            {
                TenantId = tenantId,
                LabOrderItemId = item.Id,
                NumericValue = dto.NumericValue,
                TextValue = dto.TextValue,
                Flag = flag,
                EnteredBy = enteredBy,
            };
            await _unitOfWork.LabResults.AddAsync(item.Result);
        }
        else
        {
            item.Result.NumericValue = dto.NumericValue;
            item.Result.TextValue = dto.TextValue;
            item.Result.Flag = flag;
            item.Result.EnteredBy = enteredBy;
            item.Result.EnteredAt = DateTime.UtcNow;
            await _unitOfWork.LabResults.UpdateAsync(item.Result);
        }

        item.LabOrder.Status = LabOrderStatus.ResultEntered;
        await _unitOfWork.LabOrders.UpdateAsync(item.LabOrder);

        await _unitOfWork.SaveChangesAsync();

        var order = await _unitOfWork.LabOrders.GetByIdWithDetailsAsync(tenantId, item.LabOrderId);
        return ApiResponse<LabOrderDto>.Ok(MapToDto(order!), "تم تسجيل النتيجة بنجاح");
    }

    public async Task<ApiResponse<LabOrderDto>> ReviewResultAsync(
        Guid tenantId, Guid labOrderItemId, Guid reviewedBy, ReviewLabResultDto dto)
    {
        var item = await _unitOfWork.LabOrderItems.GetByIdWithDetailsAsync(labOrderItemId);
        if (item == null || item.LabOrder.TenantId != tenantId || item.Result == null)
            return ApiResponse<LabOrderDto>.Fail("لا توجد نتيجة لمراجعتها");

        item.Result.ReviewedByDoctor = true;
        item.Result.ReviewedBy = reviewedBy;
        item.Result.ReviewedAt = DateTime.UtcNow;
        item.Result.DoctorComment = dto.DoctorComment;
        await _unitOfWork.LabResults.UpdateAsync(item.Result);

        // If every item on this order now has a doctor-reviewed result, mark the whole order reviewed.
        var order = await _unitOfWork.LabOrders.GetByIdWithDetailsAsync(tenantId, item.LabOrderId);
        if (order != null && order.Items.All(i => i.Result?.ReviewedByDoctor == true))
        {
            order.Status = LabOrderStatus.ReviewedByDoctor;
            await _unitOfWork.LabOrders.UpdateAsync(order);
        }

        await _unitOfWork.SaveChangesAsync();

        var refreshed = await _unitOfWork.LabOrders.GetByIdWithDetailsAsync(tenantId, item.LabOrderId);
        return ApiResponse<LabOrderDto>.Ok(MapToDto(refreshed!), "تمت مراجعة النتيجة بنجاح");
    }

    private static LabResultFlag ComputeFlag(decimal? value, LabTestCatalog catalog)
    {
        if (value == null) return LabResultFlag.Normal;

        if (catalog.CriticalLow.HasValue && value < catalog.CriticalLow) return LabResultFlag.Critical;
        if (catalog.CriticalHigh.HasValue && value > catalog.CriticalHigh) return LabResultFlag.Critical;
        if (catalog.ReferenceLow.HasValue && value < catalog.ReferenceLow) return LabResultFlag.Low;
        if (catalog.ReferenceHigh.HasValue && value > catalog.ReferenceHigh) return LabResultFlag.High;

        return LabResultFlag.Normal;
    }

    private static LabOrderDto MapToDto(LabOrder order) => new()
    {
        Id = order.Id,
        PatientId = order.PatientId,
        DoctorId = order.DoctorId,
        Status = order.Status.ToString(),
        OrderedAt = order.OrderedAt,
        ClinicalNotes = order.ClinicalNotes,
        Items = order.Items.Select(i => new LabOrderItemDto
        {
            Id = i.Id,
            LabTestCatalogId = i.LabTestCatalogId,
            TestName = i.LabTestCatalog.Name,
            Unit = i.LabTestCatalog.Unit,
            ReferenceLow = i.LabTestCatalog.ReferenceLow,
            ReferenceHigh = i.LabTestCatalog.ReferenceHigh,
            Result = i.Result == null ? null : new LabResultDto
            {
                Id = i.Result.Id,
                NumericValue = i.Result.NumericValue,
                TextValue = i.Result.TextValue,
                Flag = i.Result.Flag.ToString(),
                ReviewedByDoctor = i.Result.ReviewedByDoctor,
                DoctorComment = i.Result.DoctorComment,
                EnteredAt = i.Result.EnteredAt,
            },
        }).ToList(),
    };
}
