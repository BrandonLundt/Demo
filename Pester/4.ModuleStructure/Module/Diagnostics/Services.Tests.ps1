Describe -Name "Checking configured services" -Fixture {
	Get-Service | Where-Object StartType -eq "Automatic" | ForEach-Object {
		It -name "Services running" -test {
			$PSItem.Status | Should -Be "Running" -Because "An automatic service should be running"
		}
	}
}