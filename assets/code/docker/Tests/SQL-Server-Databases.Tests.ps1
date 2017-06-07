
param(
    [Parameter(Mandatory=$true)][string]$Server,
    [Parameter(Mandatory=$true)][string]$InstanceLabel,
    [Parameter(Mandatory=$true)][string]$Username,
    [Parameter(Mandatory=$true)][string]$Password
)

try{
    Add-Type -Path 'C:\Program Files\Microsoft SQL Server\130\SDK\Assemblies\Microsoft.SqlServer.Smo.dll'

    Describe -Tag $InstanceLabel ("SQL Server Database tests on " + $InstanceLabel + " via the " + $Username + " account.") {
        Context "Databases" {    
            BeforeAll {
                $srv = New-Object Microsoft.SQLServer.Management.SMO.Server $Server
                $srv.ConnectionContext.ConnectTimeout = 5 # so we dont have to wait
                $srv.ConnectionContext.LoginSecure = $false # Mixed mode
                $srv.ConnectionContext.Login = $Username
                $srv.ConnectionContext.Password = $Password 
                $DefaultCollation = $srv.Collation
            }  
            foreach ($Database in $srv.Databases) {
                if($Database.IsDatabaseSnapshot -ne $true) {
                    It "Database $Database should be online" {
                        $Database.Status | Should Be "Normal"
                    }
                }
                It "Database $Database should have auto close off" {
                    $Database.AutoClose | Should Be $false
                }                
                It "Database $Database should have auto shrink off" {
                    $Database.AutoShrink | Should Be $false
                }
                It "Database $Database should have auto create statistics on" {
                    $Database.AutoCreateStatisticsEnabled | Should Be $true
                }
                It "Database $Database should have page verify set to checksum" {
                    $Database.PageVerify | Should Be "Checksum"
                }                
                if ($Database.Name -ne "msdb") {
                    It "Database $Database should have trustworthy off" {
                        $Database.Trustworthy | Should Be $false
                    }
                } 
                if ($Database.Name -NotIn ("SSISDB","ReportServer","ReportServerTempDB")) {
                    It "Database $Database should have the default collation" {
                        $Database.Collation | Should BeExactly $DefaultCollation
                    }
                }
            }              
        }    
    }
}
catch{
    Write-Error ("Failed to connect to database: " + $_)
    Exit
}
