namespace MediCore.Application.DTOs.Laboratory;

public class LabTestCatalogDto
{
    public Guid Id { get; set; }
    public string Code { get; set; } = string.Empty;
    public string Name { get; set; } = string.Empty;
    public string? Unit { get; set; }
    public decimal? ReferenceLow { get; set; }
    public decimal? ReferenceHigh { get; set; }
    public decimal Price { get; set; }
}

public class CreateLabTestCatalogDto
{
    public string Code { get; set; } = string.Empty;
    public string Name { get; set; } = string.Empty;
    public string? Unit { get; set; }
    public decimal? ReferenceLow { get; set; }
    public decimal? ReferenceHigh { get; set; }
    public decimal? CriticalLow { get; set; }
    public decimal? CriticalHigh { get; set; }
    public decimal Price { get; set; }
}

public class CreateLabOrderDto
{
    public Guid PatientId { get; set; }
    public Guid? EncounterId { get; set; }
    public string? ClinicalNotes { get; set; }
    public List<Guid> LabTestCatalogIds { get; set; } = new();

    /// <summary>If true, an Invoice is created for the ordered tests via the existing Invoices module.</summary>
    public bool CreateInvoice { get; set; } = true;
}

public class EnterLabResultDto
{
    public Guid LabOrderItemId { get; set; }
    public decimal? NumericValue { get; set; }
    public string? TextValue { get; set; }
}

public class ReviewLabResultDto
{
    public string? DoctorComment { get; set; }
}

public class LabResultDto
{
    public Guid Id { get; set; }
    public decimal? NumericValue { get; set; }
    public string? TextValue { get; set; }
    public string Flag { get; set; } = string.Empty;
    public bool ReviewedByDoctor { get; set; }
    public string? DoctorComment { get; set; }
    public DateTime EnteredAt { get; set; }
}

public class LabOrderItemDto
{
    public Guid Id { get; set; }
    public Guid LabTestCatalogId { get; set; }
    public string TestName { get; set; } = string.Empty;
    public string? Unit { get; set; }
    public decimal? ReferenceLow { get; set; }
    public decimal? ReferenceHigh { get; set; }
    public LabResultDto? Result { get; set; }
}

public class LabOrderDto
{
    public Guid Id { get; set; }
    public Guid PatientId { get; set; }
    public Guid DoctorId { get; set; }
    public string Status { get; set; } = string.Empty;
    public DateTime OrderedAt { get; set; }
    public string? ClinicalNotes { get; set; }
    public List<LabOrderItemDto> Items { get; set; } = new();
}
