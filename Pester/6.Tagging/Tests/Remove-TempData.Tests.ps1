$here = (Split-Path -Parent $MyInvocation.MyCommand.Path) -replace 'Tests', 'Module\Functions'
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.ps1', '.psm1'

Import-Module "$here\$sut"

Describe -name "Remove-TempData" -Tag @("Complex","Remove") -Fixture {
	Context -Name "Mocking Functions" -Fixture {
		Mock -CommandName Remove-Item -ModuleName Remove-TempData -MockWith {}
		It -Name "Function returns directory object" -test {
			$Result = Remove-TempData
			$Result | Should -BeNullOrEmpty -Because  "We are testing things, and this is a Remove Command afterall!"
		}
	}
	Context -Name "Live Unit Testing" -Fixture {
		It -Name "Function returns directory object" -test {
			$Result = Remove-TempData
			$Result | Should -BeNullOrEmpty -Because "We are testing things, we got output!"
		}
	}
}

Remove-Module ($sut -replace "\.psm1","")