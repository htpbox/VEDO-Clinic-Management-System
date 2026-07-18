using MediCore.Application.Interfaces.Repositories;
using MediCore.Domain.Entities.Laboratory;
using MediCore.Infrastructure.Data;

namespace MediCore.Infrastructure.Repositories;

public class LabOrderRepository : GenericRepository<LabOrder>, ILabOrderRepository
{
    public LabOrderRepository(MediCoreDbContext context) : base(context)
    {
    }
}
