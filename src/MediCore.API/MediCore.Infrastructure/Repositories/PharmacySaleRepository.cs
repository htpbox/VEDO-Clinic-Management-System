using MediCore.Application.Interfaces.Repositories;
using MediCore.Domain.Entities.Pharmacy;
using MediCore.Infrastructure.Data;

namespace MediCore.Infrastructure.Repositories;

public class PharmacySaleRepository : GenericRepository<PharmacySale>, IPharmacySaleRepository
{
    public PharmacySaleRepository(MediCoreDbContext context) : base(context)
    {
    }
}
