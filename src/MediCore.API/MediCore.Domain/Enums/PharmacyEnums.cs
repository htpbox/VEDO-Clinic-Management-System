namespace MediCore.Domain.Enums;

public enum PharmacySaleType
{
    Retail = 1,
    PrescriptionDispense = 2,
}

public enum PharmacySaleStatus
{
    Completed = 1,
    Returned = 2,
    PartiallyReturned = 3,
    Cancelled = 4,
}
