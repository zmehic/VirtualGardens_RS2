using Mapster;
using Microsoft.AspNetCore.Authentication;
using Microsoft.EntityFrameworkCore;
using Microsoft.OpenApi.Models;
using VirtualGardens.API;
using VirtualGardens.API.Filters;
using VirtualGardens.Services;
using VirtualGardens.Services.AllServices;
using VirtualGardens.Services.AllServices.JediniceMjere;
using VirtualGardens.Services.AllServices.KorisniciUloge;
using VirtualGardens.Services.AllServices.Nalozi;
using VirtualGardens.Services.AllServices.Narudzbe;
using VirtualGardens.Services.AllServices.PitanjaOdgovori;
using VirtualGardens.Services.AllServices.Ponude;
using VirtualGardens.Services.AllServices.ProizvodiNoImage;
using VirtualGardens.Services.AllServices.ProizvodiSetovi;
using VirtualGardens.Services.AllServices.Recenzije;
using VirtualGardens.Services.AllServices.Setovi;
using VirtualGardens.Services.AllServices.SetoviPonude;
using VirtualGardens.Services.AllServices.Ulazi;
using VirtualGardens.Services.AllServices.UlaziProizvodi;
using VirtualGardens.Services.AllServices.Uloge;
using VirtualGardens.Services.AllServices.VrsteProizvoda;
using VirtualGardens.Services.AllServices.Zaposlenici;
using VirtualGardens.Services.Auth;
using VirtualGardens.Services.Database;
using VirtualGardens.Services.NarudzbeStateMachine;
using VirtualGardens.Services.PonudeStateMachine;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.

builder.Services.AddTransient<IProizvodiService, ProizvodiService>();
builder.Services.AddTransient<IKorisniciService, KorisniciService>();
builder.Services.AddTransient<IJediniceMjereService, JediniceMjereService>();
builder.Services.AddTransient<IUlogeService, UlogeService>();
builder.Services.AddTransient<IZaposleniciService, ZaposleniciService>();
builder.Services.AddTransient<INaloziService, NaloziService>();
builder.Services.AddTransient<IVrsteProizvodaService, VrsteProizvodaService>();
builder.Services.AddTransient<IUlaziService,UlaziService>();
builder.Services.AddTransient<IUlaziProizvodiService, UlaziProizvodiService>();
builder.Services.AddTransient<IKorisniciUlogeService, KorisniciUlogeService>();
builder.Services.AddTransient<INarudzbeService, NarudzbeService>();
builder.Services.AddTransient<IPitanjaOdgovoriService,PitanjaOdgovoriService>();
builder.Services.AddTransient<ISetoviService, SetoviService>();
builder.Services.AddTransient<IPonudeService, PonudeService>(); 
builder.Services.AddTransient<IProizvodiSetoviService, ProizvodiSetoviService>();
builder.Services.AddTransient<IRecenzijeService, RecenzijeService>();
builder.Services.AddTransient<ISetoviPonudeService,SetoviPonudeService>();
builder.Services.AddTransient<IProizvodiNoImageService, ProizvodiNoImageService>();

builder.Services.AddTransient<BaseNarudzbaState>();
builder.Services.AddTransient<InitialNarudzbaState>();
builder.Services.AddTransient<CreatedNarudzbaState>();
builder.Services.AddTransient<InProgressNarudzbaState>();
builder.Services.AddTransient<FinishedNarudzbaState>();

builder.Services.AddTransient<BasePonudaState>();
builder.Services.AddTransient<InitialPonudaState>();
builder.Services.AddTransient<CreatedPonudaState>();
builder.Services.AddTransient<ActivePonudaState>();
builder.Services.AddTransient<FinishedPonudaState>();

builder.Services.AddScoped<IPasswordService, PasswordService>();

builder.Services.AddControllers(x =>
{
    x.Filters.Add<ExceptionFilter>();
});
// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen(c =>
{
    c.AddSecurityDefinition("basicAuth", new Microsoft.OpenApi.Models.OpenApiSecurityScheme()
    {
        Type = Microsoft.OpenApi.Models.SecuritySchemeType.Http,
        Scheme = "basic"
    });

    c.AddSecurityRequirement(new Microsoft.OpenApi.Models.OpenApiSecurityRequirement()
    {
        {
            new OpenApiSecurityScheme
            {
                Reference = new OpenApiReference{Type = ReferenceType.SecurityScheme, Id = "basicAuth"}
            },
            new string[]{}
    } });

});

var connectionString = Environment.GetEnvironmentVariable("CONNECTION_STRING") ?? "Data Source=localhost,1401;Database=210011;User=sa;Password=sQlZaIm123!;TrustServerCertificate=True";
builder.Services.AddDbContext<_210011Context>(options => options.UseSqlServer(connectionString));
builder.Services.AddMapster();
builder.Services.AddAuthentication("BasicAuthentication").AddScheme<AuthenticationSchemeOptions, BasicAuthenticationHandler>("BasicAuthentication",null);

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

using (var scope = app.Services.CreateScope())
{
    var dataContext = scope.ServiceProvider.GetRequiredService<_210011Context>();

    dataContext.Database.Migrate();
}

app.Run();
