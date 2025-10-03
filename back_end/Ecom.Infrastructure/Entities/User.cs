using System;
using Ecom.Domain.Enums;

namespace Ecom.Domain.Entities
{
    public class User
    {
        public int Id { get; set; }
        public string Email { get; set; }
        public string Password { get; set; }
        public string Name { get; set; }

        public UserRole Role { get; set; }

        public string Avatar { get; set; }
        public string Phone { get; set; }

        public LockStatus IsLocked { get; set; }
        public bool IsDeleted { get; set; }

        public DateTime? DeletedAt { get; set; }
        public DateTime CreatedAt { get; set; }
        public DateTime UpdatedAt { get; set; }

        public int? CreatedBy { get; set; }
        public int? UpdatedBy { get; set; }
    }
}
