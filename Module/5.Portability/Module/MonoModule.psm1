$Modules = Get-Module -ListAvailable PLXS* | Select-Object -Unique | Select-Object -ExpandProperty Name
Register-ArgumentCompleter -ParameterName Filter -CommandName Get-BetterSerivce  -ScriptBlock{
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameter)
 
    $Modules | ForEach-Object {
       New-Object System.Management.Automation.CompletionResult (
           $_,
           $_,
           'ParameterValue',
           $_
       )
   }#Foreach-object
}

$SomeVariable = "A global variable of some sort"