Function New-TypeData{
    <#
    #>
    param(
        [string]$FilePath
    )
    process{
        if( Test-Path $FilePath){
        Get-Item -Path C:\Windows\System32\WindowsPowerShell\v1.0\DotNetTypes.format.ps1xml | Copy-Item -Destination $FilePath
        }
        else{
            Write-Warning -Message "$FilePath not found"
        }
    }
}