function Remove-ArmorCompleteWorkload {
    <#
        .SYNOPSIS
        Deletes Armor Complete workloads.

        .DESCRIPTION
        The specified workload in the Armor Complete account in context will be deleted
        if is empty.

        .INPUTS
        UInt16

        PSCustomObject

        .NOTES
        - Troy Lindsay
        - Twitter: @troylindsay42
        - GitHub: tlindsay42

        .EXAMPLE
        Remove-ArmorCompleteWorkload -ID 1
        If confirmed and empty of child objects, deletes workload with ID=1.

        .EXAMPLE
        1 | Remove-ArmorCompleteWorkload
        If confirmed and empty of child objects, deletes workload with ID=1 identified
        via pipeline value.

        .EXAMPLE
        [PSCustomObject] @{ 'ID' = 1 | Remove-ArmorCompleteWorkload
        If confirmed and empty of child objects, deletes workload with ID=1 identified
        via property name in the pipeline.

        .LINK
        https://tlindsay42.github.io/ArmorPowerShell/public/Remove-ArmorCompleteWorkload/

        .LINK
        https://github.com/tlindsay42/ArmorPowerShell/blob/master/Armor/Public/Remove-ArmorCompleteWorkload.ps1

        .LINK
        https://docs.armor.com/display/KBSS/Delete+Workload

        .LINK
        https://developer.armor.com/#!/Infrastructure/App_DeleteApp

        .COMPONENT
        Armor Complete

        .FUNCTIONALITY
        Armor Complete infrastructure management
    #>

    [CmdletBinding( SupportsShouldProcess = $true, ConfirmImpact = 'High' )]
    [OutputType( [ArmorCompleteWorkload[]] )]
    [OutputType( [ArmorCompleteWorkload] )]
    param (
        # Specifies the ID of the Armor Complete workload.
        [Parameter(
            Mandatory = $true,
            Position = 0,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true
        )]
        [ValidateRange( 1, 65535 )]
        [UInt16]
        $ID,

        # Specifies the API version for this request.
        [Parameter( Position = 1 )]
        [ValidateSet( 'v1.0', 'internal' )]
        [String]
        $ApiVersion = $Global:ArmorSession.ApiVersion
    )

    begin {
        $function = $MyInvocation.MyCommand.Name

        Write-Verbose -Message "Beginning: '${function}' with ParameterSetName '$( $PSCmdlet.ParameterSetName )' and Parameters: $( $PSBoundParameters | Out-String )"

        Test-ArmorSession
    }

    process {
        [ArmorCompleteWorkload[]] $return = $null

        $resources = Get-ArmorApiData -FunctionName $function -ApiVersion $ApiVersion

        if ( $PSCmdlet.ShouldProcess( $ID, $resources.Description ) ) {
            $uri = New-ArmorApiUri -Endpoints $resources.Endpoints -IDs $ID

            $keys = ( $resources.Body | Get-Member -MemberType 'NoteProperty' ).Name
            $parameters = ( Get-Command -Name $function ).Parameters.Values
            $body = Format-ArmorApiRequestBody -Keys $keys -Parameters $parameters

            $splat = @{
                'Uri'         = $uri
                'Method'      = $resources.Method
                'Body'        = $body
                'SuccessCode' = $resources.SuccessCode
            }
            $results = Submit-ArmorApiRequest @splat

            $return = $results
        }

        $return
    }

    end {
        Write-Verbose -Message "Ending: '${function}'."
    }
}
