using back_end.Controllers;
using Ecom.Application.DTOs.Auth;
using Ecom.Application.Features.Auth.Commands;
using Ecom.Application.Features.Auth.Queries;
using MediatR;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace back_end.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class AccountsController : ControllerBase
    {
        private readonly IMediator _mediator;

        public AccountsController(IMediator mediator)
        {
            _mediator = mediator;
        }
        [HttpPost("register")]
        [ProducesResponseType(typeof(AuthResultDto), StatusCodes.Status200OK)]
        public async Task<IActionResult> Register([FromBody] RegisterUserCommand command)
        {
            var result = await _mediator.Send(command);
            return Ok(result);
        }
        [HttpPost("login")]
        [ProducesResponseType(typeof(AuthResultDto), StatusCodes.Status200OK)]
        public async Task<IActionResult> Login([FromBody] LoginUserCommand command)
        {
            var result = await _mediator.Send(command);
            return Ok(result);
        }
        [Authorize]
        [HttpGet("profile")]
        [ProducesResponseType(typeof(AuthResultDto), StatusCodes.Status200OK)]
        public async Task<IActionResult> GetProfile()
        {
            var result = await _mediator.Send(new GetCurrentUserQuery());
            return Ok(result);
        }
    }
}