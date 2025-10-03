using Ecom.Domain.Enums;

namespace Ecom.Application.DTOs.Auth
{
    public class AuthResultDto
    {
        public int UserId { get; set; }
        public string Email { get; set; }
        public string Name { get; set; }
        public UserRole Role { get; set; }
        public string Token { get; set; } 
    }
}
