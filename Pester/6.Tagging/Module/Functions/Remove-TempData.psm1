function Remove-TempData {
	if ( Test-Path $env:TEMP\TempData) {
		$Directory = Get-Item -Path $env:TEMP\TempData	
	}
	else {
		$Directory = New-Item -Path $env:TEMP -Name TempData -ItemType Directory
	}
	
	Remove-Item -Recurse -Path $Directory
}