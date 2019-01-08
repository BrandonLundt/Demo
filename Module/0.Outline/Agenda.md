1. Walk through a module build process and some suggested practices.
-- When do I use a script?
   Something you run once a year,or will run it a handful of times.
-- When do I create a module?
   Things you run every day, business process that you and others *need* to do consistently. Easily distributed.
2. Sell you on the idea that the follow code is __never__ a good idea; especially in a root module.

Get-ChildItem -Path "$PSScriptRoot/Public", "$PSScriptRoot/Private" | ForEach-Object { 
    Write-Verbose "Importing functions from file: [$($_.Name)]" 
    . $_.FullName 
} 

OR

#Module vars 
$ModulePath = $PSScriptRoot 

 
#Get public and private function definition files. 
$Public  = Get-ChildItem $PSScriptRoot\Public\*.ps1 -ErrorAction SilentlyContinue 
$Private = Get-ChildItem $PSScriptRoot\Private\*.ps1 -ErrorAction SilentlyContinue 
[string[]]$PrivateModules = Get-ChildItem $PSScriptRoot\Private -ErrorAction SilentlyContinue | 
Where-Object {$_.PSIsContainer} | 
Select-Object -ExpandProperty FullName 

 
# Dot source the files 
Foreach($import in @($Public + $Private)) 
{ 
	Try
	{ 
		. $import.fullname 
	} 
	Catch 
	{ 
		Write-Error "Failed to import function $($import.fullname): $_" 
	} 
} 

 
# Load up dependency modules 
foreach($Module in $PrivateModules) 
{ 
	Try 
	{ 
		Import-Module $Module -ErrorAction Stop 
	} 
	Catch 
	{ 
		Write-Error "Failed to import module $Module`: $_" 
	} 
} 
