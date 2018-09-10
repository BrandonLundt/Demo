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

#$PesterOut = Invoke-Pester -Script $env:USERPROFILE\Documents\PowerShellProjects\Demo\Pester -PassThru -Show None
#$Context = $Null
$Context_Passed = 0
$Context_Failed = 0
$DefaultDisplay = @{
    Options = @{  
        legend = @{  
            display = $false  
        }  
    }
}
$Dashboard = {
	New-UDDashboard -Title "Pester Results" -NavBarColor '#FF1c1c1c' -NavBarFontColor "#FF55b3ff" -BackgroundColor "#FF333333" -FontColor "#FFFFFF" -Content {
        <##########################################
         NEEDS REVIEW
         Thought is to present buttons for the Contexts presented in Pester results.OnButtonClick, charts should filter to that context.
		New-UDRow {
            $MyVariable = "Some Text"
            New-UDButton -Text "Click me!" -OnClick (
                New-UDEndpoint -Endpoint {
                    Show-UDToast -Message $ArgumentList[3]
                } -ArgumentList @($Context_Passed,$Context_Failed,$PesterOut)
            )
            $Context = $PesterOut.TestResult | Select-Object Context -Unique
            Foreach( $Item in $Context){
                New-UDColumn -Content {
                    $MyVariable = $PSItem
                    $Context_ScriptBlock = {
                        $Context_Passed = 0
                        $Context_Failed = 0
                        $PesterOut.TestResult | Where-Object Context -eq $PSItem | ForEach-Object {
                            if( $PSItem.Result -eq "Passed"){
                                $Context_Passed++
                            }
                            else{
                                $Context_Failed++
                            }
                        }#Foreach-Object
                    }#Scriptblock
                    New-UDButton -Text $Item.Context -OnClick ( New-UDEndpoint -ArgumentList @($Context_Passed,$Context_Failed,$PesterOut,$Item) -Endpoint {
                        $Context_Passed = 0
                        $Context_Failed = 0
                        #$PesterOut.TestResult | Where-Object Context -eq $Item.Context | ForEach-Object {
                        $PesterOut.TestResult | ForEach-Object {
                            Show-UDToast -Message $Item.Result -Duration 2
                            if( $Item.Result -eq "Passed"){
                                $Context_Passed++
                                Show-UDToast -Message $Item.Name
                            }
                            else{
                                $Context_Failed++
                                Show-UDToast -Message $Item.Result -Duration 2
                            }
                        }#Foreach-Object
                        #Show-UDToast -Message $Context_Passed
                    }#Scriptblock
                    )
                }#New-UDColumn
            }#Foreach-Object Context
        }#New-UDROw
        End of needs review section
        #################################################>
        New-UDRow {
            New-UDColumn -MediumSize 6 -Content{
			    New-UDChart -Title "Overall Failure Percentage" -Type Bar -Endpoint {
				    [PSCustomObject]@{ 
					    Failed = $pesterOut.FailedCount
                            Passed = $PesterOut.PassedCount
						    Name = "Total"
					
				    } | Out-UDChartData -LabelProperty "Name" -Dataset @(
                       New-UdChartDataset -DataProperty "Failed" -Label "Failed Count" -BackgroundColor "#80962F23" -HoverBackgroundColor "#80962F23"
                       New-UdChartDataset -DataProperty "Passed" -Label "Passed Count" -BackgroundColor "#8014558C" -HoverBackgroundColor "#8014558C"
                   )#Dataset array
			    }-Options @{  
                     legend = @{  
                         display = $false  
                     }  
                   }#New-UDChart
                
            }#New-UDColumn
            New-UDColumn -MediumSize 6 -Content {
			    New-UDChart -Title "Failures by Context" -Type Doughnut @DefaultDisplay -Endpoint { 
                    $Context = $PesterOut.TestResult | Select-Object -ExpandProperty Context -Unique
                    $Data = @()
                    foreach( $Item in $Context){
                        $Fail_Data = $PesterOut.TestResult | Where-Object {($_.Context -eq $Item) -and ($_.Result -ne "Passed")}
                        $Pass_Data = $PesterOut.TestResult | Where-Object {($_.Context -eq $Item) -and ($_.Result -eq "Passed")}
                        if( $Pass_Data.Count ){
                            $Data += [PSCustomObject]@{ Context = $Item; Failures = $Fail_Data.Count; Passed = $Pass_Data.Count }
                        }
                        else{
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
            $Describes = $PesterOut.TestResult | Select-Object -Unique -ExpandProperty Describe
            Foreach( $Table in $Describes){
                New-UDColumn -LargeSize 6 -Endpoint {
                New-UDTable -Title "$Table -- Failures" -Headers @("Name", "Context","Result") -BackgroundColor "#80941F23" -FontColor "#FFFFFF" -Endpoint {
                    $PesterOut.TestResult | Where-Object Describe -eq $Table | Where-Object Result -ne "Passed" | Out-UDTableData -Property @("Name","Context","Result")
                }
                }#New-UDColumn
                New-UDColumn -LargeSize 6 -Endpoint {
                New-UDTable -Title "$Table -- Passed" -Headers @("Name", "Context","Result") -BackgroundColor "#FF334433" -FontColor "#FFFFFF" -Endpoint {
                    $PesterOut.TestResult | Where-Object Describe -eq $Table | Where-Object Result -eq "Passed" | Out-UDTableData -Property @("Name","Context","Result")
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

$null = Start-UDDashboard -Content $Dashboard -Port 4242