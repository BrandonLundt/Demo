task -name "WriteOutput" -preaction { 
    Write-Host "Oh, hello"
} -action { 
    Write-Host "Actual Action"
} -postaction{
    Write-Host "Post Action"
}

task -name "Import" -depends "WriteOutput" -preaction { Write-Host "Hello from Import"} -action { 
    Get-ChildItem
}

task -name "default" -depends "Import"