Function Get-TempData {
    [cmdletbinding()]
    param(
        [Parameter( Mandatory=$False)]
        [String]$FilePath = $env:TEMP
    )
    process{
        if ( -not (Test-Path $FilePath) ) {
            $PSCmdlet.ThrowTerminatingError("FilePath not found")
		}
	    Get-Item -Path $FilePath
    }
}
