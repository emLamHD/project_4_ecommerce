using MediatR;
using Ecom.Application.DTOs.Auth;
using Ecom.Domain.Entities;
using System.Threading;
using System.Threading.Tasks;
using System;
using Ecom.Domain.Enums;
using Ecom.Application.Interfaces.Services;

namespace Ecom.Application.Features.Auth.Commands
{
    public class RegisterUserCommandHandler : IRequestHandler<RegisterUserCommand, AuthResultDto>
    {
        private readonly IUserRepository _userRepository;
        private readonly IPasswordHasher _passwordHasher;
        private readonly IJwtTokenGenerator _jwtTokenGenerator;

        public RegisterUserCommandHandler(
            IUserRepository userRepository,
            IPasswordHasher passwordHasher,
            IJwtTokenGenerator jwtTokenGenerator)
        {
            _userRepository = userRepository;
            _passwordHasher = passwordHasher;
            _jwtTokenGenerator = jwtTokenGenerator;
        }

        public async Task<AuthResultDto> Handle(RegisterUserCommand request, CancellationToken cancellationToken)
        {
            if (string.IsNullOrEmpty(request.Email) || string.IsNullOrEmpty(request.Password))
            {
                throw new ArgumentException("Email và mật khẩu không được để trống.");
            }

            if (await _userRepository.IsEmailUniqueAsync(request.Email))
            {
                throw new Exception($"Email '{request.Email}' đã tồn tại.");
            }

            var hashedPassword = _passwordHasher.HashPassword(request.Password);

            var newUser = new User
            {
                Email = request.Email,
                Password = hashedPassword, 
                Name = request.Name,
                Role = UserRole.User, 
                IsLocked = LockStatus.No,
                IsDeleted = false,
                CreatedAt = DateTime.UtcNow,
                UpdatedAt = DateTime.UtcNow
            };

            var userEntity = await _userRepository.AddAsync(newUser);

            var token = _jwtTokenGenerator.GenerateToken(userEntity);

            return new AuthResultDto
            {
                UserId = userEntity.Id,
                Email = userEntity.Email,
                Name = userEntity.Name,
                Role = userEntity.Role,
                Token = token
            };
        }
    }
}
