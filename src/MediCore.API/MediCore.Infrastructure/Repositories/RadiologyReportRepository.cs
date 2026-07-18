using MediCore.Application.Interfaces.Repositories;
using MediCore.Domain.Entities.Radiology;
using MediCore.Infrastructure.Data;

namespace MediCore.Infrastructure.Repositories;

public class RadiologyReportRepository : GenericRepository<RadiologyReport>, IRadiologyReportRepository
{
    public RadiologyReportRepository(MediCoreDbContext context) : base(context)
    {
    }
}
