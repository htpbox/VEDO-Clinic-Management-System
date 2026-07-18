namespace MediCore.Domain.Enums;

public enum LabOrderStatus
{
    Ordered = 1,
    SampleCollected = 2,
    InProgress = 3,
    ResultEntered = 4,
    ReviewedByDoctor = 5,
    Cancelled = 6,
}

public enum LabResultFlag
{
    Normal = 1,
    Low = 2,
    High = 3,
    Critical = 4,
}
