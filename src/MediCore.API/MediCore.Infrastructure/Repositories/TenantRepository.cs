using MediCore.Application.Interfaces.Repositories;
using MediCore.Domain.Entities;
using MediCore.Infrastructure.Data;

namespace MediCore.Infrastructure.Repositories;

public class TenantRepository : GenericRepository<Tenant>, ITenantRepository
{
    public TenantRepository(MediCoreDbContext context) : base(context)
    {
    }
}
