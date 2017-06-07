
param(
    [Parameter(Mandatory=$true)][string]$Server,
    [Parameter(Mandatory=$true)][string]$InstanceLabel,
    [Parameter(Mandatory=$true)][string]$Username,
    [Parameter(Mandatory=$true)][string]$Password
)

try{
    Add-Type -Path 'C:\Program Files\Microsoft SQL Server\130\SDK\Assemblies\Microsoft.SqlServer.Smo.dll'

    Describe -Tag $InstanceLabel ("SQL Server tests on " + $InstanceLabel + " via the " + $Username + " account.") {
        Context "SQL Service" {
            BeforeAll {
                 $srv = New-Object Microsoft.SQLServer.Management.SMO.Server $Server
                 $srv.ConnectionContext.ConnectTimeout = 5 # so we dont have to wait
                 $srv.ConnectionContext.LoginSecure = $false # Mixed mode
                 $srv.ConnectionContext.Login = $Username
                 $srv.ConnectionContext.Password = $Password 
            }
  
            It "Cost threshold for Parallelism should >= 5" {
                $srv.Configuration.CostThresholdForParallelism.RunValue | Should BeGreaterThan 4
            }
            It "Cost threshold for Parallelism should <= 50" {
                $srv.Configuration.CostThresholdForParallelism.RunValue | Should BeLessThan 51
            }
            It "XPCmdShell should be disabled" {
                $srv.Configuration.XPCmdShellEnabled.RunValue | Should Be 0
            }
            # Add checks for: 
            #  named pipes enabled
        }
        Context "Security" {
            foreach ($login in $srv.Logins) {
                if ($login.WindowsLoginAccessType -eq "NonNTLogin") {
                    It "NonNTLogin $login should not be locked" {
                        $login.IsLocked | Should Not Be $true
                    }
                    It "NonNTLogin $login should not have an expired password" {
                        $login.IsPasswordExpired | Should Not Be $true
                    }
                }
            }
            #Check sysadmins, roles, $user has the access it requires for the checks.
        }
        Context "Databases" {    
            BeforeAll {
                $DefaultCollation = $srv.Collation
            }  
            foreach ($Database in $srv.Databases) {
                if($Database.IsDatabaseSnapshot -ne $true) {
                    It "Database $Database should be online" {
                        $Database.Status | Should Be "Normal"
                    }
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
        Context "Agent Jobs" {
            It "syspolicy_purge_history should be enabled" {
                $srv.JobServer.Jobs.Where{$_.Name -eq 'syspolicy_purge_history' -and $_.IsEnabled -eq $true}.Count | Should Be 1
            }  
        }     
    }
}
catch{
    Write-Error ("Failed to connect to database: " + $_)
    Exit
}
