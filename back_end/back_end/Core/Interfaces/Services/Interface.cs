using back_end.Core.Entities;

namespace back_end.Core.Interfaces.Services
{
    public interface IJwtService
    {
        string GenerateToken(User user);
        int? ValidateToken(string token);
    }
}
