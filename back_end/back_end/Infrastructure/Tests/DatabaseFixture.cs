using back_end.Core.Entities;
using back_end.Infrastructure.Data;
using Microsoft.EntityFrameworkCore;

namespace back_end.Infrastructure.Tests
{
    public class DatabaseFixture : IDisposable
    {
        public EcommerceDbContext Context { get; private set; }
        private readonly string _testConnectionString = "Server=(localdb)\\mssqllocaldb;Database=EcommerceDB_Test;Trusted_Connection=true;MultipleActiveResultSets=true";

        public DatabaseFixture()
        {
            var options = new DbContextOptionsBuilder<EcommerceDbContext>()
                .UseSqlServer(_testConnectionString)
                .Options;

            Context = new EcommerceDbContext(options);

            // Ensure test database is clean
            Context.Database.EnsureDeleted();
            Context.Database.EnsureCreated();

            SeedTestData();
        }

        private void SeedTestData()
        {
            // Seed test users
            var testUser = new User
            {
                Email = "test@example.com",
                Password = BCrypt.Net.BCrypt.HashPassword("password123"),
                Name = "Test User",
                Role = "user",
                IsLocked = "no",
                IsDeleted = false,
                CreatedAt = DateTime.UtcNow,
                UpdatedAt = DateTime.UtcNow
            };

            Context.Users.Add(testUser);
            Context.SaveChanges();
        }

        public void Dispose()
        {
            throw new NotImplementedException();
        }
    }
}
