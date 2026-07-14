namespace MediCore.Domain.Enums;

public enum AppointmentStatus
{
    Booked = 1,
    Arrived = 2,
    Waiting = 3,
    InProgress = 4,
    Done = 5,
    Cancelled = 6,
    NoShow = 7,
    Rescheduled = 8
}