$Dashboard = New-UDDashboard -Title "Services!!" -Content {
    New-UDTable -Title "Server Information" -Headers @(" ", " ") -Endpoint {
        Get-Service | Out-UDTableData -Property @("Name", "Value")
    }
}
Start-UDDashboard -Dashboard $Dashboard -Port 1001






$Dashboard = New-UDDashboard -Title "Services!!" -Content {
    New-UDTable -Title "Server Information" -Headers @("UserName","Name","ServiceName","MachineName","StartupType") -Endpoint {
        Get-Service | Out-UDTableData -Property @("UserName","Name","ServiceName","MachineName","StartupType")
    }
}
Start-UDDashboard -Dashboard $Dashboard -Port 1001






<# Woops! Forgot a thing!#>
Get-UDDashboard | Stop-UDDashboard