Describe -Name "Checking configured services" -Fixture {
	Context -Name "Super Important Services" -Fixture {
		$Services = @(
			@{
				Name      = "WebClient"
				Status    = "Stopped"
				StartType = "Manual"
			},
			@{
				Name      = "WinRM"
				Status    = "Running"
				StartType = "Automatic"
			}
		)
		It -name "<Name> Service <Status>" -TestCases $Services -test {
			param( $Name, $Status, $StartType)
			$Result = Get-Service -Name $Name
			$Result.Status | Should -Be $Status
			$Result.StartType | Should -Be $StartType
		}
	}
}