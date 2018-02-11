function New-ArmorApiUriQueryString {
    <#
        .SYNOPSIS
        This cmdlet is used to build a valid URI query string.

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
        Specifies the query filters available to the endpoint.
        #>
        [Parameter( Position = 0 )]
        [AllowEmptyCollection()]
        [String[]]
        $QueryKeys = @(),

        <#
        Specifies the parameters available within the calling cmdlet.
        #>
        [Parameter( Position = 1 )]
        [ValidateNotNullOrEmpty()]
        [String[]]
        $Parameters = @(),

        <#
        Specifies the endpoint's URI.
        #>
        [Parameter( Position = 2 )]
        [ValidateNotNullOrEmpty()]
        [String]
        $Uri = ''
    )

    begin {
        $function = $MyInvocation.MyCommand.Name

        Write-Verbose -Message ( 'Beginning {0}.' -f $function )
    } # End of begin

    process {
        [String] $return = $Uri

        Write-Verbose -Message 'Build the query parameters.'

        $queryString = @()

        <#
        Walk through all of the available query options presented by the
        endpoint.

        Note: Keys are used to search in case the value changes in the future
        across different API versions.
        #>
        foreach ( $query in $QueryKeys ) {
            <#
            Walk through all of the parameters defined in the function.  Both
            the parameter name and parameter alias are used to match against a
            query option.   It is suggested to make the parameter name "human
            friendly" and set an alias corresponding to the query option name.
            #>
            foreach ( $parameter in $Parameters ) {
                $parameterValue = ( Get-Variable -Name $parameter.Name ).Value

                <#
                If the parameter name matches the query option name, build a
                query string.
                #>
                if ( $parameter.Name -eq $query ) {
                    if ( $resources.Query[$parameter.Name] -and $parameterValue ) {
                        $queryString += '{0}={1}' -f $resources.Query[$parameter.Name], $parameterValue
                    }
                }
                <#
                If the parameter alias matches the query option name, build a
                query string.
                #>
                elseif ( $parameter.Aliases -eq $query ) {
                    if ( $resources.Query[$parameter.Aliases] -and $parameterValue ) {
                        $queryString += '{0}={1}' -f $resources.Query[$parameter.Aliases], $parameterValue
                    }
                }
            }
        }

        <#
        After all query options are exhausted, build a new URI with all defined
        query options.
        #>
        if ( $queryString.Count -gt 0 ) {
            $return += '?{0}' -f ( $queryString -join '&' )

            Write-Verbose -Message ( 'URI = {0}' -f $return )
        }

        $return
    } # End of process

    end {
        Write-Verbose -Message ( 'Ending {0}.' -f $function )
    } # End of end
} # End of function
