﻿
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Travel.Models.Account;
using Travel.Models.Enums;
using Travel.Models.Filters;
using Travel.Services.Interfaces;


namespace Travel.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    [Produces("application/json")]
    public class AccountController : BaseCRUDController<Travel.Models.Account.UserResponse, Travel.Models.Filters.BaseSearchObject, Travel.Models.Account.UserResponse, Travel.Models.Account.UserResponse, string>
    {

        public AccountController(ILogger<BaseController<Travel.Models.Account.UserResponse, Travel.Models.Filters.BaseSearchObject, string>> logger, IAccountService service) : base(logger, service)
        {

        }

        [AllowAnonymous]
        [HttpPost("register")]
        public async Task<ActionResult<UserResponse>> Register([FromBody] RegisterRequest request)
        {
            var userResponse = await (_service as IAccountService).Register(new RegisterRequest
            {
                UserName = request.UserName,
                Password = request.Password,
                Email = request.Email,
                FirstName = request.FirstName,
                LastName = request.LastName,
                Gender = request.Gender,
                PhoneNumber = request.PhoneNumber,
                BirthDate = request.BirthDate,
                UserType = request.UserType,
                CityId = request.CityId,
            });

            return Ok(userResponse);
        }

        [AllowAnonymous]
        [HttpPost("authenticate")]
        [Consumes("application/json")]
        public async Task<ActionResult<AuthenticationResponse>> Authenticate([FromBody] AuthenticationRequest request)
        {
            return Ok(await (_service as IAccountService).Authenticate(request.Username, request.Password, string.Empty));
        }

        [Authorize(Roles = Roles.Admin)]
        [HttpPut("update-user/{userId}")]
        [Consumes("application/json")]
        public async Task<ActionResult<UserResponse>> UpdateUser([FromRoute] string userId, [FromBody] RegisterRequest request)
        {
            return Ok(await (_service as IAccountService).Update(userId, request));
        }

        [Authorize(Roles = Roles.Admin)]
        [HttpGet("get-all")]
        [Consumes("application/json")]
        public async Task<ActionResult<PagedResult<UserResponse>>> GetAll([FromQuery] UserSearchObject filter)
        {
            return Ok(await (_service as IAccountService).GetAll(filter));
        }

        [Authorize(Roles = Roles.Admin)]
        [HttpGet("dashboard-data")]
        [Consumes("application/json")]
        public ActionResult<PagedResult<UserResponse>> GetDashboardData()
        {
            return Ok((_service as IAccountService).GetDashboardData());
        }

        [Authorize]
        [HttpPut("update-profile/{userId}")]
        [Consumes("application/json")]
        public async Task<ActionResult<UserResponse>> UpdateProfile([FromRoute] string userId, [FromBody] UserUpdateRequest request)
        {
            return Ok(await (_service as IAccountService).UpdateProfile(userId, request));
        }

        [Authorize]
        [HttpGet("user-profile/{userId}")]
        [Consumes("application/json")]
        public async Task<ActionResult<UserResponse>> UserProfile([FromRoute] string userId)
        {
            return Ok(await (_service as IAccountService).UserProfile(userId));
        }

        [Authorize]
        [HttpPost("change-password/{userId}")]
        public async Task<ActionResult> ChangePassword([FromRoute] string userId, ChangePasswordRequest request)
        {

            await (_service as IAccountService).ChangePassword(userId, request);
            return Ok();
        }

        [Authorize]
        [HttpDelete("remove/{userId}")]
        public async Task<ActionResult> Remove([FromRoute] string userId)
        {

            await (_service as IAccountService).RemoveUser(userId);
            return Ok();
        }
    }
}
