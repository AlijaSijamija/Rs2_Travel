using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;
using TravelDodatni.Database;
using System.Text;
using TravelDodatni.Dtos.User;
using TravelDodatni.Services;

static TokenValidationParameters GetTokenValidationParameters(IConfiguration configuration)
{
    var param = new TokenValidationParameters
    {
        ValidateIssuerSigningKey = true,
        ValidateIssuer = true,
        ValidateAudience = false,
        ValidateLifetime = true,
        ClockSkew = TimeSpan.Zero,
        ValidIssuer = configuration["JWTSettings:Issuer"],
        ValidAudience = configuration["JWTSettings:Audience"],
        IssuerSigningKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(configuration["JWTSettings:Key"]))
    };
    Console.WriteLine("JWT Key used: " + configuration["JWTSettings:Key"]);
    return param;

}

var builder = WebApplication.CreateBuilder(args);
builder.Services.AddTransient<INotificationService, NotificationService>();
// Add services to the container.

builder.Services.AddControllers();
// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();
builder.Services.AddAutoMapper(typeof(INotificationService));
var connectionString = builder.Configuration.GetConnectionString("DefaultConnection");
builder.Services.AddDbContext<AppDbContext>(options =>
    options.UseSqlServer(connectionString));

builder.Services.Configure<JWTSettings>(builder.Configuration.GetSection("JWTSettings"));
builder.Services.AddAuthentication(options =>
{
    options.DefaultScheme = JwtBearerDefaults.AuthenticationScheme;
    options.DefaultAuthenticateScheme = JwtBearerDefaults.AuthenticationScheme;
    options.DefaultChallengeScheme = JwtBearerDefaults.AuthenticationScheme;
})
           .AddJwtBearer(o =>
           {
               o.RequireHttpsMetadata = false;
               o.SaveToken = false;
               o.TokenValidationParameters = GetTokenValidationParameters(builder.Configuration);
               o.Events = new JwtBearerEvents
               {
                   OnAuthenticationFailed = context =>
                   {
                       Console.WriteLine("❌ AUTH FAILED: " + context.Exception?.Message);
                       return Task.CompletedTask;
                   },
                   OnTokenValidated = context =>
                   {
                       Console.WriteLine("✅ TOKEN VALIDATED");
                       return Task.CompletedTask;
                   },
                   OnChallenge = context =>
                   {
                       Console.WriteLine($"❗ CHALLENGE: {context.ErrorDescription}");
                       return Task.CompletedTask;
                   }
               };

           });
builder.Services.AddAuthorization();
var app = builder.Build();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseHttpsRedirection();
app.UseAuthentication();
app.UseAuthorization();

app.MapControllers();

app.Run();
