function Deny-PlusEqual {
    [cmdletbinding()]
    [OutputType([pscustomobject[]])]
    param (
        [parameter( Mandatory )]
        [ValidateNotNullOrEmpty()]
        [System.Management.Automation.Language.ScriptblockAst]$ScriptblockAst
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
        }
        catch {
            $PSCmdlet.ThrowTerminatingError( $_ )
        }
    }
}