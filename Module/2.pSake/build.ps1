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
Invoke-psake -buildFile Cool.build.ps1

Invoke-psake -buildFile Cooler.build.ps1 -docs
