using back_end.Core.Entities;
using back_end.Core.Interfaces.Repositories;


namespace back_end.Core.UseCases.Auth
{
    public class RegisterUserUseCase
    {
        private readonly IUserRepository _userRepository;
        private readonly ILogger<RegisterUserUseCase> _logger;

        public async Task<User> ExecuteAsync(User user, string password)
        {
            // Validate business rules
            if (await _userRepository.ActiveUserExistsAsync(user.Email))
                throw new Exception("Email already exists");

            if (string.IsNullOrWhiteSpace(user.Name))
                throw new Exception("Name is required");

            // Hash password ở application layer
            var passwordHash = BCrypt.Net.BCrypt.HashPassword(password);

            _logger.LogInformation("Registering user: {Email}", user.Email);

            // Gọi repository (sẽ gọi SP/EF Core)
            var result = await _userRepository.RegisterAsync(user, passwordHash);

            _logger.LogInformation("User registered successfully: {UserId}", result.Id);
            return result;
        }
    }
}
