task -name "WriteOutput" -preaction { 
    Write-Host "Oh, hello"
} -action { 
    Write-Host "Actual Action"
    $ModuleFolder = "C:\Users\brandon.lundt\Documents\PowerShell\Modules\MonoModule\0.2"
    if( Test-Path $ModuleFolder ){
        Get-Item *.ps[dm]1 | Copy-Item -Destination $ModuleFolder
    }
} -postaction{
    Write-Host "Post Action"
}

task -name "Import" -depends "WriteOutput" -preaction { Write-Host "Hello from Import"} -action { 
    Get-Module -ListAvailable Mon* | Import-Module
}

task -name "Unload" -description "Unloads MonoModule from the current session" -action { 
    Remove-Module MonoModule
}

task -name "default" -depends "Import"