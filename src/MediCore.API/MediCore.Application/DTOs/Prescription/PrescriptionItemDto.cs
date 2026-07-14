namespace MediCore.Application.DTOs.Prescription;

public class PrescriptionItemDto
{
    public Guid Id { get; set; }
    public string DrugName { get; set; } = string.Empty;
    public string? ActiveIngredient { get; set; }
    public string? Dose { get; set; }
    public string? Frequency { get; set; }
    public string? Route { get; set; }
    public int? DurationDays { get; set; }
    public int? Quantity { get; set; }
    public string? Instructions { get; set; }
}