task -name "Git" -preaction { Write-Host "Checking Git Status"} -action{
    if( git status -s){
        Write-Error -Message "Git status: $((git status -s) -join ', ')"
    }
}
task -name "Unload" -description "Unloads MonoModule from the current session" -action { 
    Remove-Module MonoModule
}

task -name "PreBuild Checklist" -depends "Git","Unload"

task -name "CopyToModuleFolder" -action { 
    Write-Host "Actual Action"
    $ModuleFolder = "C:\Users\brandon.lundt\Documents\PowerShell\Modules\MonoModule\0.2"
    if( Test-Path $ModuleFolder ){
        Get-Item *.ps[dm]1 | Copy-Item -Destination $ModuleFolder
    }
}

task -name "Import" -depends "WriteOutput" -preaction { Write-Host "Hello from Import"} -action { 
    Get-Module -ListAvailable Mon* | Import-Module
}
task -name "Build" -depends "PreBuild Checklist","CopyToModuleFolder","Import"

task -name "default" -depends "PreBuild Checklist","Build"