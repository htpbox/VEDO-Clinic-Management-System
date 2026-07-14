namespace MediCore.Application.DTOs.Invoice;

public class CreateInvoiceItemDto
{
    public string Description { get; set; } = string.Empty;
    public decimal Quantity { get; set; } = 1;
    public decimal UnitPrice { get; set; }
}