function New-ArmorApiUriQuery {
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
        http://armorpowershell.readthedocs.io/en/latest/index.html

        .LINK
        https://github.com/tlindsay42/ArmorPowerShell/blob/master/Armor/Private/New-ArmorApiUriQuery.ps1

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
        [Parameter(
            Mandatory = $true,
            Position = 0
        )]
        [AllowEmptyCollection()]
        [AllowNull()]
        [String[]]
        $Keys,

        <#
        Specifies the parameters available within the calling cmdlet.
        #>
        [Parameter(
            Mandatory = $true,
            Position = 1
        )]
        [ValidateCount( 1, 65535 )]
        [ValidateNotNullOrEmpty()]
        [PSCustomObject[]]
        $Parameters,

        <#
        Specifies the endpoint's URI.
        #>
        [Parameter(
            Mandatory = $true,
            Position = 2
        )]
        [ValidateScript( { $_ -match 'https://.+/\w+' } )]
        [String]
        $Uri
    )

    begin {
        $function = $MyInvocation.MyCommand.Name

        Write-Verbose -Message "Beginning: '${function}'."
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
        foreach ( $key in $Keys ) {
            <#
            Walk through all of the parameters defined in the function.  Both
            the parameter name and parameter alias are used to match against a
            query option.   It is suggested to make the parameter name "human
            friendly" and set an alias corresponding to the query option name.
            #>
            foreach ( $parameter in $Parameters ) {
                $parameterValue = ( Get-Variable -Name $parameter.Name ).Value

                <#
                If the parameter name matches the query option name or one of
                its aliases, build a query string.
                #>
                if ( $parameter.Name -eq $key -or $parameter.Aliases -contains $key ) {
                    if ( $parameterValue.Length -gt 0 ) {
                        $queryString += $key + '=' + $parameterValue
                    }
                    else {
                        Write-Verbose -Message "Parameter: '$( $parameter.Name )' = `$null"
                    }
                }
            }
        }

        <#
        After all query options are exhausted, build a new URI with all defined
        query options.
        #>
        if ( $queryString.Count -gt 0 ) {
            $return += '?' + ( $queryString -join '&' )

            Write-Verbose -Message "URI = ${return}"
        }

        $return
    } # End of process

    end {
        Write-Verbose -Message "Ending: '${function}'."
    } # End of end
} # End of function
