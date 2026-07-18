using MediCore.Application.Interfaces.Repositories;
using MediCore.Domain.Entities.Inventory;
using MediCore.Infrastructure.Data;

namespace MediCore.Infrastructure.Repositories;

public class SupplierPaymentRepository : GenericRepository<SupplierPayment>, ISupplierPaymentRepository
{
    public SupplierPaymentRepository(MediCoreDbContext context) : base(context)
    {
    }
}
