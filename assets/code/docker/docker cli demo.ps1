
docker images

docker run -d -rm -p 1433:1433 -e sa_password=P455W0rd1 -e ACCEPT_EULA=Y microsoft/mssql-server-windows-developer

docker ps

docker run -d -rm -p 1433:1433 -e sa_password=P455W0rd1 -e ACCEPT_EULA=Y microsoft/mssql-server-windows-developer:2016-sp1

docker ps

docker stop @ID



