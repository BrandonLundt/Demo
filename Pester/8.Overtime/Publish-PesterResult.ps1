$PesterOut = Invoke-Pester -Script $env:USERPROFILE\Documents\PowerShellProjects\Demo\Pester -PassThru -Show None

$DefaultDisplay = @{
    Options = @{  
        legend = @{  
            display = $false  
        }  
    }
}
$Dashboard = {
	New-UDDashboard -Title "Pester Results" -NavBarColor '#FF1c1c1c' -NavBarFontColor "#FF55b3ff" -BackgroundColor "#FF333333" -FontColor "#FFFFFF" -Content {
        New-UDRow {
            New-UDColumn -MediumSize 6 -Content{
			    New-UDChart -Title "Overall Failure Percentage" -Type Bar @DefaultDisplay -Endpoint {
				    [PSCustomObject]@{ 
					    Failed = $pesterOut.FailedCount
                            Passed = $PesterOut.PassedCount
						    Name = "Total"
					
				    } | Out-UDChartData -LabelProperty "Name" -Dataset @(
                       New-UdChartDataset -DataProperty "Failed" -Label "Failed Count" -BackgroundColor "#80962F23" -HoverBackgroundColor "#80962F23"
                       New-UdChartDataset -DataProperty "Passed" -Label "Passed Count" -BackgroundColor "#8014558C" -HoverBackgroundColor "#8014558C"
                   )#Dataset array
			    }#New-UDChart
                
					}#New-UDColumn
					New-UDColumn -MediumSize 6 -Content {
						New-UDChart -Title "Failures by Context" -Type Doughnut @DefaultDisplay -Endpoint { 
							$Context = $InputObject.TestResult | Select-Object -ExpandProperty Context -Unique
							$Data = @()
							foreach ( $Item in $Context) {
								$Fail_Data = $InputObject.TestResult | Where-Object {($_.Context -eq $Item) -and ($_.Result -ne "Passed")}
								$Pass_Data = $InputObject.TestResult | Where-Object {($_.Context -eq $Item) -and ($_.Result -eq "Passed")}
								if ( $Pass_Data.Count ) {
									$Data += [PSCustomObject]@{ Context = $Item; Failures = $Fail_Data.Count; Passed = $Pass_Data.Count }
								}
								else {
									$Data += [PSCustomObject]@{ Context = $Item; Failures = $Fail_Data.Count; Passed = 4 }
								}
							}
							$Data | Out-UDChartData -LabelProperty "Context" -Dataset @(
								New-UdChartDataset -DataProperty "Failures" -Label "Failed Count" -BackgroundColor "#80941F23" -HoverBackgroundColor "#80962F23"
								New-UdChartDataset -DataProperty "Passed" -Label "Passed Count" -BackgroundColor "#FF332233" -HoverBackgroundColor "#FF334433"
							)#Dataset array
						} #New-UDChart
					}#New-UDColumn
				}#New-UDRow
				New-UDRow -EndPoint {
					$Describes = $InputObject.TestResult | Select-Object -Unique -ExpandProperty Describe
					Foreach ( $Table in $Describes) {
						New-UDColumn -LargeSize 6 -Endpoint {
							New-UDTable -Title "$Table  Failures" -Headers @("Name", "Context", "Result") -BackgroundColor "#80941F23" -FontColor White -Endpoint {
								$InputObject.TestResult | Where-Object Describe -eq $Table | Where-Object Result -ne "Passed" | Out-UDTableData -Property @("Name", "Context", "Result")
							}
						}#New-UDColumn
						New-UDColumn -LargeSize 6 -Endpoint {
							New-UDTable -Title "$Table  Passed" -Headers @("Name", "Context", "Result") -BackgroundColor "#FF334433" -FontColor White -Endpoint {
								$InputObject.TestResult | Where-Object Describe -eq $Table | Where-Object Result -eq "Passed" | Out-UDTableData -Property @("Name", "Context", "Result")
							}
						}#New-UDCOlumn
					}#foreach
				}#New-UDRow
			}#New-UDDashboard
		}#Dashboard

		$ResultsDashboard = Get-UDDashboard

		if ($ResultsDashboard) {
			$ResultsDashboard | Stop-UDDashboard
		}

		$null = Start-UDDashboard -Content $Dashboard -Port $Port
	}#Process
	End {
		Remove-Variable -Name ResultsDashboard, Table, Describes, Context
	}
}

#$Config = Get-Content -Path "..\PLXS_Exchange\docs\Config\ALL_Prod.json" | ConvertFrom-Json | ConvertTo-PLXSHashtable
#$Output = Invoke-Pester -Tags "Config" -PassThru -Script "C:\Users\brandon.lundt\Documents\WindowsPowerShell\Modules\PLXS_Exchange\2.0.10\Diagnostics\Simple"
Invoke-Pester -Script .\Pester -PassThru -show None | Publish-PesterResult
$Output | Publish-PesterResult