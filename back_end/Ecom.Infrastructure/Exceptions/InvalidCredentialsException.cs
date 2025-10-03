using Ecom.Domain.Exceptions;
using Microsoft.EntityFrameworkCore;
using System;

namespace Ecom.Domain.Exceptions
{
    public class InvalidCredentialsException : Exception
    {
        public InvalidCredentialsException() : base("Thông tin đăng nhập không hợp lệ.")
        {
        }

        public InvalidCredentialsException(string message) : base(message)
        {
        }

        public InvalidCredentialsException(string message, Exception innerException)
            : base(message, innerException)
        {
        }
    }
}