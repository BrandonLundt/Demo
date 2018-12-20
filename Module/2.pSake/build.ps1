<#
    Start of exploring the module

#>
Get-Command -Module psake

Get-Help -Name Invoke-psake
Get-Help -Name task


<#
    End of exploring, let's do something cool.
#>
Push-Location -Path .\Module\2.pSake\
Invoke-psake -buildFile SomethingCool.ps1

Invoke-psake -buildFile BetterThanCool.ps1 -docs
