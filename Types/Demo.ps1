# What is a type and where do I find it
Get-Item -Path $env:USERPROFILE\Documents\

Get-Item -Path $env:USERPROFILE\Documents\ | Get-Member

Get-TypeData -TypeName System.IO.*

# Lets add ACL information to Directory information
Get-Acl -Path $env:USERPROFILE\Documents | Select-Object -Property Owner

Get-Item -Path C:\Windows\System32\WindowsPowerShell\v1.0\types.ps1xml | Copy-Item -Destination .


# Now let's make it pretty!
Get-Item -Path C:\Windows\System32\WindowsPowerShell\v1.0\DotNetTypes.format.ps1xml | Copy-Item -Destination .


# But I can't easily add this to everyone's profile so HOW DO I DISTRIBUTE IT
Remove-TypeData -TypeName System.IO.DirectoryInfo

Update-TypeData .\types.ps1xml