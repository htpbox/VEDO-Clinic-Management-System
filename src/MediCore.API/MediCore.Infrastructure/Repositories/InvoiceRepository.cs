using MediCore.Application.Interfaces.Repositories;
using MediCore.Domain.Entities.Financial;
using MediCore.Infrastructure.Data;

namespace MediCore.Infrastructure.Repositories;

public class InvoiceRepository : GenericRepository<Invoice>, IInvoiceRepository
{
    public InvoiceRepository(MediCoreDbContext context) : base(context)
    {
    }
}