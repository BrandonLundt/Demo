task -name "Git" -preaction { Write-Host "Checking Git Status"} -precondition {}
task -name "PreBuild Checklist" -depends "Git" 

task -name "Import" -depends "WriteOutput" -preaction { Write-Host "Hello from Import"} -action { 
    Get-ChildItem | Write-Verbose
}

task -name "default" -depends "Import"