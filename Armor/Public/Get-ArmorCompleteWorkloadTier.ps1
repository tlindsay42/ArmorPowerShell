function Get-ArmorCompleteWorkloadTier {
    <#
        .SYNOPSIS
        This cmdlet retrieves the tiers in an Armor Complete workload.

        .DESCRIPTION
        Workloads and tiers are logical grouping tools for helping you
        organize your virtual machines and corresponding resources in your
        Armor Complete software-defined datacenters.

        Workloads contain tiers, and tiers contain virtual machines.

        Workloads are intended to help you describe the business function of a
        group of servers, such as 'My Secure Website', which could be useful
        for chargeback or showback to your customers, as well as helping your
        staff and the Armor Support teams understand the architecture of your
        environment.

        Tiers are intended to describe the application tiers within each
        workload.  A typical three tiered application workload is comprised
        of presentation, business logic, and persistence tiers.  Common labels
        for each are: web, application, and database respectively, but you can
        group your VMs however you choose.

        Returns a set of tiers in a workload that correspond to the filter
        criteria provided by the cmdlet parameters.

        .INPUTS
        UInt16

        String

        PSCustomObject

        .NOTES
        Troy Lindsay
        Twitter: @troylindsay42
        GitHub: tlindsay42

        .EXAMPLE
        {required: show one or more examples using the function}

        .LINK
        http://armorpowershell.readthedocs.io/en/latest/cmd_get.html#get-armorcompleteworkloadtier

        .LINK
        https://github.com/tlindsay42/ArmorPowerShell

        .LINK
        https://docs.armor.com/display/KBSS/Get+Tiers

        .LINK
        https://docs.armor.com/display/KBSS/Get+Tier

        .LINK
        https://developer.armor.com/#!/Infrastructure/Tier_GetAppTiers

        .LINK
        https://developer.armor.com/#!/Infrastructure/Tier_Get
    #>

    [CmdletBinding( DefaultParameterSetName = 'ID' )]
    [OutputType( [PSCustomObject[]] )]
    param (
        <#
        Specifies the ID of the Armor Complete workload that contains the
        tier(s).
        #>
        [Parameter(
            Mandatory = $true,
            HelpMessage = 'Please enter the ID of the Armor Complete workload that contains the tiers that you want to retrieve',
            Position = 0,
            ValueFromPipelineByPropertyName = $true
        )]
        [ValidateRange( 1, 65535 )]
        [UInt16]
        $WorkloadID,

        <#
        Specifies the IDs of the tiers in the Armor Complete that you want to
        retrieve.
        #>
        [Parameter(
            ParameterSetName = 'ID',
            Position = 1,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true
        )]
        [ValidateRange( 1, 65535 )]
        [UInt16]
        $ID = 0,

        <#
        Specifies the names of the tiers in the Armor Complete that you want to
        retrieve.  Wildcard searches are permitted.
        #>
        [Parameter(
            ParameterSetName = 'Name',
            Position = 1,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true
        )]
        [ValidateNotNullOrEmpty()]
        [String]
        $Name = '',

        <#
        Specifies the API version for this request.
        #>
        [Parameter( Position = 2 )]
        [ValidateSet( 'v1.0' )]
        [String]
        $ApiVersion = $Global:ArmorSession.ApiVersion
    )

    begin {
        $function = $MyInvocation.MyCommand.Name

        Write-Verbose -Message "Beginning: '${function}'."

        Test-ArmorSession
    } # End of begin

    process {
        [PSCustomObject[]] $return = $null

        $resources = Get-ArmorApiData -FunctionName $function -ApiVersion $ApiVersion

        if ( $PsCmdlet.ParameterSetName -eq 'ID' -and $ID -gt 0 ) {
            $uri = New-ArmorApiUri -Endpoints $resources.Endpoints -IDs $WorkloadID, $ID
        }
        else {
            $uri = New-ArmorApiUri -Endpoints $resources.Endpoints -IDs $WorkloadID
        }

        $keys = ( $resources.Query | Get-Member -MemberType 'NoteProperty' ).Name
        $parameters = ( Get-Command -Name $function ).Parameters.Values
        $uri = New-ArmorApiUriQuery -Keys $keys -Parameters $parameters -Uri $uri

        $results = Submit-ArmorApiRequest -Uri $uri -Method $resources.Method -Body $body -Description $resources.Description

        $filters = ( $resources.Filter | Get-Member -MemberType 'NoteProperty' ).Name
        $results = Select-ArmorApiResult -Results $results -Filters $filters

        if ( $results.Count -eq 0 ) {
            Write-Host -Object 'Armor workload tier not found.'
        }
        else {
            $return = $results
        }

        $return
    } # End of process

    end {
        Write-Verbose -Message "Ending: '${function}'."
    } # End of end
} # End of function
