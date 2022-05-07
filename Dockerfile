FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 5041

ENV ASPNETCORE_URLS=http://+:5041

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY ["MyFirstMvc/MyFirstMvc.csproj", "MyFirstMvc/"]
RUN dotnet restore "MyFirstMvc\MyFirstMvc.csproj"
COPY . .
WORKDIR "/src/MyFirstMvc"
RUN dotnet build "MyFirstMvc.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "MyFirstMvc.csproj" -c Release -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "MyFirstMvc.dll"]
