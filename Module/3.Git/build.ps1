Invoke-psake -buildFile version.build.ps1 -docs

Invoke-psake -buildFile version.build.ps1

Add-Content -Value "   " -Path .\MonoModule.psm1

Invoke-psake -buildFile version.build.ps1