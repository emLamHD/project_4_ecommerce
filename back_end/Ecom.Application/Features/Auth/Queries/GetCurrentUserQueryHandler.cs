using Ecom.Application.DTOs.Auth;
using Ecom.Application.Features.Auth.Queries;
using Ecom.Application.Interfaces.Services;
using Ecom.Domain.Exceptions;
using MediatR;

namespace Ecom.Application.Features.Auth.Queries
{
    public class GetCurrentUserQueryHandler : IRequestHandler<GetCurrentUserQuery, AuthResultDto>
    {
        private readonly ICurrentUserAccessor _currentUserAccessor;
        private readonly IUserRepository _userRepository;

        public GetCurrentUserQueryHandler(
            ICurrentUserAccessor currentUserAccessor,
            IUserRepository userRepository)
        {
            _currentUserAccessor = currentUserAccessor;
            _userRepository = userRepository;
        }

        public async Task<AuthResultDto> Handle(GetCurrentUserQuery request, CancellationToken cancellationToken)
        {
            var userIdString = _currentUserAccessor.GetCurrentUserId();

            if (string.IsNullOrEmpty(userIdString) || !Guid.TryParse(userIdString, out var userId))
            {
                throw new UnauthorizedAccessException("Người dùng chưa được xác thực.");
            }

            var user = await _userRepository.GetByIdAsync(userId);

            if (user == null)
            {
                throw new UserNotFoundException("Không tìm thấy hồ sơ người dùng.");
            }

            return new AuthResultDto
            {
                Id = user.Id,
                Email = user.Email,
                Name = user.Name,
                Token = string.Empty
            };
        }
    }
}