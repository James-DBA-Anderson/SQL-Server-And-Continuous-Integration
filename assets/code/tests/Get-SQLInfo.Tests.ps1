cls

$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"

Describe "Get-SQLInfo" {
    It "returns $true when `$a = 1" {
        Get-SQLInfo 1 | Should Be $true
    }
}








<#



    It "returns $false when `$a = 0" {
        Get-SQLInfo 0 | Should Be $false
    }
    It "returns $false when `$a not provided" {
        Get-SQLInfo | Should Be $false
    }
#>