using Microsoft.AspNetCore.Connections;
using Microsoft.EntityFrameworkCore;
using Travel.Configuration;
using Travel.Services.Database;
using Travel.Services.Interfaces;
using Travel.Services.Services;
using RabbitMQ.Client;
using RabbitMQ.Client.Events;
using System.Text;
using System.Text.Json;
using Travel.Models.Notification;
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
builder.Services.AddTransient<ITripTicketService, TripTicketService>();
builder.Services.AddTransient<IPaymentService, PaymentService>();
builder.Services.AddTransient<IRecomenderService, RecomenderService>();
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

string hostname = Environment.GetEnvironmentVariable("RABBITMQ_HOST") ?? "rabbitMQ";
string username = Environment.GetEnvironmentVariable("RABBITMQ_USERNAME") ?? "guest";
string password = Environment.GetEnvironmentVariable("RABBITMQ_PASSWORD") ?? "guest";
string virtualHost = Environment.GetEnvironmentVariable("RABBITMQ_VIRTUALHOST") ?? "/";



////////////////////////////////////////////////////////////////////////////////////


//var factory = new ConnectionFactory
//{
//    HostName = hostname,
//    UserName = username,
//    Password = password,
//    VirtualHost = virtualHost,
//};
//using var connection = factory.CreateConnection();
//using var channel = connection.CreateModel();

//channel.QueueDeclare(queue: "notifications",
//                     durable: false,
//                     exclusive: false,
//                     autoDelete: true,
//                     arguments: null);

//Console.WriteLine(" [*] Waiting for messages.");

//var consumer = new EventingBasicConsumer(channel);
//consumer.Received += async (model, ea) =>
//{
//    var body = ea.Body.ToArray();
//    var message = Encoding.UTF8.GetString(body);
//    Console.WriteLine(message.ToString());
//    var notification = JsonSerializer.Deserialize<List<Travel.Models.Notification.Notification>>(message);
//    using (var scope = app.Services.CreateScope())
//    {
//        var notificationService = scope.ServiceProvider.GetRequiredService<INotificationService>();

//        if (notification != null)
//        {
//            try
//            {
//                Console.WriteLine("Insert  notification finished");
//            }
//            catch (Exception e)
//            {

//            }
//        }
//    }
//    // Console.WriteLine();
//    Console.WriteLine(Environment.GetEnvironmentVariable("Some"));
//    Console.WriteLine("Insert  notification finished");
//};
//channel.BasicConsume(queue: "notifications",
//                     autoAck: true,
//                     consumer: consumer);

app.Run();
