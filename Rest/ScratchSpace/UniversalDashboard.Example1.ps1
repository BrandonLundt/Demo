$Endpoint = New-UDEndpoint -Url "/process" -Method "POST" -Endpoint {
    param($Body)

    $Parameters = $Body | ConvertFrom-Json
    Get-Process -Name $Parameters.Name | ConvertTo-Json
    #Start-Process -FilePath $Body.FilePath -Arguments $Body.Arguments
}
Start-UDRestApi -Endpoint $Endpoint -Port 8080 | Out-Null

$Rest_params = @{
    Uri = "http://localhost:8080/api/process"
    Method = "POST"
    #Body = @{FilePath = "code"; Arguments = "script.ps1" } | ConvertTo-Json
    Body = @{Name = "Battle.net" } | ConvertTo-Json
}
Invoke-RestMethod  @Rest_params