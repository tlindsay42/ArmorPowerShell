function Get-ArmorCompleteDatacenter {
    <#
        .SYNOPSIS
        Retrieves Armor Complete datacenter details.

        .DESCRIPTION
        Retrieves details about the Armor Complete datacenters, regions, and compute
        zones.  Returns a set of datacenters that correspond to the filter criteria
        provided by the cmdlet parameters.


        .INPUTS
        UInt16

        String

        PSCustomObject

        .NOTES
        - Troy Lindsay
        - Twitter: @troylindsay42
        - GitHub: tlindsay42

        .EXAMPLE
        Get-ArmorCompleteDatacenter
        Retrieves the details for all Armor Complete datacenters.

        .EXAMPLE
        Get-ArmorCompleteDatacenter -ID 2
        Retrieves the details for the Armor Complete datacenter with ID=2.

        .EXAMPLE
        1, 'PHX01' | Get-ArmorCompleteDatacenter
        Retrieves the details for the Armor Complete datacenter with ID=1 and
        Location='PHX01' via pipeline values.

        .EXAMPLE
        [PSCustomObject] @{ Location = 'EU West' } | Get-ArmorCompleteDatacenter
        Retrieves the details for the Armor Complete datacenter with Name='EU West' via
        property name in the pipeline.

        .LINK
        https://tlindsay42.github.io/ArmorPowerShell/public/Get-ArmorCompleteDatacenter/

        .LINK
        https://github.com/tlindsay42/ArmorPowerShell/blob/master/Armor/Public/Get-ArmorCompleteDatacenter.ps1

        .LINK
        https://docs.armor.com/display/KBSS/Get+Locations

        .LINK
        https://developer.armor.com/#!/Infrastructure/Location_Get

        .COMPONENT
        Armor Complete

        .FUNCTIONALITY
        Armor Complete infrastructure management
    #>

    [CmdletBinding( DefaultParameterSetName = 'ID' )]
    [OutputType( [ArmorCompleteDatacenter[]] )]
    [OutputType( [ArmorCompleteDatacenter] )]
    param (
        # Specifies the ID of the Armor Complete datacenter.
        [Parameter(
            ParameterSetName = 'ID',
            Position = 0,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true
        )]
        [ValidateSet( 1, 2, 3, 4, 5 )]
        [UInt16]
        $ID = 0,

        # Specifies the name of the Armor Complete region.
        [Parameter(
            ParameterSetName = 'Name',
            ValueFromPipelineByPropertyName = $true
        )]
        [ValidateSet( 'AS East', 'EU Central', 'EU West', 'US Central', 'US West' )]
        [String]
        $Name = '',

        # Specifies the name of the Armor Complete datacenter.
        [Parameter(
            ParameterSetName = 'Location',
            Position = 0,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true
        )]
        [ValidateSet( 'AMS01', 'DFW01', 'LHR01', 'PHX01', 'SIN01' )]
        [String]
        $Location = '',

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
        [ArmorCompleteDatacenter[]] $return = $null

        $resources = Get-ArmorApiData -FunctionName $function -ApiVersion $ApiVersion

        $uri = New-ArmorApiUri -Endpoints $resources.Endpoints

        $keys = ( $resources.Query | Get-Member -MemberType 'NoteProperty' ).Name
        $parameters = ( Get-Command -Name $function ).Parameters.Values
        $uri = New-ArmorApiUriQuery -Keys $keys -Parameters $parameters -Uri $uri

        $splat = @{
            Uri         = $uri
            Method      = $resources.Method
            SuccessCode = $resources.SuccessCode
        }
        $results = Submit-ArmorApiRequest @splat

        if ( $PSCmdlet.ParameterSetName -ne 'ID' -or $ID -gt 0 ) {
            $filters = $resources.Filter |
                Get-Member -MemberType 'NoteProperty'

            if ( $PSCmdlet.ParameterSetName -ne 'ID' ) {
                $filters = $filters.Where( { $_.Name -ne 'ID' } )
            }

            $results = Select-ArmorApiResult -Results $results -Filters $filters
        }

        $return = $results

        $return
    }

    end {
        Write-Verbose -Message "Ending: '${function}'."
    }
}
