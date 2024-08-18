using Mapster;
using Microsoft.EntityFrameworkCore;
using VirtualGardens.Services;
using VirtualGardens.Services.AllServices;
using VirtualGardens.Services.Auth;
using VirtualGardens.Services.Database;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.

builder.Services.AddTransient<IProizvodiService, ProizvodiService>();
builder.Services.AddTransient<IKorisniciService, KorisniciService>();

builder.Services.AddScoped<IPasswordService, PasswordService>();

builder.Services.AddControllers();
// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

var connectionString = builder.Configuration.GetConnectionString("DefaultConnection");
builder.Services.AddDbContext<_210011Context>(options => options.UseSqlServer(connectionString));
builder.Services.AddMapster();

var app = builder.Build();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseHttpsRedirection();

app.UseAuthorization();

app.MapControllers();

app.Run();
