﻿$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.ps1', '.psm1'
Import-Module "$here\$sut"

Describe -name "Get-TempData" {
	Context -Name "Testing Filter Parameter" -Tag @("Stuff") -Fixture {
		Mock -CommandName Get-ChildItem -ParameterFilter { $Filter -and $Path } -ModuleName Get-Tempdata -MockWith {
			$Output = @{
				Attributes        = "-a----"
				CreationTime      = (Get-Date)
				CreationTimeUtc   = (Get-Date)
				Directory         = "C:\Stuff"
				DirectoryName     = "Demo"
				Exists            = $True
				Extension         = ".log"
				FullName          = "DemoData.log"
				IsReadOnly        = $True
				LastAccessTime    = (Get-Date)
				LastAccessTimeUtc = (Get-Date)
				LastWriteTime     = (Get-Date)
				LastWriteTimeUtc  = (Get-Date)
				Length            = 1024
				Name              = "DemoData"
				Count             = 1
			}
			return $Output
		}
	
		It -Name "Function returns directory object" -test {
			$Result = Get-TempData
			$Result | Should -Not -BeNullOrEmpty -Because "We are testing things, we got output!"
			$Result.Count | Should -BeGreaterThan 2
		}
		$Result = Get-TempData -Filter
		It -Name "Assert we are mocking Get-ChildItem" -test {
			Assert-MockCalled -CommandName Get-ChildItem -ModuleName Get-TempData
		}
		It -name "Confirm we are getting expected hashtable properties" -test {
			$Result | Should -Not -BeNullOrEmpty -Because "We are testing things, we got output!"
			$Result.Count | Should -Be 1
			$Result | Should -BeOfType Hashtable -Because "We are expecting this to be our mocked output."
		}
	}#Context
}

Remove-Module ($sut -replace "\.psm1","")