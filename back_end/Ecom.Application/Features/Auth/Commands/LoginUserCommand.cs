using Ecom.Application.DTOs.Auth;
using Ecom.Application.Features.Auth.Commands;
using MediatR;
using System.ComponentModel.DataAnnotations;

namespace Ecom.Application.Features.Auth.Commands
{
    public record LoginUserCommand : IRequest<AuthResultDto>
    {
        [Required(ErrorMessage = "Email không được để trống")]
        [EmailAddress(ErrorMessage = "Email không hợp lệ")]
        public string Email { get; init; } = string.Empty;

        [Required(ErrorMessage = "Mật khẩu không được để trống")]
        public string Password { get; init; } = string.Empty;
    }
}