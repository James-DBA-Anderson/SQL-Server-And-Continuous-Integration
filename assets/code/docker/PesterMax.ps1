<#
.SYNOPSIS 
Deploys a ReadyRoll project to multiple containers and runs Pester tests against them.

.DESCRIPTION


.PARAMETER ProjectPath
The path of the solution file for the solution that contains the ReadyRoll project.

.PARAMETER TestPath
The path of the folder container the Pester scripts

.PARAMETER SQLServerVersions

.PARAMETER DegreeOfParallelisim

.NOTES 

.LINK


.EXAMPLE
Test-ReadyRollProject -ProjectPath 'C:\Projects\RR_Test\RR_Test.sqlproj' -TestPath 'C:\Projects\RR_Test\Tests' -SQLServerVersions 'CTP1.0' 'CTP1.2' 'CTP2.0' 'latest' -ContainerCountPerImage 2

This will deploy the RR_Test ReadyRoll project to four different versions of SQL Server. It will then spin up another containers for each version (making two containers per version) and split the Pester tests among them.
#>

Function Test-ReadyRollProject
{
    param(
        [parameter(Mandatory = $true)][string]$ProjectPath,        
        [parameter(Mandatory = $true)][string]$TestPath,
        [parameter(Mandatory = $false)][string[]]$SQLServerVersions = 'latest',
        [parameter(Mandatory = $false)][int]$DegreeOfParallelisim = 1
    )

    $TestFiles = Get-ChildItem $TestPath

    if($TestFiles.Count -lt $DegreeOfParallelisim) {
        $DegreeOfParallelisim = $TestFiles.Count
        Write-Output("Setting Degree of Parallelism to $DegreeOfParallelisim because that's the number of tests present in $TestPath.")        
    }

    #Include the Invoke-Parallel function.
    . "$PSScriptRoot/Invoke-Parallel/Invoke-Parallel/Invoke-Parallel.ps1"

    $VersionCount = $SQLServerVersions.Count
    $TotalContainerCount = $VersionCount * $DegreeOfParallelisim

    Write-Output("Spinning up $TotalContainerCount containers for $VersionCount different version(s) of SQL Server.")

    $SQLServerVersions | Invoke-Parallel -ImportFunctions -ImportVariables -ImportModules -Quiet {

        $TaggedImage = "microsoft/mssql-server-windows:$_"

        Write-Output("Spinning up $DegreeOfParallelisim $TaggedImage containers.")

        $i = (1..$DegreeOfParallelisim)

        $Containers = @()
            
        $Containers = $i | Invoke-Parallel -ImportFunctions -ImportVariables -Quiet {

            $ContainerID = docker run -d --rm -e SA_PASSWORD=P455word1 -e ACCEPT_EULA=Y $TaggedImage

            $ContainerIP = docker inspect --format '{{ .NetworkSettings.Networks.nat.IPAddress }}' $ContainerID

            $Container = @{Key = $ContainerID; Value = $ContainerIP}
                
            Write-Output($Container)

            #wait for SQL Server to come up
            $Started = $false
            do
            {
                $Logs = docker exec -it $ContainerID powershell "cd 'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\Log'; cat ERRORLOG"   
                if ($Logs -like "*Recovery is complete*")
                {
                    $Started = $true
                }
                else
                {
                    Start-sleep 2
                }
            }
            until($Started -eq $true)
                
        } # Invoke-Parallel    

        $Containers | Invoke-Parallel -ImportFunctions -ImportVariables -Quiet {
            
            $ContainerIP = $_.Value

            Write-Output("Deploying project to " + $ContainerIP)

            & "$ProjectPath\DeployPackageWrapper.ps1" "$ContainerIP" 'RR_Test' '\var\opt\mssql\data' '\var\opt\mssql\data' '\var\opt\mssql\backup' '140' $FALSE | Out-Null
        }

        Write-Output("Running tests in $TestPath")

        # Declare a hash table array to store the test to IP assignments.
        $TestAssignments = @()

        $x = 0

        $TestAssignments = foreach ($TestFile in $TestFiles) {

            Write-Output(@{Key = $Containers[$x].Key; IP = $Containers[$x].Value; TestFile = $TestFile;})

            if($x -eq $Containers.count - 1) {$x = 0} else {$x += 1}
        }

        $TestAssignments | Invoke-Parallel -ImportFunctions -ImportVariables -ImportModules -Quiet {

            $ContainerID = $_.Key
            $IP = $_.IP
            $TestFileName = $_.TestFile
            $TestFile = $TestPath + "\" + $TestFileName

            Write-Output("Running test $TestFile against $IP")
            try {
                #sqlcmd -Q "SELECT name FROM sys.databases;" -S $IP -d "master" -U "sa" -P "P455word1" #-o "C:\Temp\Output\$IP.txt"

                Invoke-Pester -Script @{ Path = $TestFile; Parameters = @{ Server = $IP; InstanceLabel = $IP; Username = 'sa'; Password = 'P455word1' };} -PassThru -Tag $IP -Show Summary -OutputFile "C:\Temp\Output\$TestFileName results for $IP.txt" -OutputFormat NUnitXML
            }
            catch {
                Write-Error ("Failed to invoke Pester on $ContainerIP. " + $_)
            }
            finally {
                $a = docker stop $ContainerID 
            }
        } 

    } # Invoke-Parallel

} # Test-ReadyRollProject