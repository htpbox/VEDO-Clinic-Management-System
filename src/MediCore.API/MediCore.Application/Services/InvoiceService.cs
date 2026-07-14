using MediCore.Application.Common;
using MediCore.Application.DTOs.Invoice;
using MediCore.Application.Interfaces;
using MediCore.Application.Interfaces.Services;
using MediCore.Domain.Entities.Financial;
using MediCore.Domain.Enums;

namespace MediCore.Application.Services;

public class InvoiceService : IInvoiceService
{
    private readonly IUnitOfWork _unitOfWork;

    public InvoiceService(IUnitOfWork unitOfWork)
    {
        _unitOfWork = unitOfWork;
    }

    public async Task<ApiResponse<InvoiceDto>> GetByIdAsync(Guid tenantId, Guid invoiceId)
    {
        var invoice = await _unitOfWork.Invoices.GetByIdAsync(invoiceId);

        if (invoice == null || invoice.TenantId != tenantId)
            return ApiResponse<InvoiceDto>.Fail("الفاتورة غير موجودة");

        return ApiResponse<InvoiceDto>.Ok(MapToDto(invoice));
    }

    public async Task<ApiResponse<IEnumerable<InvoiceDto>>> GetByPatientAsync(
        Guid tenantId, Guid patientId)
    {
        var invoices = await _unitOfWork.Invoices.FindAsync(i =>
            i.TenantId == tenantId && i.PatientId == patientId);

        var ordered = invoices.OrderByDescending(i => i.CreatedAt);
        return ApiResponse<IEnumerable<InvoiceDto>>.Ok(ordered.Select(MapToDto));
    }

    public async Task<ApiResponse<InvoiceDto>> CreateAsync(
        Guid tenantId, Guid branchId, Guid createdBy, CreateInvoiceDto dto)
    {
        if (dto.Items.Count == 0)
            return ApiResponse<InvoiceDto>.Fail("يجب إضافة بند واحد على الأقل للفاتورة");

        var subtotal = dto.Items.Sum(i => i.Quantity * i.UnitPrice);
        var totalAmount = subtotal - dto.DiscountAmount;
        var invoiceNumber = $"INV-{DateTime.UtcNow:yyyyMMddHHmmss}";

        var invoice = new Invoice
        {
            TenantId = tenantId,
            BranchId = branchId,
            PatientId = dto.PatientId,
            EncounterId = dto.EncounterId,
            InvoiceNumber = invoiceNumber,
            InvoiceDate = DateOnly.FromDateTime(DateTime.UtcNow),
            Subtotal = subtotal,
            DiscountAmount = dto.DiscountAmount,
            TotalAmount = totalAmount,
            PaidAmount = 0,
            RemainingAmount = totalAmount,
            Status = InvoiceStatus.Issued,
            Notes = dto.Notes,
            CreatedBy = createdBy,
            Items = dto.Items.Select((item, index) => new InvoiceItem
            {
                TenantId = tenantId,
                Description = item.Description,
                Quantity = item.Quantity,
                UnitPrice = item.UnitPrice,
                TotalPrice = item.Quantity * item.UnitPrice,
                SortOrder = index,
                CreatedBy = createdBy
            }).ToList()
        };

        await _unitOfWork.Invoices.AddAsync(invoice);
        await _unitOfWork.SaveChangesAsync();

        return ApiResponse<InvoiceDto>.Ok(MapToDto(invoice), "تم إنشاء الفاتورة بنجاح");
    }

    public async Task<ApiResponse<InvoiceDto>> RecordPaymentAsync(
        Guid tenantId, Guid invoiceId, Guid receivedBy, RecordPaymentDto dto)
    {
        var invoice = await _unitOfWork.Invoices.GetByIdAsync(invoiceId);

        if (invoice == null || invoice.TenantId != tenantId)
            return ApiResponse<InvoiceDto>.Fail("الفاتورة غير موجودة");

        if (dto.Amount <= 0)
            return ApiResponse<InvoiceDto>.Fail("مبلغ الدفع يجب أن يكون أكبر من صفر");

        if (dto.Amount > invoice.RemainingAmount)
            return ApiResponse<InvoiceDto>.Fail("مبلغ الدفع أكبر من المبلغ المتبقي");

        if (!Enum.TryParse<PaymentMethod>(dto.PaymentMethod, true, out var method))
            return ApiResponse<InvoiceDto>.Fail("طريقة دفع غير صحيحة");

        var payment = new Payment
        {
            TenantId = tenantId,
            InvoiceId = invoice.Id,
            PatientId = invoice.PatientId,
            PaymentDate = DateTime.UtcNow,
            Amount = dto.Amount,
            PaymentMethod = method,
            ReferenceNumber = dto.ReferenceNumber,
            ReceivedBy = receivedBy,
            Notes = dto.Notes,
            CreatedBy = receivedBy
        };

        await _unitOfWork.Payments.AddAsync(payment);

        invoice.PaidAmount += dto.Amount;
        invoice.RemainingAmount -= dto.Amount;
        invoice.Status = invoice.RemainingAmount <= 0
            ? InvoiceStatus.Paid
            : InvoiceStatus.PartiallyPaid;

        await _unitOfWork.Invoices.UpdateAsync(invoice);
        await _unitOfWork.SaveChangesAsync();

        return ApiResponse<InvoiceDto>.Ok(MapToDto(invoice), "تم تسجيل الدفعة بنجاح");
    }

    private static InvoiceDto MapToDto(Invoice invoice)
    {
        return new InvoiceDto
        {
            Id = invoice.Id,
            PatientId = invoice.PatientId,
            EncounterId = invoice.EncounterId,
            InvoiceNumber = invoice.InvoiceNumber,
            InvoiceDate = invoice.InvoiceDate,
            Subtotal = invoice.Subtotal,
            DiscountAmount = invoice.DiscountAmount,
            TaxAmount = invoice.TaxAmount,
            TotalAmount = invoice.TotalAmount,
            PaidAmount = invoice.PaidAmount,
            RemainingAmount = invoice.RemainingAmount,
            Status = invoice.Status.ToString(),
            Items = invoice.Items.Select(i => new InvoiceItemDto
            {
                Id = i.Id,
                Description = i.Description,
                Quantity = i.Quantity,
                UnitPrice = i.UnitPrice,
                TotalPrice = i.TotalPrice
            }).ToList(),
            CreatedAt = invoice.CreatedAt
        };
    }
}