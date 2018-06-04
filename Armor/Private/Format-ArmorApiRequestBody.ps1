function Format-ArmorApiRequestBody {
    <#
        .SYNOPSIS
        This cmdlet is used to generate a valid request body payload.

        .DESCRIPTION
        { required: more detailed description of the function's purpose }

        .INPUTS
        None- you cannot pipe objects to this cmdlet.

        .NOTES
        Troy Lindsay
        Twitter: @troylindsay42
        GitHub: tlindsay42

        .EXAMPLE
        {required: show one or more examples using the function}

        .LINK
        http://armorpowershell.readthedocs.io/en/latest/index.html

        .LINK
        https://github.com/tlindsay42/ArmorPowerShell/blob/master/Armor/Private/Format-ArmorApiRequestBody.ps1

        .LINK
        https://docs.armor.com/display/KBSS/Armor+API+Guide

        .LINK
        https://developer.armor.com/
    #>

    [CmdletBinding()]
    [OutputType( [String] )]
    param (
        <#
        Specifies the variables available in the endpoint request body schema.
        #>
        [Parameter( Position = 0 )]
        [AllowEmptyCollection()]
        [String[]]
        $Keys = $null,

        <#
        Specifies the parameter names available within the calling cmdlet.
        #>
        [Parameter( Position = 1 )]
        [ValidateNotNullorEmpty()]
        [PSObject]
        $Parameters = $null
    )

    begin {
        $function = $MyInvocation.MyCommand.Name

        Write-Verbose -Message "Beginning: '${function}'."

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
            'PipelineVariable',
            'WhatIf',
            'Confirm'
        )

        $filteredParameters = $Parameters.Where( { $_.Name -notin $excludedParameters } )
    } # End of begin

    process {
        [String] $return = $null

        if ( $resources.Method -ne 'Get' ) {
            # Inventory all invoked parameters
            $setParameters = $PSCmdlet.MyInvocation.BoundParameters.Values.Name.Where( { $_ -notin $excludedParameters } )

            Write-Verbose -Message "List of set parameters: $( $setParameters -join ', ' )."

            Write-Verbose -Message 'Build the body parameters.'

            $body = @{}

            <#
            Walk through all of the available body options presented by the endpoint
            Note: Keys are used to search in case the value changes in the future across different API versions
            #>
            foreach ( $key in $Keys ) {
                Write-Verbose -Message "Adding ${key}..."

                $keyNoUnderscore = $key -replace '_', ''

                # Array Object
                if ( $key.GetType().BaseType.Name -eq 'Array' ) {
                    $list = @{}

                    foreach ( $item in $key ) {
                        <#
                        Walk through all of the parameters defined in the function
                        Both the parameter name and parameter alias are used to match against a body option
                        It is suggested to make the parameter name "human friendly" and set an alias corresponding to the body option name
                        #>
                        foreach ( $parameter in $filteredParameters ) {
                            # if the parameter name or alias matches the body option name, build a body string
                            if ( $parameter.Name -eq $item -or $parameter.Aliases -contains $item) {
                                $parameterValue = ( Get-Variable -Name $parameter.Name ).Value

                                if ( $parameterValue.GetType().Name -eq 'SwitchParameter' ) {
                                    $list.Add( $item, $parameterValue.IsPresent )
                                }
                                elseif ( $parameterValue.Length -gt 0 ) {
                                    $list.Add( $item, $parameterValue )
                                }
                                else {
                                    Write-Verbose -Message "Parameter: '$( $parameter.Name )' = `$null"
                                }
                            }
                        }
                    }

                    $body.Add( $key, @( $list ) )
                }
                # Non-Array Object
                else {
                    <#
                    Walk through all of the parameters defined in the function
                    Both the parameter name and parameter alias are used to match against a body option
                    It is suggested to make the parameter name "human friendly" and set an alias corresponding to the body option name
                    #>
                    foreach ( $parameter in $filteredParameters ) {
                        $parameterValue = ( Get-Variable -Name $parameter.Name ).Value

                        # if the parameter name or alias matches the body option name, build a body string
                        if (
                            $parameter.Name -in $setParameters -and (
                                $parameter.Name -eq $key -or
                                $parameter.Name -eq $keyNoUnderscore -or
                                $parameter.Aliases -contains $key -or
                                $parameter.Aliases -contains $keyNoUnderscore
                            )
                        ) {
                            # Switch variable types
                            if ( $parameterValue.GetType().Name -eq 'SwitchParameter' ) {
                                $body.Add( $key, $parameterValue.IsPresent )
                            }
                            # All other variable types
                            elseif ( $parameterValue.Length -gt 0 ) {
                                $body.Add( $key, $parameterValue )
                            }
                            else {
                                Write-Verbose -Message "Parameter: '$( $parameter.Name )' = `$null"
                            }
                        }
                    }
                }
            }

            # Store the results in a JSON string
            $return = ConvertTo-Json -InputObject $body -ErrorAction 'Stop'

            Write-Verbose -Message "Body = ${return}"
        }

        $return
    } # End of process

    end {
        Write-Verbose -Message "Ending: '${function}'."
    } # End of end
} # End of function
