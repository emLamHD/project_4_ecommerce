using Microsoft.EntityFrameworkCore;
using Core.Entities;
using Core.Enums;

namespace Infrastructure.Data
{
    public class AppDbContext : DbContext
    {
        public AppDbContext(DbContextOptions<AppDbContext> options)
            : base(options) { }

        public DbSet<User> Users { get; set; }
        public DbSet<Product> Products { get; set; }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            //User Mapping
            modelBuilder.Entity<User>(entity =>
            {
                entity.ToTable("users");

                entity.HasKey(u => u.Id);

                entity.Property(u => u.Email).IsRequired().HasMaxLength(255);
                entity.Property(u => u.Password).IsRequired().HasMaxLength(255);
                entity.Property(u => u.Name).HasMaxLength(255);
                entity.Property(u => u.Role).HasConversion<string>();
                entity.Property(u => u.IsLocked).HasDefaultValue("no");
                entity.Property(u => u.IsDeleted).HasDefaultValue(false);
            });

            //Product Mapping
            modelBuilder.Entity<Product>(entity =>
            {
                entity.ToTable("products");
                entity.HasKey(p => p.Id);
                entity.Property(p => p.Name).IsRequired().HasMaxLength(255);
                entity.Property(p => p.Description).HasColumnType("text");
                entity.Property(p => p.Specification).HasColumnType("text");
                entity.Property(p => p.PurchaseCount).HasDefaultValue(0);
                entity.Property(p => p.IsDeleted).HasDefaultValue(false);

                //entity.HasOne(p => p.Category)
                //      .WithMany(c => c.Products)
                //      .HasForeignKey(p => p.CategoryId)
                //      .OnDelete(DeleteBehavior.Restrict);

                //entity.HasOne(p => p.Brand)
                //      .WithMany(b => b.Products)
                //      .HasForeignKey(p => p.BrandId)
                //      .OnDelete(DeleteBehavior.Restrict);
            });

        }
    }
}
