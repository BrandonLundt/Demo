function Avoid-BadCapialization {
    [CmdletBinding()]
    [OutputType([PSCustomObject[]])]
    param (
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [System.Management.Automation.Language.ScriptBlockAst]$ScriptBlockAst
    )
    process {
        try {
            $ScriptBlock = {
                $args[0] -is [System.Management.Automation.Language.FunctionDefinitionAst] -and $args[0].Name -cmatch '[A-Z]{2,}'
            }
            $functions = $ScriptBlockAst.FindAll( $ScriptBlock , $true )
            foreach ( $function in $functions ) {
                [PSCustomObject]@{
                    Message  = "Avoid function names with adjacent caps in their name"
                    Extent   = $function.Extent
                    RuleName = $PSCmdlet.MyInvocation.InvocationName
                    Severity = "Warning"
                }#pscustomobject
            }#foreach
            $ScriptBlock = {
                $args[0] -is [System.Management.Automation.Language.FunctionDefinitionAst] -and $args[0].Name -match '[a-z]{2,}\-[a-z]{2,}'
            }
            $functions = $ScriptBlockAst.FindAll( $ScriptBlock , $true )
            foreach ( $function in $functions ) {
                [PSCustomObject]@{
                    Message  = "Function names should contain a capital letter as the first letter"
                    Extent   = $function.Extent
                    RuleName = $PSCmdlet.MyInvocation.InvocationName
                    Severity = "Warning"
                }#pscustomobject
            }#foreach
        
        }#try
        
        catch {
            $PSCmdlet.ThrowTerminatingError( $_ )
        }
    
    }#process
    
}#function