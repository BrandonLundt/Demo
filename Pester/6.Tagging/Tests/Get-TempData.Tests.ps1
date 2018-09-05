$here = (Split-Path -Parent $MyInvocation.MyCommand.Path) -replace 'Tests','Module\Functions'
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.ps1', '.psm1'
Import-Module "$here\$sut"

Describe -name "Get-TempData" -Tag @("Simple","Complex","Get") -Fixture {
	It -Name "Function returns directory object" -test {
		$Result = Get-TempData
        $Result | Should -Not -BeNullOrEmpty -Because "We are testing things, we got output!"
        $Result | Should -BeOfType System.IO.DirectoryInfo -Because "We are expecting the type to be a directory Item."
	}
}

Remove-Module ($sut -replace "\.psm1","")