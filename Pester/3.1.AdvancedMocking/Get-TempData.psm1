function Get-TempData {
	param(
		[switch]$Filter
	)
	process {
		if ( $Filter) {
			$Results = Get-ChildItem -Path $env:TEMP -Filter *.log
		}
		else {
			$Results = Get-ChildItem -Path $env:TEMP
		}
		Write-Output $Results
	}
}
