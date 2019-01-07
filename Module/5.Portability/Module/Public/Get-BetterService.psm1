function Get-BetterService {
    [CmdletBinding()]
    param (
        [string]$Filter = "*"
    )
    
    begin {
        Write-Verbose -Message "Hey, it's the beginning!"
    }
    
    process {
        Get-Service -Include $Filter | select Name,CanShutdown,Status,StartupType
    }
    
    end {
        Remove-Variable -Name Filter
    }
}
