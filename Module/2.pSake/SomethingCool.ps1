
task -name "WriteOutput" -preaction { 
    Write-Host "Oh, hello"
} -action { 
    Write-Host "Actual Action"
} -postaction{
    Write-Host "Post Action"
}

task -name "default" -depends "WriteOutput"