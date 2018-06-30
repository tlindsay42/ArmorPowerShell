function Get-ArmorCompleteWorkloadTier {
    <#
        .SYNOPSIS
        Retrieves tiers in an Armor Complete workload.

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
        System.UInt16

        .INPUTS
        System.String

        .INPUTS
        System.Management.Automation.PSObject

        .NOTES
        - Troy Lindsay
        - Twitter: @troylindsay42
        - GitHub: tlindsay42

        .EXAMPLE
        Get-ArmorCompleteWorkloadTier -WorkloadID 1
        Retrieves the details for all workload tiers in the workload with WorkloadID=1
        in the Armor Complete account that currently has context.

        .EXAMPLE
        Get-ArmorCompleteWorkloadTier -WorkloadID 1 -ID 1
        Retrieves the details for the workload tier with ID=1 in the workload with
        WorkloadID=1.

        .EXAMPLE
        Get-ArmorCompleteWorkloadTier -WorkloadID 1 -Name 'Database'
        Retrieves the details for the workload tier with Name='Database' in the
        workload with WorkloadID=1.

        .EXAMPLE
        2, 3 | Get-ArmorCompleteWorkloadTier -ApiVersion 'v1.0'
        Retrieves the API version 1.0 details for all of the workload tiers in
        workloads with WorkloadID=2 and WorkloadID=3 via pipeline values.

        .EXAMPLE
        [PSCustomObject] @{ WorkloadID = 1; ID = 1 } | Get-ArmorCompleteWorkloadTier
        Retrieves the details for the workload tier with ID=1 in the workload with
        WorkloadID=1 via property names in the pipeline.

        .EXAMPLE
        [PSCustomObject] @{ WorkloadID = 1; Name = 'Presentation' } | Get-ArmorCompleteWorkloadTier
        Retrieves the details for the workload tier with Name='Presentation' in the
        workload with WorkloadID=1 via property names in the pipeline.

        .LINK
        https://tlindsay42.github.io/ArmorPowerShell/public/Get-ArmorCompleteWorkloadTier/

        .LINK
        https://github.com/tlindsay42/ArmorPowerShell/blob/master/Armor/Public/Get-ArmorCompleteWorkloadTier.ps1

        .LINK
        https://docs.armor.com/display/KBSS/Get+Tiers

        .LINK
        https://docs.armor.com/display/KBSS/Get+Tier

        .LINK
        https://developer.armor.com/#!/Infrastructure/Tier_GetAppTiers

        .LINK
        https://developer.armor.com/#!/Infrastructure/Tier_Get

        .COMPONENT
        Armor Complete

        .FUNCTIONALITY
        Armor Complete infrastructure management
    #>

    [CmdletBinding( DefaultParameterSetName = 'ID' )]
    [OutputType( [ArmorCompleteWorkloadTier[]] )]
    [OutputType( [ArmorCompleteWorkloadTier] )]
    param (
        # Specifies the ID of the workload that contains the tier(s).
        [Parameter(
            Mandatory = $true,
            HelpMessage = 'Please enter the ID of the Armor Complete workload that contains the tiers that you want to retrieve',
            Position = 0,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true
        )]
        [ValidateRange( 1, 65535 )]
        [UInt16]
        $WorkloadID,

        # Specifies the ID of the workload tier.
        [Parameter(
            ParameterSetName = 'ID',
            Position = 1,
            ValueFromPipelineByPropertyName = $true
        )]
        [ValidateRange( 1, 65535 )]
        [UInt16]
        $ID = 0,

        # Specifies the names of the workload tiers.
        [Parameter(
            ParameterSetName = 'Name',
            Position = 1,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true
        )]
        [ValidateNotNullOrEmpty()]
        [SupportsWildcards()]
        [String]
        $Name = '',

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

        if ( $PSCmdlet.ParameterSetName -eq 'ID' -and $ID -gt 0 ) {
            $uri = New-ArmorApiUri -Endpoints $resources.Endpoints -IDs $WorkloadID, $ID
        }
        else {
            $uri = New-ArmorApiUri -Endpoints $resources.Endpoints -IDs $WorkloadID
        }

        $keys = ( $resources.Query | Get-Member -MemberType 'NoteProperty' ).Name
        $parameters = ( Get-Command -Name $function ).Parameters.Values
        $uri = New-ArmorApiUriQuery -Keys $keys -Parameters $parameters -Uri $uri

        $splat = @{
            Uri         = $uri
            Method      = $resources.Method
            SuccessCode = $resources.SuccessCode
        }
        $results = Submit-ArmorApiRequest @splat

        $filters = $resources.Filter |
            Get-Member -MemberType 'NoteProperty'
        $results = Select-ArmorApiResult -Results $results -Filters $filters

        if ( $results.Count -eq 0 -and $PSCmdlet.ParameterSetName -eq 'Name' ) {
            Write-Error -Message "Armor workload tier not found: Name: '${Name}'."
        }
        else {
            $return = $results
        }

        $return
    }

    end {
        Write-Verbose -Message "Ending: '${function}'."
    }
}
