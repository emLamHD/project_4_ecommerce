using back_end.Services;
using Ecom.Application.Interfaces.Services;
using Microsoft.EntityFrameworkCore;
using System.Security.Claims;

namespace back_end.Services
{
    public class CurrentUserAccessor : ICurrentUserAccessor
    {
        private readonly IHttpContextAccessor _httpContextAccessor;

        public CurrentUserAccessor(IHttpContextAccessor httpContextAccessor)
        {
            _httpContextAccessor = httpContextAccessor;
        }

        public string? GetCurrentUserId()
        {
            var claimsPrincipal = _httpContextAccessor.HttpContext?.User;

            return claimsPrincipal?.FindFirst(ClaimTypes.NameIdentifier)?.Value;
        }
    }
}