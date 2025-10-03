using MediatR;
using Ecom.Application.DTOs.Auth;
using Ecom.Application.Interfaces.Repositories;
using Ecom.Application.Interfaces.Services;
using System.Threading;
using System.Threading.Tasks;
using Ecom.Domain.Exceptions;

namespace Ecom.Application.Features.Auth.Commands
{
    public class LoginUserCommandHandler : IRequestHandler<LoginUserCommand, AuthResultDto>
    {
        private readonly IUserRepository _userRepository;
        private readonly IPasswordHasher _passwordHasher;
        private readonly IJwtTokenGenerator _jwtTokenGenerator;

        public LoginUserCommandHandler(
            IUserRepository userRepository,
            IPasswordHasher passwordHasher,
            IJwtTokenGenerator jwtTokenGenerator)
        {
            _userRepository = userRepository;
            _passwordHasher = passwordHasher;
            _jwtTokenGenerator = jwtTokenGenerator;
        }

        public async Task<AuthResultDto> Handle(LoginUserCommand request, CancellationToken cancellationToken)
        {
            var user = await _userRepository.GetByEmailAsync(request.Email);

            if (user == null)
            {
                throw new InvalidCredentialsException("Thông tin đăng nhập không hợp lệ.");
            }

            if (!_passwordHasher.VerifyPassword(request.Password, user.Password))
            {
                throw new InvalidCredentialsException("Thông tin đăng nhập không hợp lệ.");
            }

            var token = _jwtTokenGenerator.GenerateToken(user);

            return new AuthResultDto
            {
                Id = user.Id,
                Email = user.Email,
                Name = user.Name,
                Token = token
            };
        }
    }
}