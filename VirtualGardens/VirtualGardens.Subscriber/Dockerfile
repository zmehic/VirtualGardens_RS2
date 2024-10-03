FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
USER app
WORKDIR /app

COPY *.csproj ./
RUN dotnet restore

COPY . ./
RUN dotnet build "VirtualGardens.Subscriber.csproj" -c Release -o /app/build

FROM mcr.microsoft.com/dotnet/runtime:8.0 AS runtime
WORKDIR /app
COPY --from=build /app/build .

ENTRYPOINT ["dotnet", "VirtualGardens.Subscriber.dll"]