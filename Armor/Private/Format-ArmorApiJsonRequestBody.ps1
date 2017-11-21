function Format-ArmorApiJsonRequestBody {
    <#
        .SYNOPSIS
        Helper function used to create a valid body payload.

        .DESCRIPTION
        { required: more detailed description of the function's purpose }

        .NOTES
        Troy Lindsay
        Twitter: @troylindsay42
        GitHub: tlindsay42

        .PARAMETER BodyKeys
        All of the body options available to the endpoint.

        .PARAMETER Parameters
        All of the parameter options available within the parent function.

        .INPUTS
        None
            You cannot pipe objects to Format-ArmorApiJsonRequestBody.

        .OUTPUTS
        System.String

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
        [Parameter( Position = 0 )]
        [String[]] $BodyKeys = $null,
        [Parameter( Position = 1 )]
        [ValidateNotNullorEmpty()]
        $Parameters = $null
    )

    begin {
        $function = $MyInvocation.MyCommand.Name

        Write-Verbose -Message ( 'Beginning {0}.' -f $function )

        $excludedParameters = @(
            'ApiVersion',
            'Verbose',
            'Debug',
            'ErrorAction',
            'WarningAction',
            'InformationAction',
            'ErrorVariable',
            'WarningVariable',
            'InformationVariable',
            'OutVariable',
            'OutBuffer',
            'PipelineVariable'
        )
    } # End of begin

    process {
        if ( $resources.Method -eq 'Get' ) {
            return $null
        }

        # Inventory all invoked parameters
        $setParameters = $PSCmdlet.MyInvocation.BoundParameters

        Write-Verbose -Message ( 'List of set parameters: {0}.' -f ( $setParameters.Values.Name.Where( { $_ -notin $excludedParameters } ) -join ', ' ) )

        Write-Verbose -Message 'Build the body parameters.'

        $bodyString = @{}

        # Walk through all of the available body options presented by the endpoint
        # Note: Keys are used to search in case the value changes in the future across different API versions
        foreach ( $bodyKey in $BodyKeys ) {
            Write-Verbose -Message ( 'Adding {0}...' -f $bodyKey )

            $bodyKeyNoUnderscore = $bodyKey -replace '_', ''

            # Array Object
            if ( $resources.Body.$bodyKey.GetType().BaseType.Name -eq 'Array' ) {
                $arraystring = @{}

                foreach ( $arrayItem in $resources.Body.$bodyKey.Keys ) {
                    # Walk through all of the parameters defined in the function
                    # Both the parameter name and parameter alias are used to match against a body option
                    # It is suggested to make the parameter name "human friendly" and set an alias corresponding to the body option name
                    foreach ( $parameter in $Parameters.Where( { $_.Name -notin $excludedParameters } ) ) {
                        # if the parameter name or alias matches the body option name, build a body string
                        if ( $parameter.Name -eq $arrayItem -or $parameter.Aliases -eq $arrayItem) {
                            # Switch variable types
                            if ( ( Get-Variable -Name $parameter.Name ).Value.GetType().Name -eq 'SwitchParameter' ) {
                                $arraystring.Add( $arrayItem, ( Get-Variable -Name $parameter.Name ).Value.IsPresent )
                            }
                            # All other variable types
                            elseif ( ( Get-Variable -Name $parameter.Name ).Value -ne $null ) {
                                $arraystring.Add( $arrayItem, ( Get-Variable -Name $parameter.Name ).Value )
                            }
                        }
                    }
                }

                $bodyString.Add( $bodyKey, @( $arraystring ) )
            }
            # Non-Array Object
            else {
                # Walk through all of the parameters defined in the function
                # Both the parameter name and parameter alias are used to match against a body option
                # It is suggested to make the parameter name "human friendly" and set an alias corresponding to the body option name
                foreach ( $parameter in $Parameters.Where( { $_.Name -notin $excludedParameters } ) ) {
                    # if the parameter name or alias matches the body option name, build a body string
                    if (
                        ( $parameter.Name -eq $bodyKey -or $parameter.Aliases -contains $bodyKey ) -and
                        $parameter.Name -in $setParameters.Values.Name.Where( { $_ -notin $excludedParameters } )
                    ) {
                        # Switch variable types
                        if ( ( Get-Variable -Name $parameter.Name ).Value.GetType().Name -eq 'SwitchParameter' ) {
                            $bodyString.Add( $bodyKey, ( Get-Variable -Name $parameter.Name ).Value.IsPresent )
                        }
                        # All other variable types
                        elseif ( ( Get-Variable -Name $parameter.Name ).Value -ne $null -and ( Get-Variable -Name $parameter.Name ).Value.Length -gt 0 ) {
                            $bodyString.Add( $bodyKey, ( Get-Variable -Name $parameter.Name ).Value )
                        }
                    }
                    elseif (
                        ( $parameter.Name -eq $bodyKeyNoUnderscore -or $parameter.Aliases -contains $bodyKeyNoUnderscore ) -and
                        $parameter.Name -in $setParameters.Values.Name.Where( { $_ -notin $excludedParameters } )
                    ) {
                        # Switch variable types
                        if ( ( Get-Variable -Name $parameter.Name ).Value.GetType().Name -eq 'SwitchParameter' ) {
                            $bodyString.Add( $bodyKey, ( Get-Variable -Name $parameter.Name ).Value.IsPresent )
                        }
                        # All other variable types
                        elseif ( ( Get-Variable -Name $parameter.Name ).Value -ne $null -and ( Get-Variable -Name $parameter.Name ).Value.Length -gt 0 ) {
                            $bodyString.Add( $bodyKey, ( Get-Variable -Name $parameter.Name ).Value )
                        }
                    }
                }
            }
        }

        # Store the results in a JSON string
        $bodyString = ConvertTo-Json -InputObject $bodyString

        Write-Verbose -Message ( 'Body = {0}' -f $bodyString )

        return $bodyString
    } # End of process

    end {
        Write-Verbose -Message ( 'Ending {0}.' -f $function )
    } # End of end
} # End of function
