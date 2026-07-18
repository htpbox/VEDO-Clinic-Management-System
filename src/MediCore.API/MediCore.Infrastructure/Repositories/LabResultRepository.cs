using MediCore.Application.Interfaces.Repositories;
using MediCore.Domain.Entities.Laboratory;
using MediCore.Infrastructure.Data;

namespace MediCore.Infrastructure.Repositories;

public class LabResultRepository : GenericRepository<LabResult>, ILabResultRepository
{
    public LabResultRepository(MediCoreDbContext context) : base(context)
    {
    }
}
