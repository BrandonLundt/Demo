Invoke-Pester -CodeCoverage .\Pester\2.SimpleUnitTesting\Get-TempData.psm1 -Script .\Pester\2.SimpleUnitTesting\Get-TempData.Tests.ps1

#Example from GitHub -> Full file test
Invoke-Pester .\Pester\8.Overtime\CoverageTest.Tests.ps1 -CodeCoverage .\Pester\8.Overtime\CoverageTest.ps1

#Example from GitHub -> Specific Function
Invoke-Pester .\Pester\8.Overtime\CoverageTest.Tests.ps1 -CodeCoverage @{Path = '.\Pester\8.Overtime\CoverageTest.ps1'; Function = 'FunctionOne' }