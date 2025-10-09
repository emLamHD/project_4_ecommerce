using back_end.Core.Interfaces.Repositories;
using back_end.Core.Interfaces.Services;

namespace back_end.Core.UseCases.Auth
{
    public class LoginUserUseCase
    {
        private readonly IUserRepository _userRepository;
        private readonly IJwtService _jwtService;

        public async Task<LoginResult> ExecuteAsync(string email, string password)
        {
            // Sử dụng view để lấy active user
            var user = await _userRepository.GetActiveUserByEmailAsync(email);
            if (user == null)
                throw new Exception("Invalid email or password");

            // Verify password
            if (!BCrypt.Net.BCrypt.Verify(password, user.Password))
                throw new Exception("Invalid email or password");

            // Generate JWT
            var token = _jwtService.GenerateToken(user);

            return new LoginResult
            {
                Token = token,
                User = new UserDto
                {
                    Id = user.Id,
                    Email = user.Email,
                    Name = user.Name,
                    Role = user.Role,
                    Avatar = user.Avatar,
                    Phone = user.Phone
                }
            };
        }
    }
}
