using MediCore.Application.Interfaces.Repositories;
using MediCore.Domain.Entities.Laboratory;
using MediCore.Infrastructure.Data;

namespace MediCore.Infrastructure.Repositories;

public class LabTestCatalogRepository : GenericRepository<LabTestCatalog>, ILabTestCatalogRepository
{
    public LabTestCatalogRepository(MediCoreDbContext context) : base(context)
    {
    }
}
