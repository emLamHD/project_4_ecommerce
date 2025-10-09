using back_end.Infrastructure.Repositories;

namespace back_end.Infrastructure.Tests
{
    public class UserRepositoryTests : IClassFixture<DatabaseFixture>
    {
        private readonly DatabaseFixture _fixture;
        private readonly UserRepository _repository;

        public UserRepositoryTests(DatabaseFixture fixture)
        {
            _fixture = fixture;
            _repository = new UserRepository(_fixture.Context, new Mock<ILogger<UserRepository>>().Object);
        }

        [Fact]
        public async Task GetActiveUserByEmail_ShouldReturnUser_WhenUserExists()
        {
            // Act
            var user = await _repository.GetActiveUserByEmailAsync("test@example.com");

            // Assert
            Assert.NotNull(user);
            Assert.Equal("test@example.com", user.Email);
        }
    }
}
