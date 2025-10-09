using System.ComponentModel.DataAnnotations;

namespace back_end.API.DTOs
{
    public class RegisterRequest
    {
        [Required, EmailAddress, MaxLength(255)]
        public string Email { get; set; }

        [Required, MinLength(6), MaxLength(255)]
        public string Password { get; set; }

        [Required, MaxLength(255)]
        public string Name { get; set; }

        [MaxLength(50)]
        public string Phone { get; set; }

        [MaxLength(20)]
        public string Role { get; set; } = "user";
    }
}
