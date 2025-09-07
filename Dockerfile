# Use the official .NET 9 SDK image for building
FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
WORKDIR /app

# Copy solution file and project structure
COPY *.sln ./
COPY src/intera.helloworld.app/*.csproj ./src/intera.helloworld.app/

# Restore dependencies using the specific project file
RUN dotnet restore src/intera.helloworld.app/intera.helloworld.app.csproj

# Copy the rest of the source code
COPY . ./

# Build and publish the application
RUN dotnet publish src/intera.helloworld.app/intera.helloworld.app.csproj -c Release -o /app/publish

# Use the official .NET 9 runtime image for the final stage
FROM mcr.microsoft.com/dotnet/aspnet:9.0
WORKDIR /app

# Copy the published application from the build stage
COPY --from=build /app/publish .

# Expose port 8080 (Azure App Service default)
EXPOSE 8080

# Set environment variable for Azure
ENV ASPNETCORE_URLS=http://+:8080

# Start the application
ENTRYPOINT ["dotnet", "intera.helloworld.app.dll"]