using Ecom.Application.Interfaces.Repositories;
using Ecom.Domain.Entities;
using System.Threading.Tasks;
using System;

namespace Ecom.Infrastructure.Persistence.Repositories
{
    public class UserRepository : IUserRepository
    {
        private static readonly Dictionary<string, User> _users = new Dictionary<string, User>();

        public Task<User> AddAsync(User user)
        {
            if (_users.ContainsKey(user.Email))
            {
                throw new InvalidOperationException($"Người dùng với email {user.Email} đã tồn tại.");
            }
            _users.Add(user.Email, user);
            return Task.FromResult(user);
        }

        public Task<bool> IsEmailUniqueAsync(string email)
        {
            return Task.FromResult(_users.ContainsKey(email));
        }

        public Task<User?> GetByEmailAsync(string email)
        {
            if (_users.TryGetValue(email, out var user))
            {
                return Task.FromResult<User?>(user);
            }
            return Task.FromResult<User?>(null);
        }
    }
}
