FormatTaskName "-------- {0} --------"
. "$PSScriptRoot\Settings.build.ps1"

task -name "Git" -precondition { git status -s} -description "Checks for modified files." -action{
    Write-Error -Message "Git status: $((git status -s) -join ', ')"
}
task -name "Unload" -precondition { (Get-Module MonoModule) -gt 0} -description "Unloads MonoModule from the current session" -action { 
    Remove-Module MonoModule
}

task -name "Analyze" -Action {
	$saResults = Invoke-ScriptAnalyzer -Path $PSScriptRoot -Severity @('Error', 'Warning') -Settings $ScriptAnalyzerSettingsPath -Recurse #-Verbose:$false
	$Errors = $saResults | Where-Object -FilterScript {$_.Severity -like 'Error'}
	$Warnings = $saResults | Where-Object -FilterScript {$_.Severity -like 'Warning'}
    if ($Warnings){
		$Warnings | Format-Table
		Write-Warning -Message "One or more Script Analyzer warnings were found!"
	}
    if ($Errors) {
		$Errors | Format-Table
		Write-Error -Message 'One or more Script Analyzer errors where found. Build cannot continue!'
	}
}

task -name "Test" -depends "Unload Module" -action {
	$testResults = Invoke-Pester -Path $UnitTestDir -PassThru -Show None
	if ($testResults.FailedCount -gt 0) {
		$testResults | Format-List
		Write-Error -Message 'One or more Pester tests failed. Build cannot continue!'
	}
}
task -name "Clean temp" -precondition {Test-Path "$env:temp\$ModuleName"} -action {
	Get-ChildItem -Path "$env:temp\$ModuleName" | Remove-Item -Recurse
}
task -name "Clean" -description "Cleans up temp and module directories" -depends "Unload Module","Clean temp" -precondition { Test-Path $InstallPath } -action {
	Get-ChildItem $InstallPath | Remove-Item -Recurse
}#Clean task

task -name "PreBuild Checklist" -depends "Git","Unload","Analyze","Test","Clean"

task -name "Manifest" -description "Generates module manifest" -requiredVariables Version,InstallPath -action {
	<#Collect functions available and add them to the "nested modules" #>
	$FunctionsToExport = Get-ChildItem -Path $PrivateFunctions -Include *.psm1 -Recurse | Select-Object -ExpandProperty BaseName
	$Manifest_Params = @{
		Path              = "$SrcRootDir\$ModuleName.psd1"
		RootModule        = "$ModuleName.psm1"
		GUID              = $GUID
		Author            = $Author
		CompanyName       = $CompanyName
		CopyRight         = $CopyRight
		ModuleVersion     = $Version
		PowerShellVersion = $PowerShellVersion
		Description       = $Description
		FunctionsToExport = $FunctionsToExport
		ReleaseNotes      = $ReleaseNotes
	}
	if ( Test-Path "$SrcRootDir\$ModuleName.psd1") {
		$Manifest = Get-Item "$SrcRootDir\$ModuleName.psd1"
		$Settings = Get-Item "$PSScriptRoot\Settings.build.ps1"
		#if ( $Manifest.LastWriteTime -lt $Settings.LastWriteTime) {
			Update-ModuleManifest @Manifest_Params -Verbose:$VerbosePreference
		#}#if
	}
	else {
		New-ModuleManifest @Manifest_Params -Verbose:$VerbosePreference
	}#if manifest doesn't exist
}#Task create manifest

task -name "CopyToModuleFolder" -action { 
    if( -not (Test-Path $InstallPath) ){
		New-Item -Path $InstallPath -ItemType Directory
    }
    Get-Item -Path "$PSScriptRoot\Module\$ModuleName.psd1" | Copy-Item -Destination $InstallPath
    Get-Item -Path "$PSScriptRoot\Module\$ModuleName.psm1" | Copy-Item -Destination $InstallPath
	Get-ChildItem -Path $PrivateFunctions -Include *.psm1 -Recurse | ForEach-Object {
		Get-Content -LiteralPath $_.FullName -Raw | Add-Content -Path "$InstallPath\$ModuleName.psm1"
	}#foreach function in InstallPath
	Get-ChildItem -Path $PublicFunctions -Include *.psm1 -Recurse | ForEach-Object {
		Get-Content -LiteralPath $_.FullName -Raw | Add-Content -Path "$InstallPath\$ModuleName.psm1"
	}#foreach function in InstallPath
}

task -name "Import" -depends "WriteOutput" -preaction { Write-Host "Hello from Import"} -action { 
    Get-Module -ListAvailable MonoModule | Import-Module
}
task -name "Build" -depends "PreBuild Checklist","CopyToModuleFolder","Import"

task -name "default" -depends "PreBuild Checklist","Build"