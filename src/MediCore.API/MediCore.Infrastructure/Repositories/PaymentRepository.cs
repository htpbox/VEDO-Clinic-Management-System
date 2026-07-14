using MediCore.Application.Interfaces.Repositories;
using MediCore.Domain.Entities.Financial;
using MediCore.Infrastructure.Data;

namespace MediCore.Infrastructure.Repositories;

public class PaymentRepository : GenericRepository<Payment>, IPaymentRepository
{
    public PaymentRepository(MediCoreDbContext context) : base(context)
    {
    }
}