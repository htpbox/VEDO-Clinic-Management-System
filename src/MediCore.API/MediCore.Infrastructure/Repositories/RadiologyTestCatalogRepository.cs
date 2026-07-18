using MediCore.Application.Interfaces.Repositories;
using MediCore.Domain.Entities.Radiology;
using MediCore.Infrastructure.Data;

namespace MediCore.Infrastructure.Repositories;

public class RadiologyTestCatalogRepository : GenericRepository<RadiologyTestCatalog>, IRadiologyTestCatalogRepository
{
    public RadiologyTestCatalogRepository(MediCoreDbContext context) : base(context)
    {
    }
}
