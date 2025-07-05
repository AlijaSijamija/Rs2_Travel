using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using RabbitMQ.Client;
using System.Text;
using TravelDodatni.Services;
using System.Text;
using Newtonsoft.Json;
namespace TravelDodatni.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class NotificationController : ControllerBase
    {
        private INotificationService _notificationService;
        public NotificationController(INotificationService notificationService)
        {
            _notificationService = notificationService;
        }

        [HttpGet]
        public virtual async Task<List<Dtos.Notification.Notification>> Get()
        {
            var result = await _notificationService.Get();
            var factory = new ConnectionFactory
            {
                HostName = Environment.GetEnvironmentVariable("RABBITMQ_HOST") ?? "localhost"
            };
            using var connection = factory.CreateConnection();
            using var channel = connection.CreateModel();

            channel.QueueDeclare(queue: "notifications",
                                 durable: false,
                                 exclusive: false,
                                 autoDelete: true,
                                 arguments: null);


            var json = JsonConvert.SerializeObject(result);

            var body = Encoding.UTF8.GetBytes(json);

            Console.WriteLine($"Sending notifications: {json}");

            channel.BasicPublish(exchange: string.Empty,
                                 routingKey: "notifications",

                                 body: body);
            return result;
        }
    }
}
