using Ecom.Domain.Entities;
using System.Collections.Generic;
using System.Threading.Tasks;

public interface IUserRepository
{
    Task<User> RegisterAsync(User user, string passwordHash);
    Task<User> GetByEmailAsync(string email);
    Task<User> GetByIdAsync(int id);
    Task<List<User>> GetActiveUserAsync();
}
