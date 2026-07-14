namespace MediCore.Application.DTOs.Invoice;

public class RecordPaymentDto
{
    public decimal Amount { get; set; }
    public string PaymentMethod { get; set; } = "Cash";
    public string? ReferenceNumber { get; set; }
    public string? Notes { get; set; }
}