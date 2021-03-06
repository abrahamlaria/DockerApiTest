#Get base SDK image from Microsoft
FROM mcr.microsoft.com/dotnet/sdk:3.1 AS build-env
WORKDIR /app

#Copy the .csproj file and restore any dependencies (via NUGET)
COPY *.csproj ./
RUN dotnet restore

#Copy the project files and build our release
COPY . ./
RUN dotnet publish -c Release -o out

#Generate runtime image
FROM mcr.microsoft.com/dotnet/aspnet:3.1
WORKDIR /app
EXPOSE 80
COPY --from=build-env /app/out .
ENTRYPOINT ["dotnet", "DockerAPI.dll"]