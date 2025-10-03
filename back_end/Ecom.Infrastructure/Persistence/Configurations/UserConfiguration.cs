using Microsoft.EntityFrameworkCore; 
using Microsoft.EntityFrameworkCore.Metadata.Builders; 
using Ecom.Domain.Entities;
using Ecom.Domain.Enums;

namespace Ecom.Infrastructure.Persistence.Configurations
{
    public class UserConfiguration : IEntityTypeConfiguration<User>
    {
        public void Configure(EntityTypeBuilder<User> builder)
        {
            builder.ToTable("users");

            builder.HasKey(u => u.Id);
            builder.Property(u => u.Id).HasColumnName("id");

            builder.HasIndex(u => u.Email).IsUnique();
            builder.Property(u => u.Email).HasColumnName("email").HasColumnType("varchar").HasMaxLength(255);

            builder.Property(u => u.Password).IsRequired().HasColumnName("password").HasColumnType("varchar").HasMaxLength(255);
            builder.Property(u => u.Name).IsRequired().HasColumnName("name").HasColumnType("varchar").HasMaxLength(255);
            builder.Property(u => u.CreatedAt).IsRequired().HasColumnName("created_at");
            builder.Property(u => u.UpdatedAt).IsRequired().HasColumnName("updated_at");

            builder.Property(u => u.Avatar).HasColumnName("avatar").HasColumnType("varchar").HasMaxLength(255).IsRequired(false);
            builder.Property(u => u.Phone).HasColumnName("phone").HasColumnType("varchar").HasMaxLength(20).IsRequired(false);
            builder.Property(u => u.DeletedAt).HasColumnName("deleted_at").IsRequired(false);
            builder.Property(u => u.CreatedBy).HasColumnName("created_by").IsRequired(false);
            builder.Property(u => u.UpdatedBy).HasColumnName("updated_by").IsRequired(false);

            builder.Property(u => u.Role)
                   .HasColumnName("role")
                   .HasConversion<string>(); 

            builder.Property(u => u.IsLocked)
                   .HasColumnName("is_locked")
                   .HasConversion<string>(); 

            builder.Property(u => u.IsDeleted)
                   .HasColumnName("is_deleted");
        }
    }
}
