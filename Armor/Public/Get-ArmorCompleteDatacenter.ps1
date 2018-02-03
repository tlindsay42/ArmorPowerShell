function Get-ArmorCompleteDatacenter {
    <#
        .SYNOPSIS
        { required: high level overview }

        .DESCRIPTION
        { required: more detailed description of the function's purpose }

        .NOTES
        Troy Lindsay
        Twitter: @troylindsay42
        GitHub: tlindsay42

        .PARAMETER Name
        { required: description of the specified input parameter's purpose }

        .PARAMETER Location
        { required: description of the specified input parameter's purpose }

        .PARAMETER ID
        { required: description of the specified input parameter's purpose }

        .PARAMETER ApiVersion
        The API version.  The default value is $Global:ArmorSession.ApiVersion.

        .INPUTS
        None
            You cannot pipe objects to Get-ArmorLocation.

        .OUTPUTS
        { required: .NET Framework object types that the cmdlet returns and a description of the returned objects }

        .LINK
        https://github.com/tlindsay42/ArmorPowerShell

        .LINK
        https://docs.armor.com/display/KBSS/Armor+API+Guide

        .LINK
        https://developer.armor.com/

        .EXAMPLE
        {required: show one or more examples using the function}
    #>

    [CmdletBinding()]
    param (
        [String] $Name = '',
        [Parameter( Position = 0 )]
        [String] $Location = '',
        [ValidateRange( 1, 5 )]
        [UInt16] $ID = 0,
        [Parameter( Position = 1 )]
        [ValidateSet( 'v1.0' )]
        [String] $ApiVersion = $Global:ArmorSession.ApiVersion
    )

    begin {
        $function = $MyInvocation.MyCommand.Name

        Write-Verbose -Message ( 'Beginning {0}.' -f $function )

        Test-ArmorSession
    } # End of begin

    process {
        $return = $null

        Write-Verbose -Message ( 'Gather API Data for {0}.' -f $function )
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
