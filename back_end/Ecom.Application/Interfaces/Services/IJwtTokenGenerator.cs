using Ecom.Domain.Entities;

namespace Ecom.Application.Interfaces.Services
{
    public interface IJwtTokenGenerator
    {
        string GenerateToken(User user);
    }
}
