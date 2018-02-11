function Get-ArmorCompleteDatacenter {
    <#
        .SYNOPSIS
        This cmdlet retrieves Armor Complete datacenters.

        .DESCRIPTION
        This cmdlet retrieves details about the Armor Complete datacenters,
        regions, and compute zones.  Returns a set of datacenters that
        correspond to the filter criteria provided by the cmdlet parameters.


        .INPUTS
        System.UInt16

        System.String

        .NOTES
        Troy Lindsay
        Twitter: @troylindsay42
        GitHub: tlindsay42

        .EXAMPLE
        {required: show one or more examples using the function}

        .LINK
        https://github.com/tlindsay42/ArmorPowerShell

        .LINK
        https://docs.armor.com/display/KBSS/Armor+API+Guide

        .LINK
        https://developer.armor.com/
    #>

    [CmdletBinding( DefaultParameterSetName = 'ID' )]
    [OutputType( 'ArmorCompleteDatacenter[]' )]
    param (
        <#
        Specifies the ID of the Armor Complete datacenter.
        #>
        [Parameter(
            ParameterSetName = 'ID',
            Position = 0,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true
        )]
        [ValidateSet( 1, 2, 3, 4, 5 )]
        [UInt16]
        $ID = 0,

        <#
        Specifies the name of the Armor Complete region.
        #>
        [Parameter(
            ParameterSetName = 'Name',
            ValueFromPipelineByPropertyName = $true
        )]
        [ValidateSet( 'AS East', 'EU Central', 'EU West', 'US Central', 'US West' )]
        [String]
        $Name = '',

        <#
        Specifies the name of the Armor Complete datacenter.
        #>
        [Parameter(
            ParameterSetName = 'Location',
            Position = 0,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true
        )]
        [ValidateSet( 'AMS01', 'DFW01', 'LHR01', 'PHX01', 'SIN01' )]
        [String]
        $Location = '',

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

        Write-Verbose -Message ( 'Beginning {0}.' -f $function )

        Test-ArmorSession
    } # End of begin

    process {
        [ArmorCompleteDatacenter[]] $return = $null

        $resources = Get-ArmorApiData -Endpoint $function -ApiVersion $ApiVersion

        $uri = New-ArmorApiUriString -Endpoints $resources.Uri

        $uri = New-ArmorApiUriQueryString -QueryKeys $resources.Query.Keys -Parameters ( Get-Command -Name $function ).Parameters.Values -Uri $uri

        $results = Submit-ArmorApiRequest -Uri $uri -Method $resources.Method -Description $resources.Description

        $results = Select-ArmorApiResult -Results $results -Filter $resources.Filter

        if ( $results.Count -eq 0 ) {
            Write-Host -Object 'Armor Complete datacenter not found.'
        }
        else {
            $return = $results
        }

        $return
    } # End of process

    end {
        Write-Verbose -Message ( 'Ending {0}.' -f $function )
    } # End of end
} # End of function
