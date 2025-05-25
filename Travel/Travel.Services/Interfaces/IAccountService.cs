using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Travel.Models.Account;
using Travel.Models.Filters;
using Travel.Models.Token;

namespace Travel.Services.Interfaces
{
    public interface IAccountService : ICRUDService<Models.Account.UserResponse, BaseSearchObject, Models.Account.UserResponse, Models.Account.UserResponse, string>
    {
        public Task<UserResponse> Register(RegisterRequest request);
        public Task<UserResponse> Update(string userId, RegisterRequest request);
        public Task<PagedResult<UserResponse>> GetAll(UserSearchObject filter);
        public DashboardData GetDashboardData();
        public Task<AuthenticationResponse> Authenticate(string username, string password, string ipAddress);
        public Task<UserResponse> UpdateProfile(string userId, UserUpdateRequest request);
        public Task<UserResponse> UserProfile(string userId);
        public Task ChangePassword(string userId, ChangePasswordRequest request);
    }
}
