using Microsoft.Extensions.Configuration;
using Stripe;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.InteropServices;
using System.Text;
using System.Threading.Tasks;
using Travel.Models.Payment;
using Travel.Services.Interfaces;

namespace Travel.Services.Services
{
    public class PaymentService : IPaymentService
    {
        private readonly IConfiguration _configuration;
        public PaymentService(IConfiguration configuration)
        {
                _configuration = configuration;
        }
        public async Task<bool> Pay(PaymentTicket model)
        {
            try
            {
                StripeConfiguration.ApiKey = _configuration["Stripe:SecretKey"];
                var optionsToken = new TokenCreateOptions
                {
                    Card = new TokenCardOptions
                    {
                        Number = model.CardNumber,
                        ExpMonth = model.Month,
                        ExpYear = model.Year,
                        Cvc = model.Cvc,
                        Name = model.CardHolderName
                    }
                };
                ////var serviceToken = new Stripe.TokenService();
                ////Token stripeToken = await serviceToken.CreateAsync(optionsToken);
                var options = new ChargeCreateOptions
                {
                    Amount = (model.TotalPrice * 100),
                    Currency = "bam",
                    Description = "Ticket",
                    Source = "tok_mastercard"
                };
                var service = new ChargeService();
                Charge charge = await service.CreateAsync(options);
                if (charge.Paid)
                {

                    return true;
                }
                else
                    return false;

            }
            catch (Exception ex)
            {

                throw ex;
            }

        }
    }
}
