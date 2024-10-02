// See https://aka.ms/new-console-template for more information
using EasyNetQ;
using VirtualGardens.Models.Messages;
using VirtualGardens.Subscriber.EmailService;

string envFilePath = Path.Combine(Directory.GetParent(Directory.GetCurrentDirectory()).FullName, "config", ".env");
DotNetEnv.Env.Load(envFilePath);

Console.WriteLine("Hello, World!");

string smtpHost = Environment.GetEnvironmentVariable("SMTP_HOST") ?? string.Empty;
int smtpPort = int.TryParse(Environment.GetEnvironmentVariable("SMTP_PORT"), out var port) ? port : 0;
string smtpUser = Environment.GetEnvironmentVariable("SMTP_USER") ?? string.Empty;
string smtpPass = Environment.GetEnvironmentVariable("SMTP_PASS") ?? string.Empty;

var emailService = new EmailService(smtpHost, smtpPort, smtpUser, smtpPass);
var bus = RabbitHutch.CreateBus("host=localhost:5673");


bus.PubSub.Subscribe<PonudaActivated>("seminarski",async msg =>
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
                            <p>Poštovani {msg.korisnik.Ime} {msg.korisnik.Prezime},</p>
                            <p>Želimo vas obavijestiti o našoj najnovijoj ponudi:</p>
    
                            <div class='offer'>
                                <h2>{msg.ponuda.Naziv}</h2>
                                <p>Popust: {msg.ponuda.Popust}%</p>
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
            await emailService.SendEmailAsync(msg.korisnik.Email, "Nova ponuda u VirtualGardens prodajnom mjestu!", emailBody);
        }
        catch (Exception ex)
        {
            // Log the exception or handle it accordingly
            Console.WriteLine($"Failed to send email: {ex.Message}");
        }

});

Console.WriteLine("Listening for messages, press <return> key to close!");
Console.ReadLine();