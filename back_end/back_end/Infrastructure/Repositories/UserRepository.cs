using back_end.Core.Entities;
using back_end.Core.Interfaces.Repositories;
using back_end.Infrastructure.Data;
using Microsoft.Data.SqlClient;
using Microsoft.EntityFrameworkCore;

namespace back_end.Infrastructure.Repositories
{
    public class UserRepository : IUserRepository
    {
        private readonly EcommerceDbContext _context;
        private readonly ILogger<UserRepository> _logger;
        public async Task<User> RegisterAsync(User user, string passwordHash)
        {
            try
            {
                // Gọi stored procedure nếu có SP_User_Register
                // Hoặc dùng EF Core + execute raw SQL
                var parameters = new[]
                {
                new SqlParameter("@email", user.Email),
                new SqlParameter("@passwordHash", passwordHash),
                new SqlParameter("@name", user.Name ?? ""),
                new SqlParameter("@role", user.Role ?? "user"),
                new SqlParameter("@phone", user.Phone ?? (object)DBNull.Value)
            };

                // Nếu có SP: await _context.Database.ExecuteSqlRawAsync("EXEC SP_User_Register ...", parameters);
                // Tạm thời dùng EF Core
                user.Password = passwordHash;
                user.CreatedAt = DateTime.UtcNow;
                user.UpdatedAt = DateTime.UtcNow;
                user.IsLocked = "no";
                user.IsDeleted = false;

                _context.Users.Add(user);
                await _context.SaveChangesAsync();

                _logger.LogInformation("User registered successfully: {Email}", user.Email);
                return user;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error registering user: {Email}", user.Email);
                throw;
            }
        }

        public async Task<User> GetActiveUserByEmailAsync(string email)
        {
            // Sử dụng view vw_users_active từ DB
            return await _context.Users
                .FromSqlRaw("SELECT * FROM vw_users_active WHERE email = {0}", email)
                .AsNoTracking()
                .FirstOrDefaultAsync();
        }

        public async Task<User> GetActiveUserByIdAsync(int id)
        {
            // Sử dụng view vw_users_active
            return await _context.Users
                .FromSqlRaw("SELECT * FROM vw_users_active WHERE id = {0}", id)
                .AsNoTracking()
                .FirstOrDefaultAsync();
        }

        public async Task<List<User>> GetActiveUsersAsync()
        {
            // Sử dụng stored procedure SP_User_GetActiveList
            return await _context.Users
                .FromSqlRaw("EXEC SP_User_GetActiveList")
                .AsNoTracking()
                .ToListAsync();
        }

        public Task<User> UpdateUserAsync(User user)
        {
            throw new NotImplementedException();
        }

        public Task<bool> ActiveUserExistsAsync(string email)
        {
            throw new NotImplementedException();
        }

        public Task<Address> AddUserAddressAsync(Address address)
        {
            throw new NotImplementedException();
        }

        public Task<List<Address>> GetUserAddressesAsync(int userId)
        {
            throw new NotImplementedException();
        }
    }
}
