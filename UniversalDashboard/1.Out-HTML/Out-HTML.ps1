<#########################################
In the beginning, there was convertTo-HTML and it was meh.
##########################################>

$HTMLFile = Join-Path -Path $env:TEMP -ChildPath "ConvertTo-HTML.html"

<#Example 1#>
Get-Service | ConvertTo-Html | Out-File -FilePath $HTMLFile
.  $HTMLFile





<#Example 2#>
Get-Service | ConvertTo-Html -As List | Out-File -FilePath $HTMLFile
. $HTMLFile





<#Example 3#>
Get-Service | ConvertTo-Html -Property UserName,Name,ServiceName,MachineName,StartupType | Out-File -FilePath $HTMLFile
. $HTMLFile

#WowThisSucks!!!!