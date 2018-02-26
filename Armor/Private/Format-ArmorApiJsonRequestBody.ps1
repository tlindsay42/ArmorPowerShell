function Format-ArmorApiJsonRequestBody {
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
        https://github.com/tlindsay42/ArmorPowerShell

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
        $BodyKeys = $null,

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
    } # End of begin

    process {
        [String] $return = $null

        if ( $resources.Method -ne 'Get' ) {
            # Inventory all invoked parameters
            $setParameters = $PSCmdlet.MyInvocation.BoundParameters.Values.Name.Where( { $_ -notin $excludedParameters } )

            Write-Verbose -Message "List of set parameters: $( $setParameters -join ', ' )."

            Write-Verbose -Message 'Build the body parameters.'

            $bodyString = @{}

            <#
            Walk through all of the available body options presented by the endpoint
            Note: Keys are used to search in case the value changes in the future across different API versions
            #>
            foreach ( $bodyKey in $BodyKeys ) {
                Write-Verbose -Message "Adding ${bodyKey}..."

                $bodyKeyNoUnderscore = $bodyKey -replace '_', ''

                # Array Object
                if ( $resources.Body.$bodyKey.GetType().BaseType.Name -eq 'Array' ) {
                    $arraystring = @{}

                    foreach ( $arrayItem in $resources.Body.$bodyKey.Keys ) {
                        <#
                        Walk through all of the parameters defined in the function
                        Both the parameter name and parameter alias are used to match against a body option
                        It is suggested to make the parameter name "human friendly" and set an alias corresponding to the body option name
                        #>
                        foreach ( $parameter in $Parameters.Where( { $_.Name -notin $excludedParameters } ) ) {
                            # if the parameter name or alias matches the body option name, build a body string
                            if ( $parameter.Name -eq $arrayItem -or $parameter.Aliases -eq $arrayItem) {
                                $parameter = Get-Variable -Name $parameter.Name

                                # Switch variable types
                                if ( $parameterObject.Value.GetType().Name -eq 'SwitchParameter' ) {
                                    $arraystring.Add( $arrayItem, $parameterObject.Value.IsPresent )
                                }

                                # All other variable types
                                elseif ( $parameterObject.Value -ne $null ) {
                                    $arraystring.Add( $arrayItem, $parameterObject.Value )
                                }
                            }
                        }
                    }

                    $bodyString.Add( $bodyKey, @( $arraystring ) )
                }
                # Non-Array Object
                else {
                    <#
                    Walk through all of the parameters defined in the function
                    Both the parameter name and parameter alias are used to match against a body option
                    It is suggested to make the parameter name "human friendly" and set an alias corresponding to the body option name
                    #>
                    foreach ( $parameter in $Parameters.Where( { $_.Name -notin $excludedParameters } ) ) {
                        $parameterObject = Get-Variable -Name $parameter.Name

                        # if the parameter name or alias matches the body option name, build a body string
                        if (
                            ( $parameter.Name -eq $bodyKey -or $parameter.Aliases -contains $bodyKey ) -and
                            $parameter.Name -in $setParameters
                        ) {
                            # Switch variable types
                            if ( $parameterObject.Value.GetType().Name -eq 'SwitchParameter' ) {
                                $bodyString.Add( $bodyKey, $parameterObject.Value.IsPresent )
                            }
                            # All other variable types
                            elseif ( $parameterObject.Value -ne $null -and $parameterObject.Value.Length -gt 0 ) {
                                $bodyString.Add( $bodyKey, $parameterObject.Value )
                            }
                        }
                        elseif (
                            ( $parameter.Name -eq $bodyKeyNoUnderscore -or $parameter.Aliases -contains $bodyKeyNoUnderscore ) -and
                            $parameter.Name -in $setParameters
                        ) {
                            # Switch variable types
                            if ( $parameterObject.Value.GetType().Name -eq 'SwitchParameter' ) {
                                $bodyString.Add( $bodyKey, $parameterObject.Value.IsPresent )
                            }
                            # All other variable types
                            elseif ( $parameterObject.Value -ne $null -and $parameterObject.Value.Length -gt 0 ) {
                                $bodyString.Add( $bodyKey, $parameterObject.Value )
                            }
                        }
                    }
                }
            }

            # Store the results in a JSON string
            $return = ConvertTo-Json -InputObject $bodyString -ErrorAction 'Stop'

            Write-Verbose -Message "Body = ${return}"
        }

        $return
    } # End of process

    end {
        Write-Verbose -Message "Ending: '${function}'."
    } # End of end
} # End of function
