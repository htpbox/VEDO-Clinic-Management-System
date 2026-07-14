namespace MediCore.Application.DTOs.Invoice;

public class CreateInvoiceDto
{
    public Guid PatientId { get; set; }
    public Guid? EncounterId { get; set; }
    public decimal DiscountAmount { get; set; } = 0;
    public string? Notes { get; set; }
    public List<CreateInvoiceItemDto> Items { get; set; } = new();
}