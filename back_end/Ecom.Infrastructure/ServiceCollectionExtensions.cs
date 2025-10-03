using Ecom.Application.Interfaces.Repositories;
using Ecom.Application.Interfaces.Services;
using Ecom.Infrastructure.Persistence.Repositories;
using Ecom.Infrastructure.Services;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Configuration;

namespace Ecom.Infrastructure
{
    public static class ServiceCollectionExtensions
    {
        public static IServiceCollection AddInfrastructureServices(
            this IServiceCollection services,
            IConfiguration configuration)
        {
            services.Configure<JwtSettings>(
                configuration.GetSection(JwtSettings.SectionName));

            services.AddSingleton<IPasswordHasher, BCryptHasher>();

            services.AddSingleton<IJwtTokenGenerator, JwtTokenService>();

            services.AddSingleton<IUserRepository, UserRepository>();


            return services;
        }
    }
}
