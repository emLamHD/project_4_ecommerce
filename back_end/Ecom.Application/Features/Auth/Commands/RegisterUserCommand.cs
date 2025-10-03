using MediatR;
using Ecom.Application.DTOs.Auth;
using Ecom.Domain.Enums;

namespace Ecom.Application.Features.Auth.Commands
{
    public class RegisterUserCommand : IRequest<AuthResultDto>
    {
        public string Email { get; set; }
        public string Password { get; set; }
        public string Name { get; set; }

        public UserRole Role { get; set; } = UserRole.User;
    }
}
