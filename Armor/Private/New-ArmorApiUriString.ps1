function New-ArmorApiUriString {
    <#
        .SYNOPSIS
        The New-ArmorApiUriString function is used to build a valid URI.

        .DESCRIPTION
        { required: more detailed description of the function's purpose }

        .NOTES
        Troy Lindsay
        Twitter: @troylindsay42
        GitHub: tlindsay42

        .PARAMETER Server
        The Armor API server IP address or FQDN.  The default value is $Global:ArmorSession.Server.

        .PARAMETER Port
        The Armor API server port.  The default value is $Global:ArmorSession.Port.

        .PARAMETER Endpoints
        An array of available endpoint paths.

        .PARAMETER ID
        An array of positional ID values to be inserted into the path.

        .INPUTS
        None
            You cannot pipe objects to New-ArmorApiUriString.

        .OUTPUTS
        System.String

        .LINK
        https://github.com/tlindsay42/ArmorPowerShell

        .LINK
        https://docs.armor.com/display/KBSS/Armor+API+Guide

        .LINK
        https://developer.armor.com/

        .EXAMPLE
        New-ArmorApiUriString -Server 'api.armor.com' -Port 443 -Endpoint '/auth/authorize'
        This will return 'https://api.armor.com:443/auth/authorize'.
    #>

    [CmdletBinding()]
    param (
        [Parameter( Position = 0 )]
        [ValidateNotNullOrEmpty()]
        [String] $Server = $Global:ArmorSession.Server,
        [Parameter( Position = 1 )]
        [ValidateRange( 0, 65535 )]
        [UInt16] $Port = $Global:ArmorSession.Port,
        [Parameter( Position = 2 )]
        [ValidateNotNull()]
        [String[]] $Endpoints = @(),
        [Parameter( Position = 3 )]
        [ValidateNotNull()]
        [UInt16[]] $IDs = @()
    )

    begin {
        $function = $MyInvocation.MyCommand.Name

        Write-Verbose -Message ( 'Beginning {0}.' -f $function )
    } # End of begin

    process {
        $return = $null

        Write-Verbose -Message 'Build the URI.'

        # Reset for instances where $ID was set with a null string
        if ( $IDs.Count -eq 1 ) {
            if ( $IDs[0] -eq 0 ) {
                $IDs = @()
            }
        }

        switch ( $IDs.Count ) {
            0 {
                $endpoint = $Endpoints.Where( { $_ -notmatch '{id}' } )

                if ( $endpoint.Count -eq 0 ) {
                    throw 'Endpoint with no ID specification not found.'
                }
                elseif ( $endpoint.Count -ne 1 ) {
                    throw 'More than one endpoint with no ID specification found.'
                }

                $return = 'https://{0}:{1}{2}' -f $Server, $Port, $endpoint[0]
            }

            1 {
                $endpoint = $Endpoints.Where( { $_ -match '/{id}' } )

                if ( $endpoint.Count -eq 0 ) {
                    throw 'Endpoint with one ID specification not found.'
                }
                elseif ( $endpoint.Count -ne 1 ) {
                    throw 'More than one endpoint with one ID specification found.'
                }

                $return = 'https://{0}:{1}{2}' -f $Server, $Port, $endpoint[0]

                if ( $IDs[0].Length -gt 0 ) {
                    # Insert ID in URI string
                    $return = $return -replace '{id}', $IDs[0]
                }
                else {
                    throw ( 'Invalid ID value for endpoint: {0}.' -f $endpoint[0] )
                }
            }

            2 {
                $endpoint = $Endpoints.Where( { $_ -match '/{id}.*/{id}' } )

                if ( $endpoint.Count -eq 0 ) {
                    throw 'Endpoint with two ID specifications not found.'
                }
                elseif ( $endpoint.Count -ne 1 ) {
                    throw 'More than one endpoint with two ID specifications found.'
                }

                $return = 'https://{0}:{1}{2}' -f $Server, $Port, $endpoint[0]

                if ( $IDs[0].Length -gt 0 -and $IDs[1].Length -gt 0 ) {
                    # Insert first ID in URI string
                    $return = $return -replace '(.*?)/{id}(.*)', ( '$1/{0}$2' -f $IDs[0] )

                    # Insert second ID in URI string
                    $return = $return -replace '{id}', $IDs[1]
                }
                else {
                    throw ( 'Invalid ID value for endpoint: {0}.' -f $endpoint[0] )
                }
            }

            Default {
                throw 'Unsupported number of ID values in endpoint.'
            }
        }

        Write-Verbose -Message ( 'URI = {0}' -f $return )
            
        $return
    } # End of process

    end {
        Write-Verbose -Message ( 'Ending {0}.' -f $function )
    } # End of end
} # End of function
