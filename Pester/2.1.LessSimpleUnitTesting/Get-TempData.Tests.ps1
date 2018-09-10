$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.ps1', '.psm1'
Import-Module "$here\$sut"

Describe -name "Get-TempData" {
	It -Name "Function returns directory object" -test {
		$Result = Get-TempData
        $Result | Should -Not -BeNullOrEmpty -Because "We are testing things, we got output!"
        $Result | Should -BeOfType System.IO.DirectoryInfo -Because "We are expecting the type to be a directory Item."
	}#It
    It -Name "Function Name has a -" -test{
        Get-Content -Path "$here\$sut" | Select-String -Pattern "Function" | Should -Match '[Function\s\w\-\w\s{]'
    }#It
    It -Name "Function matches Noun-Verb Standards" -test{
        $FileContents = Get-Content -Path "$here\$sut"
        $Verb = ($FileContents | Select-String -Pattern "Function") -replace '([\w]+\s)([\w]+)([\-\w]*\s{)','$2'
        $Verbs = Get-Verb | Select-Object -ExpandProperty Verb
        $Verbs | Should -Contain $Verb
    }#It
    It -name "Functions throws error on bad path" -test{
        { Get-TempData -FilePath "U:DoesNotExit" } | Should -Throw
    }#It
}

Remove-Module ($sut -replace "\.psm1","")