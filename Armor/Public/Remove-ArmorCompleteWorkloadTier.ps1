function Remove-ArmorCompleteWorkloadTier {
    <#
        .SYNOPSIS
        Deletes tiers in an Armor Complete workload.

        .DESCRIPTION
        Workloads and tiers are logical grouping tools for helping you organize your
        virtual machines and corresponding resources in your Armor Complete
        software-defined datacenters.

        Workloads contain tiers, and tiers contain virtual machines.

        Workloads are intended to help you describe the business function of a group of
        servers, such as 'My Secure Website', which could be useful for chargeback or
        showback to your customers, as well as helping your staff and the Armor Support
        teams understand the architecture of your environment.

        Tiers are intended to describe the application tiers within each workload.  A
        typical three tiered application workload is comprised of presentation,
        business logic, and persistence tiers.  Common labels for each are: web,
        application, and database respectively, but you can group your VMs however you
        choose.

        Returns a set of tiers in a workload that correspond to the filter criteria
        provided by the cmdlet parameters.

        .INPUTS
        UInt16

        PSCustomObject

        .NOTES
        - Troy Lindsay
        - Twitter: @troylindsay42
        - GitHub: tlindsay42

        .EXAMPLE
        Remove-ArmorCompleteWorkloadTier -WorkloadID 1 -ID 1
        Deletes the workload tier with ID=1 in the workload with WorkloadID=1 in the
        Armor Complete account that currently has context.

        .EXAMPLE
        1, 2 | Remove-ArmorCompleteWorkloadTier -WorkloadID 1 -ApiVersion 'v1.0'
        Deletes the workload tiers with ID=1 and ID=2 the workload with WorkloadID=1
        using Armor API version v1.0 in the Armor Complete account that currently has
        context.

        .EXAMPLE
        [PSCustomObject] @{ 'WorkloadID' = 1; 'ID' = 1 } | Remove-ArmorCompleteWorkloadTier
        Deletes the workload tier with ID=1 in the workload with WorkloadID=1 in the
        Armor Complete account that currently has context.

        .LINK
        https://tlindsay42.github.io/ArmorPowerShell/public/Remove-ArmorCompleteWorkloadTier/

        .LINK
        https://github.com/tlindsay42/ArmorPowerShell/blob/master/Armor/Public/Remove-ArmorCompleteWorkloadTier.ps1

        .LINK
        https://docs.armor.com/display/KBSS/Delete+Tier

        .LINK
        https://developer.armor.com/#!/Infrastructure/Tier_DeleteTier

        .COMPONENT
        Armor Complete

        .FUNCTIONALITY
        Armor Complete infrastructure management
    #>

    [CmdletBinding( SupportsShouldProcess = $true, ConfirmImpact = 'High' )]
    [OutputType( [ArmorCompleteWorkloadTier] )]
    param (
        # Specifies the ID of the workload that contains the tier(s).
        [Parameter(
            Mandatory = $true,
            HelpMessage = 'Please enter the ID of the Armor Complete workload that contains the tier that will be deleted',
            Position = 0,
            ValueFromPipelineByPropertyName = $true
        )]
        [ValidateRange( 1, 65535 )]
        [UInt16]
        $WorkloadID,

        # Specifies the ID of the workload tier.
        [Parameter(
            Mandatory = $true,
            HelpMessage = 'Please enter the ID of the Armor Complete workload tier to delete',
            ParameterSetName = 'ID',
            Position = 1,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true
        )]
        [ValidateRange( 1, 65535 )]
        [UInt16]
        $ID,

        # Specifies the API version for this request.
        [Parameter( Position = 2 )]
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
        [ArmorCompleteWorkloadTier[]] $return = $null

        $resources = Get-ArmorApiData -FunctionName $function -ApiVersion $ApiVersion

        if ( $PSCmdlet.ShouldProcess( $ID, $resources.Description ) ) {
            $uri = New-ArmorApiUri -Endpoints $resources.Endpoints -IDs $WorkloadID, $ID

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

            $results = Expand-ArmorApiResult -Results $results -Location $resources.Location

            $filters = $resources.Filter |
                Get-Member -MemberType 'NoteProperty'
            $results = Select-ArmorApiResult -Results $results -Filter $filters

            $return = $results
        }

        $return
    }

    end {
        Write-Verbose -Message "Ending: '${function}'."
    }
}
