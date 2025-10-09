using Microsoft.EntityFrameworkCore;
using back_end.Core.Entities;

namespace back_end.Infrastructure.Data
{
    public class EcommerceDbContext : DbContext
    {
        public EcommerceDbContext(DbContextOptions<EcommerceDbContext> options) : base(options)
        {
        }

        // DbSets - chỉ định nghĩa những entities cần cho Auth
        public DbSet<User> Users { get; set; }
        public DbSet<Address> Addresses { get; set; }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            base.OnModelCreating(modelBuilder);

            // User Configuration
            modelBuilder.Entity<User>(entity =>
            {
                entity.ToTable("users");
                entity.HasKey(u => u.Id);
                entity.HasIndex(u => u.Email).IsUnique();

                entity.Property(u => u.Email)
                    .IsRequired()
                    .HasMaxLength(255);

                entity.Property(u => u.Password)
                    .IsRequired()
                    .HasMaxLength(255);

                entity.Property(u => u.Role)
                    .IsRequired()
                    .HasMaxLength(20)
                    .HasConversion<string>();

                entity.Property(u => u.IsLocked)
                    .IsRequired()
                    .HasMaxLength(3)
                    .HasDefaultValue("no")
                    .HasConversion<string>();

                entity.Property(u => u.IsDeleted)
                    .IsRequired()
                    .HasDefaultValue(false);

                entity.Property(u => u.CreatedAt)
                    .HasDefaultValueSql("GETDATE()");

                entity.Property(u => u.UpdatedAt)
                    .HasDefaultValueSql("GETDATE()");
            });

            // Address Configuration
            modelBuilder.Entity<Address>(entity =>
            {
                entity.ToTable("addresses");
                entity.HasKey(a => a.Id);

                entity.HasOne(a => a.User)
                      .WithMany(u => u.Addresses)
                      .HasForeignKey(a => a.UserId)
                      .OnDelete(DeleteBehavior.Cascade);

                entity.Property(a => a.IsDefault)
                    .IsRequired()
                    .HasMaxLength(3)
                    .HasDefaultValue("no")
                    .HasConversion<string>();
            });
        }
    }
}
