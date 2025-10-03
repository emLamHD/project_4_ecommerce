using Ecom.Application.DTOs.Auth;
using Ecom.Application.Features.Auth.Queries;
using MediatR;

namespace Ecom.Application.Features.Auth.Queries
{
    public record GetCurrentUserQuery : IRequest<AuthResultDto>;
}