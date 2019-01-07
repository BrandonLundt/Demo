Properties {
    $Author = "Brandon Lundt"
    $DefaultLocale = 'en-US'
    $GUID = '41824cb3-2d67-4df7-aaef-792032c4cc94'
    $DocsRootDir = "$PSScriptRoot\docs"
    $PowerShellVersion = '5.0'
    $Description = ""
    $ReleaseNotes = Get-content -Path "$PSScriptRoot\ReleaseNotes.md" -Raw
    $PrivateFunctions = "$PSScriptRoot\Module\Private"
    $PublicFunctions = "$PSSCriptRoot\Module\Public"
    $SrcRootDir = "$PSScriptRoot\Module"
    $UnitTestDir = "$PSScriptRoot\Tests"
    $Version = "1.0"
    $ModuleName = "MonoModule"
    $UserModuleDirectory = $env:PSModulePath.Split(";") | Select-String -Pattern "Documents"
    $InstallPath = "$UserModuleDirectory\$ModuleName\$Version\"
    $RepositoryName = "Local"
    $ScriptAnalyzerSettingsPath = "$PSScriptRoot\ScriptAnalyzerSettings.psd1"
}