$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.ps1', '.psm1'
Import-Module "$here\$sut"

Describe -name "Remove-TempData" -Fixture {
	Context -Name "Mocking Function Test-Path, Remove-Item" -Fixture {
		Mock -CommandName Test-Path -ModuleName Remove-TempData -MockWith {
			$false
		}
		Mock -CommandName Remove-Item -ModuleName Remove-TempData -MockWith {}
		
		It -name "Command throws error if Path not found" -test {
			{ Remove-TempData }	| Should -Throw
		}
	}
	Context -Name "Mocking Remove-Item Function" -Fixture{
		Mock -CommandName Remove-Item -ModuleName Remove-TempData -MockWith {}
		It -Name "Function returns no data, and does not delete or throw error" -test {
			$Result = Remove-TempData -FilePath $env:TEMP
			$Result | Should -BeNullOrEmpty -Because "We are testing things, we got output!"
			Test-Path $env:TEMP | Should -Be $True
		}
	}
	Context -Name "Live Unit Testing" -Fixture {
		It -Name "Function deletes directory object $env:TEMP\TestData" -test {
			$Directory = New-Item -Path $env:TEMP -Name TestData -ItemType Directory
			$Result = Remove-TempData -FilePath $Directory
			$Result | Should -BeNullOrEmpty -Because "We are testing things live, no errors or output is expected!"
			Test-Path -Path $Directory | Should -Be $false
		}
	}
}

Remove-Module ($sut -replace "\.psm1","")