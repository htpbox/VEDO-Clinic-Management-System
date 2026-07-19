using MediCore.Application.Interfaces.Repositories;
using MediCore.Domain.Entities.Medical;
using MediCore.Infrastructure.Data;

namespace MediCore.Infrastructure.Repositories;

public class PrescriptionItemRepository : GenericRepository<PrescriptionItem>, IPrescriptionItemRepository
{
    public PrescriptionItemRepository(MediCoreDbContext context) : base(context)
    {
    }
}
