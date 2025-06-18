using Microsoft.EntityFrameworkCore;
using Travel.Configuration;
using Travel.Services.Database;
using Travel.Services.Interfaces;
using Travel.Services.Services;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.
builder.Services.AddTransient<ICityService, CityService>();
builder.Services.AddTransient<INotificationService, NotificationService>();
builder.Services.AddTransient<ISectionService, SectionService>();
builder.Services.AddTransient<IAgencyService, AgencyService>();
builder.Services.AddTransient<IRouteService, RouteService>();
builder.Services.AddTransient<ITripServiceService, TripServiceService>();
builder.Services.AddTransient<IOrganizedTripService, OrganizedTripService>();
builder.Services.AddTransient<IRouteTicketService, RouteTicketService>();
builder.Services.AddControllers();
// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();
builder.Services.AddEFCoreInfrastructure(builder.Configuration);
builder.Services.AddIdentityInfrastructure(builder.Configuration);
builder.Services.AddSwaggerConfiguration();
builder.Services.AddAutoMapper(typeof(IAccountService));
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

using (var scope = app.Services.CreateScope())
{
    var dataContext = scope.ServiceProvider.GetRequiredService<AppDbContext>();
    var conn = dataContext.Database.GetConnectionString();
    dataContext.Database.Migrate();
}

app.SeedData();

app.Run();
