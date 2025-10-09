namespace back_end.Core.Entities
{
    public class User
    {
            public int Id { get; set; }
            public string Email { get; set; }
            public string Password { get; set; } // hashed
            public string Name { get; set; }
            public string Role { get; set; } // 'admin', 'user', 'seller'
            public string Avatar { get; set; }
            public string Phone { get; set; }
            public string IsLocked { get; set; } // 'yes', 'no'
            public DateTime? DeletedAt { get; set; }
            public bool IsDeleted { get; set; } // từ migration mới
            public DateTime CreatedAt { get; set; }
            public DateTime UpdatedAt { get; set; }
            public ICollection<Address> Addresses { get; set; } = new List<Address>();
    }
}
