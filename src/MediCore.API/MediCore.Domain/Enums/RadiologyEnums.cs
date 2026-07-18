namespace MediCore.Domain.Enums;

public enum RadiologyOrderStatus
{
    Ordered = 1,
    ScheduledOrInProgress = 2,
    ImagesAcquired = 3,
    ReportEntered = 4,
    ReviewedByDoctor = 5,
    Cancelled = 6,
}
