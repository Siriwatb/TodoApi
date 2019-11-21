FROM mcr.microsoft.com/dotnet/core/aspnet:3.0 AS base
WORKDIR /app
EXPOSE 80

FROM mcr.microsoft.com/dotnet/core/sdk:3.0 AS build
WORKDIR /src
COPY ["TodoApi.csproj", "./"]
RUN dotnet restore "./TodoApi.csproj"
COPY . .

RUN dotnet build "TodoApi.csproj" -c Release -o /app/build
FROM build AS publishs
RUN dotnet publish "TodoApi.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "TodoApi.dll"]
