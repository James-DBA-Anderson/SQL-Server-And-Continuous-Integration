cls

for($i=1; $i -le 5; $i++) {
    docker run -d --rm -e sa_password=P455W0rd1 -e ACCEPT_EULA=Y microsoft/mssql-server-windows-developer
}