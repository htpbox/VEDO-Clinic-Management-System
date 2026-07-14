using MediCore.Application.Interfaces.Repositories;
using MediCore.Domain.Common;
using MediCore.Infrastructure.Data;
using Microsoft.EntityFrameworkCore;
using System.Linq.Expressions;

namespace MediCore.Infrastructure.Repositories;

public class GenericRepository<T> : IGenericRepository<T> where T : BaseEntity
{
    protected readonly MediCoreDbContext _context;
    protected readonly DbSet<T> _dbSet;

    public GenericRepository(MediCoreDbContext context)
    {
        _context = context;
        _dbSet = context.Set<T>();
    }

    public async Task<T?> GetByIdAsync(Guid id)
        => await _dbSet.FirstOrDefaultAsync(x => x.Id == id && !x.IsDeleted);

    public async Task<IEnumerable<T>> GetAllAsync()
        => await _dbSet.Where(x => !x.IsDeleted).ToListAsync();

    public async Task<IEnumerable<T>> FindAsync(Expression<Func<T, bool>> predicate)
        => await _dbSet.Where(predicate).Where(x => !x.IsDeleted).ToListAsync();

    public async Task<T?> FirstOrDefaultAsync(Expression<Func<T, bool>> predicate)
        => await _dbSet.Where(x => !x.IsDeleted).FirstOrDefaultAsync(predicate);

    public async Task<bool> ExistsAsync(Expression<Func<T, bool>> predicate)
        => await _dbSet.Where(x => !x.IsDeleted).AnyAsync(predicate);

    public async Task<int> CountAsync(Expression<Func<T, bool>> predicate)
        => await _dbSet.Where(x => !x.IsDeleted).CountAsync(predicate);

    public async Task<T> AddAsync(T entity)
    {
        await _dbSet.AddAsync(entity);
        return entity;
    }

    public async Task<IEnumerable<T>> AddRangeAsync(IEnumerable<T> entities)
    {
        await _dbSet.AddRangeAsync(entities);
        return entities;
    }

    public Task UpdateAsync(T entity)
    {
        entity.UpdatedAt = DateTime.UtcNow;
        _dbSet.Update(entity);
        return Task.CompletedTask;
    }

    public Task DeleteAsync(T entity)
    {
        _dbSet.Remove(entity);
        return Task.CompletedTask;
    }

    public Task SoftDeleteAsync(T entity, Guid deletedBy)
    {
        entity.IsDeleted = true;
        entity.DeletedAt = DateTime.UtcNow;
        entity.DeletedBy = deletedBy;
        _dbSet.Update(entity);
        return Task.CompletedTask;
    }
}