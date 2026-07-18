using MediCore.Application.Interfaces.Repositories;
using MediCore.Domain.Entities.Radiology;
using MediCore.Infrastructure.Data;

namespace MediCore.Infrastructure.Repositories;

public class RadiologyOrderRepository : GenericRepository<RadiologyOrder>, IRadiologyOrderRepository
{
    public RadiologyOrderRepository(MediCoreDbContext context) : base(context)
    {
    }
}
