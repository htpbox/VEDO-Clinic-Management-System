using MediCore.Application.Interfaces.Repositories;
using MediCore.Domain.Entities.Medical;
using MediCore.Infrastructure.Data;

namespace MediCore.Infrastructure.Repositories;

public class EncounterRepository : GenericRepository<Encounter>, IEncounterRepository
{
    public EncounterRepository(MediCoreDbContext context) : base(context)
    {
    }
}