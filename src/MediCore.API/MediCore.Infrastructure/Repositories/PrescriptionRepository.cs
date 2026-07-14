using MediCore.Application.Interfaces.Repositories;
using MediCore.Domain.Entities.Medical;
using MediCore.Infrastructure.Data;

namespace MediCore.Infrastructure.Repositories;

public class PrescriptionRepository : GenericRepository<Prescription>, IPrescriptionRepository
{
    public PrescriptionRepository(MediCoreDbContext context) : base(context)
    {
    }
}