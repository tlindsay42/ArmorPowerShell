function Get-ArmorCompleteWorkload {
    <#
        .SYNOPSIS
        This cmdlet retrieves Armor Complete workloads.

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

        Returns a set of workloads that correspond to the filter criteria
        provided by the cmdlet parameters.

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
        http://armorpowershell.readthedocs.io/en/latest/cmd_get.html#get-armorcompleteworkload

        .LINK
        https://github.com/tlindsay42/ArmorPowerShell/blob/master/Armor/Public/Get-ArmorCompleteWorkload.ps1

        .LINK
        https://docs.armor.com/display/KBSS/Get+Workloads

        .LINK
        https://docs.armor.com/display/KBSS/Get+Workload

        .LINK
        https://developer.armor.com/#!/Infrastructure/App_GetAppList

        .LINK
        https://developer.armor.com/#!/Infrastructure/App_GetAppDetail
    #>

    [CmdletBinding( DefaultParameterSetName = 'ID' )]
    [OutputType( [ArmorCompleteWorkload[]] )]
    [OutputType( [ArmorCompleteWorkload] )]
    param (
        <#
        Specifies the ID of the Armor Complete workload.
        #>
        [Parameter(
            ParameterSetName = 'ID',
            Position = 0,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true
        )]
        [ValidateRange( 1, 65535 )]
        [UInt16]
        $ID = 0,

        <#
        Specifies the name of the Armor Complete workload.  Wildcard searches
        are permitted.
        #>
        [Parameter(
            ParameterSetName = 'Name',
            Position = 0,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true
        )]
        [AllowEmptyString()]
        [SupportsWildcards()]
        [String]
        $Name,

        <#
        Specifies the API version for this request.
        #>
        [Parameter( Position = 1 )]
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
        [ArmorCompleteWorkload[]] $return = $null

        $resources = Get-ArmorApiData -FunctionName $function -ApiVersion $ApiVersion

        if ( $PSCmdlet.ParameterSetName -eq 'ID' -and $ID -gt 0 ) {
            $uri = New-ArmorApiUri -Endpoints $resources.Endpoints -IDs $ID
        }
        else {
            $uri = New-ArmorApiUri -Endpoints $resources.Endpoints
        }

        $keys = ( $resources.Query | Get-Member -MemberType 'NoteProperty' ).Name
        $parameters = ( Get-Command -Name $function ).Parameters.Values
        $uri = New-ArmorApiUriQuery -Keys $keys -Parameters $parameters -Uri $uri

        $splat = @{
            'Uri'         = $uri
            'Method'      = $resources.Method
            'SuccessCode' = $resources.SuccessCode
            'Description' = $resources.Description
        }
        $results = Submit-ArmorApiRequest @splat

        $filters = $resources.Filter |
            Get-Member -MemberType 'NoteProperty'
        $results = Select-ArmorApiResult -Results $results -Filters $filters

        if ( $results.Count -eq 0 -and $PSCmdlet.ParameterSetName -eq 'Name' ) {
            Write-Error -Message "Armor workload not found: Name: '${Name}'."
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
