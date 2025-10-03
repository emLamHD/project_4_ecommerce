using Ecom.Domain.Exceptions;
using Microsoft.EntityFrameworkCore;
using System;

namespace Ecom.Domain.Exceptions
{
    public class UserNotFoundException : Exception
    {
        public UserNotFoundException() : base("Không tìm thấy người dùng.")
        {
        }

        public UserNotFoundException(string message) : base(message)
        {
        }

        public UserNotFoundException(string message, Exception innerException)
            : base(message, innerException)
        {
        }
    }
}