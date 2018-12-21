Function Sing{
    process{
        Add-Type -AssemblyName System.speech
        $speak = New-Object System.Speech.Synthesis.SpeechSynthesizer

        $speak.Rate = 10
        $speak.Speak('One, two, three, four:')
        $speak.Speak('Grandma got run over by a reindeer')
        $speak.Speak('Walking home from our house Christmas eve')
        $speak.Speak('You can say theres no such thing as Santa')
        $speak.Speak('But as for me and Grandpa, we believe')
    }#process
}#Function
Function New-TypeData{
    <#
    #>
    param(
        [string]$FilePath
    )
    process{
        if( Test-Path $FilePath){
        Get-Item -Path C:\Windows\System32\WindowsPowerShell\v1.0\DotNetTypes.format.ps1xml | Copy-Item -Destination $FilePath
        }
        else{
            Write-Warning -Message "$FilePath not found"
        }
    }
}

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

