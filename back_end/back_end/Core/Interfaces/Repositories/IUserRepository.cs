using back_end.Core.Entities;

namespace back_end.Core.Interfaces.Repositories
{
    public interface IUserRepository
    {
        Task<User> RegisterAsync(User user, string passwordHash);
        Task<User> UpdateUserAsync(User user);

        // Sử dụng Views cho read operations  
        Task<User> GetActiveUserByEmailAsync(string email);
        Task<User> GetActiveUserByIdAsync(int id);
        Task<List<User>> GetActiveUsersAsync();
        Task<bool> ActiveUserExistsAsync(string email);

        // Address operations
        Task<Address> AddUserAddressAsync(Address address);
        Task<List<Address>> GetUserAddressesAsync(int userId);
    }
}
