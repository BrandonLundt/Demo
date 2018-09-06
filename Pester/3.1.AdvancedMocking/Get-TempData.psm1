function Get-TempData {
	param(
		[switch]$Filter,
        [switch]$Include
	)
	process {
		if ( $Filter) {
			$Results = Get-ChildItem -Path $env:TEMP -Filter *.log
		}
		else {
            if( $Include){
                Write-Information -MessageData "Guys, I have stuff"
                $Results = Get-ChildItem -Path $env:TEMP -Include *.rar
            }
            else{
			    $Results = Get-ChildItem -Path $env:TEMP
            }
		}
		Write-Output $Results
	}
}
