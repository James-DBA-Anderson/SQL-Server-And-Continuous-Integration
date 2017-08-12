
docker images

docker run -e ACCEPT_EULA=Y -e SA_PASSWORD=P455word1 -p 6666:1433  -d microsoft/mssql-server-windows

docker ps

docker stop @ID

docker start @ID

docker run -e ACCEPT_EULA=Y -e SA_PASSWORD=P455word1 -p 6665:1433 -rm -d microsoft/mssql-server-windows

docker stop @ID1 @ID

docker ps

docker ps -a

docker rm @ID1 @ID2

