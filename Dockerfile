FROM microsoft/aspnetcore:2.0 AS base
WORKDIR /app
EXPOSE 80

FROM microsoft/aspnetcore-build:2.0 AS build
WORKDIR /src
COPY ["www/www.csproj", "www/"]
RUN dotnet restore "www/www.csproj"
COPY . .
WORKDIR "/src/www"
RUN dotnet build "www.csproj" -c Release -o /app

FROM build AS publish
RUN dotnet publish "www.csproj" -c Release -o /app

FROM base AS final
WORKDIR /app
COPY --from=publish /app .
ENTRYPOINT ["dotnet", "www.dll"]