function Remove-TempData {
	[cmdletbinding()]
	param(
		[string]$FilePath = "$env:TEMP\TempData"
	)
	process {
		if ( -not (Test-Path $FilePath) ) {
			Throw("FilePath not found")
		}

		$Directory = Get-Item -Path $FilePath
		Remove-Item -Recurse -Path $Directory
	}
}