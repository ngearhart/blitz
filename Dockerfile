#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM node:16 AS frontend

WORKDIR /frontend
COPY ./frontend/*.json .
RUN yarn
COPY ./frontend .
ENV NUXT_HOST=0.0.0.0
RUN yarn build
CMD ["yarn", "start"]

FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 80

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY ["blitz.csproj", "."]
RUN dotnet restore "./blitz.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "blitz.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "blitz.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "blitz.dll"]
