cls

docker images

docker run -d --rm --name 2017 -p 1433:1433 -e sa_password=P455W0rd1 -e ACCEPT_EULA=Y microsoft/mssql-server-windows-developer

docker ps

docker run -d --rm --name 2016sp1 -p 1000:1433 -e sa_password=P455W0rd1 -e ACCEPT_EULA=Y microsoft/mssql-server-windows-developer:2016-sp1

docker ps

docker stop 2017 2016sp1



