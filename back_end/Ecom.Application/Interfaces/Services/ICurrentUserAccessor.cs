using Ecom.Application.Interfaces.Services;
namespace Ecom.Application.Interfaces.Services
{
    public interface ICurrentUserAccessor
    {
        string? GetCurrentUserId();
    }
}