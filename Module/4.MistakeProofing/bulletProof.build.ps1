FormatTaskName "-------- {0} --------"

task -name "Git" -precondition { git status -s} -description "Checks for modified files." -action{
    Write-Error -Message "Git status: $((git status -s) -join ', ')"
}
task -name "Unload" -precondition { (Get-Module MonoModule) -gt 0} -description "Unloads MonoModule from the current session" -action { 
    Remove-Module MonoModule
}

task -name "PreBuild Checklist" -depends "Git","Unload"

task -name "CopyToModuleFolder" -action { 
    $ModuleFolder = "C:\Users\brandon.lundt\Documents\PowerShell\Modules\MonoModule\0.2"
    if( Test-Path $ModuleFolder ){
        Get-Item *.ps[dm]1 | Copy-Item -Destination $ModuleFolder
    }
}

task -name "Import" -depends "WriteOutput" -preaction { Write-Host "Hello from Import"} -action { 
    Get-Module -ListAvailable MonoModule | Import-Module
}
task -name "Build" -depends "PreBuild Checklist","CopyToModuleFolder","Import"

task -name "default" -depends "Build"