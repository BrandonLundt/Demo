$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.ps1', '.psm1'
Import-Module "$here\$sut"
$ModuleName = ($sut -replace ".psm1","")
Describe -Name "Module Manifest testing" -Tag "Manifiest" -Fixture{
    It -Name "Manifest Exists" -Test{
        Test-Path .\MonoModule.psd1 | Should -Be $True
    }
    It -Name "Validate Manifest is valid" -Test{
        Test-ModuleManifest -Path .\MonoModule.psd1
    }
}

Describe -Name "Root Module Testing" -Tag "Root" -Fixture{
    $Names = Get-Command -Module $ModuleName | Select-Object -ExpandProperty Name
    foreach( $Name in $Names){
        It -Name "Function $name is expected" -Test{
            '[Sing|Get-BetterService|New-TypeData]'| Should -Match $Name
        }
    }#foreach
}

Remove-Module -Name $ModuleName