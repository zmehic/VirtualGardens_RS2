
// See https://aka.ms/new-console-template for more information
using EasyNetQ;
using VirtualGardens.Models.Messages;

Console.WriteLine("Hello, World!");

var bus = RabbitHutch.CreateBus("host=localhost:5673");

await bus.PubSub.SubscribeAsync<PonudaActivated>("seminarski", msg =>
{
    Console.WriteLine($"Ponuda aktivirana: {msg.ponuda.Naziv}");
});

Console.WriteLine("Listening for messages, press <return> key to close!");
Console.ReadLine();