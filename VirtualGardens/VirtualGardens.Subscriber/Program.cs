// See https://aka.ms/new-console-template for more information
using EasyNetQ;
using EasyNetQ.DI;
using System.Net.Sockets;
using VirtualGardens.Models.Messages;
using VirtualGardens.Subscriber;
using VirtualGardens.Subscriber.EmailService;


DotNetEnv.Env.Load();

Console.WriteLine("Hello, World!");

string rabbitmqport = Environment.GetEnvironmentVariable("RABBIT_MQ_PORT") ?? string.Empty;
string rabbitmqhost = Environment.GetEnvironmentVariable("RABBIT_MQ_HOST") ?? string.Empty;
Console.WriteLine($"{rabbitmqport}");
await WaitForRabbitMQAsync($"{rabbitmqhost}", int.TryParse(rabbitmqport, out var result) ? result : 0);

string smtpHost = Environment.GetEnvironmentVariable("SMTP_HOST") ?? string.Empty;
int smtpPort = int.TryParse(Environment.GetEnvironmentVariable("SMTP_PORT"), out var port) ? port : 0;
string smtpUser = Environment.GetEnvironmentVariable("SMTP_USER") ?? string.Empty;
string smtpPass = Environment.GetEnvironmentVariable("SMTP_PASS") ?? string.Empty;

string rabbitmq = Environment.GetEnvironmentVariable("RABBIT_MQ") ?? string.Empty;

var emailService = new EmailService(smtpHost, smtpPort, smtpUser, smtpPass);
var bus = RabbitHutch.CreateBus(rabbitmq);
Console.WriteLine($"{rabbitmq}");


bus.PubSub.Subscribe<VirtualGardens.Models.Messages.PonudaActivated>(string.Empty,async msg =>
{

        string emailBody = $@"
                        <!DOCTYPE html>
                        <html lang='bs'>
                        <head>
                            <meta charset='UTF-8'>
                            <meta name='viewport' content='width=device-width, initial-scale=1.0'>
                            <title>Ponuda u našoj poslovnici - Virtual Gardens</title>
                            <style>
                                body {{
                                    font-family: Arial, sans-serif;
                                    background-color: #f4f4f4;
                                    margin: 0;
                                    padding: 20px;
                                }}
                                .container {{
                                    background-color: #fff;
                                    border-radius: 5px;
                                    padding: 20px;
                                    box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
                                }}
                                h1 {{
                                    color: #333;
                                }}
                                p {{
                                    color: #555;
                                }}
                                .offer {{
                                    background-color: #e0ffe0;
                                    border: 1px solid #4CAF50;
                                    padding: 10px;
                                    border-radius: 5px;
                                }}
                                .footer {{
                                    margin-top: 20px;
                                    font-size: 12px;
                                    color: #888;
                                }}
                            </style>
                        </head>
                        <body>

                        <div class='container'>
                            <h1>Nova Ponuda!</h1>
                            <p>Poštovani {msg.ime} {msg.prezime},</p>
                            <p>Želimo vas obavijestiti o našoj najnovijoj ponudi:</p>
    
                            <div class='offer'>
                                <h2>{msg.nazivPonude}</h2>
                                <p>Popust: {msg.popust}%</p>
                            </div>
    
                            <p>Iskoristite ovu sjajnu priliku i posjetite nas!</p>
                            <p>Hvala što ste dio naše zajednice.</p>
    
                            <p>S poštovanjem,<br>
                            Vaš VirtualGardens tim</p>
    
                            <div class='footer'>
                                <p>Ovaj email je poslan automatski. Molimo vas da ne odgovarate na njega.</p>
                            </div>
                        </div>

                        </body>
                        </html>";

        try
        {
            await emailService.SendEmailAsync(msg.email, "Nova ponuda u VirtualGardens prodajnom mjestu!", emailBody);
        }
        catch (Exception ex)
        {
            Console.WriteLine($"Failed to send email: {ex.Message}");
        }

});

Console.WriteLine("Listening for messages, press <return> key to close!");
Thread.Sleep(Timeout.Infinite);
Console.ReadLine();

async Task WaitForRabbitMQAsync(string host, int port, int maxRetries = 10, int delayMilliseconds = 2000)
{
    for (int i = 0; i < maxRetries; i++)
    {
        try
        {
            using (var client = new TcpClient())
            {
                await client.ConnectAsync(host, port);
                Console.WriteLine("RabbitMQ is up and running!");
                return; 
            }
        }
        catch (SocketException)
        {
            Console.WriteLine($"RabbitMQ is not available yet. Retrying in {delayMilliseconds / 1000} seconds...");
            await Task.Delay(delayMilliseconds);
        }
    }

    Console.WriteLine("Failed to connect to RabbitMQ after several attempts.");
    Environment.Exit(1);
}