namespace back_end.Core.Entities
{
    public class Address
    {
            public int Id { get; set; }
            public int UserId { get; set; }
            public string Name { get; set; }
            public string AddressLine { get; set; }
            public string City { get; set; }
            public string State { get; set; }
            public string Country { get; set; }
            public string PostalCode { get; set; }
            public string Phone { get; set; }
            public string IsDefault { get; set; }
            public DateTime CreatedAt { get; set; }
            public DateTime UpdatedAt { get; set; }
            public User User { get; set; }
    }
}
