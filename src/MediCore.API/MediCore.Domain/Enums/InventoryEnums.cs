namespace MediCore.Domain.Enums;

public enum StockMovementType
{
    Receipt = 1,
    Issue = 2,
    Adjustment = 3,
    TransferIn = 4,
    TransferOut = 5,
    Sale = 6,
    Dispense = 7,
    Return = 8,
}

public enum PurchaseOrderStatus
{
    Draft = 1,
    Submitted = 2,
    Approved = 3,
    PartiallyReceived = 4,
    Received = 5,
    Cancelled = 6,
}

public enum StockTransferStatus
{
    Pending = 1,
    InTransit = 2,
    Completed = 3,
    Cancelled = 4,
}

public enum PhysicalCountStatus
{
    InProgress = 1,
    Completed = 2,
    Cancelled = 3,
}
