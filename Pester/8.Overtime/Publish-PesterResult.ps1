<#Name              MemberType   Definition
----              ----------   ----------
Equals            Method       bool Equals(System.Object obj)
GetHashCode       Method       int GetHashCode()
GetType           Method       type GetType()
ToString          Method       string ToString()
ExcludeTagFilter  NoteProperty object ExcludeTagFilter=null
FailedCount       NoteProperty int FailedCount=0
InconclusiveCount NoteProperty int InconclusiveCount=0
PassedCount       NoteProperty int PassedCount=1
PendingCount      NoteProperty int PendingCount=0
SkippedCount      NoteProperty int SkippedCount=0
TagFilter         NoteProperty object TagFilter=null
TestNameFilter    NoteProperty object TestNameFilter=null
TestResult        NoteProperty Object[] TestResult=System.Object[]
Time              NoteProperty timespan Time=00:00:00.4936856
TotalCount        NoteProperty int TotalCount=1
#>
$FailPercentage = $PesterOut.FailedCount / $PesterOut.TotalCount

$Dashboard = {
	New-UDDashboard -Title "Pester Results" -NavBarColor '#FF1c1c1c' -NavBarFontColor "#FF55b3ff" -BackgroundColor "#FF333333" -FontColor "#FFFFFF" -Content {
		New-UDRow -Columns {
			New-UDChart -Title "Failure Percentage" -Type Bar -Endpoint {
				[PSCustomObject]@{ 
					Failed = $pesterOut.FailedCount
                        Passed = $PesterOut.PassedCount
						Total = $PesterOut.TotalCount 
					
				} | Out-UDChartData -LabelProperty "DeviceID" -Dataset @(
       New-UdChartDataset -DataProperty "Failed" -Label "Failed Count" -BackgroundColor "#80962F23" -HoverBackgroundColor "#80962F23"
       New-UdChartDataset -DataProperty "Passed" -Label "Passed Count" -BackgroundColor "#8014558C" -HoverBackgroundColor "#8014558C"
   )
			}
		}
		New-UDRow -Columns {
			New-UDChart -Title "Failure Percentage" -Type Doughnut -Endpoint {
				$PesterOut.TestResult | Foreach-Object { if ( $_.Result -eq "PASSED") {[PSCustomObject]@{ Name = $_.Name; Result = 4}}Else {[PSCustomObject]@{ Name = $_.Name; Result = 1} 
					}} | Out-UDChartData -LabelProperty "Name" -DataProperty "Result"
			}
			New-UDChart -Title "Threads by Process" -Type Doughnut -RefreshInterval 5 -Endpoint { 
				Get-Process | ForEach-Object { [PSCustomObject]@{ Name = $_.Name; Threads = $_.Threads.Count } } | Out-UDChartData -DataProperty "Threads" -LabelProperty "Name"  
			}
		}
	}
}

$ResultsDashboard = Get-UDDashboard

    if ($ResultsDashboard) {
        $ResultsDashboard | Stop-UDDashboard
    }

    $null = Start-UDDashboard -Content $Dashboard