function Get-ArmorUser {
    <#
        .SYNOPSIS
        The Get-ArmorVm retrieves a list of users in your account.

        .DESCRIPTION
        { required: more detailed description of the function's purpose }

        .NOTES
        Troy Lindsay
        Twitter: @troylindsay42
        GitHub: tlindsay42

        .INPUTS
        { required: .NET Framework object types that can be piped in and a description of the input objects }

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
        <#
        Specifies the username of the Armor user account.  Wildcard searches
        are permitted.
        #>
        [Parameter( Position = 0 )]
        [ValidateNotNullOrEmpty()]
        [String] $UserName = '',

        <#
        Specifies the first name of the Armor user account.  Wildcard searches
        are permitted.
        #>
        [ValidateNotNullOrEmpty()]
        [String] $FirstName = '',

        <#
        Specifies the last name of the Armor user account.  Wildcard searches
        are permitted.
        #>
        [ValidateNotNullOrEmpty()]
        [String] $LastName = '',

        <#
        Specifies the ID of the Armor user account.
        #>
        [ValidateRange( 1, 65535 )]
        [UInt16] $ID = 0,

        <#
        Specifies the API version for this request.
        #>
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

        $resources = Get-ArmorApiData -Endpoint $function -ApiVersion $ApiVersion

        $uri = New-ArmorApiUriString -Endpoints $resources.Uri -IDs $ID

        $uri = New-ArmorApiUriQueryString -QueryKeys $resources.Query.Keys -Parameters ( Get-Command -Name $function ).Parameters.Values -Uri $uri

        $results = Submit-ArmorApiRequest -Uri $uri -Method $resources.Method -Description $resources.Description

        $results = Select-ArmorApiResult -Results $results -Filter $resources.Filter

        if ( $results.Count -eq 0 ) {
            Write-Host -Object 'Armor user not found.'
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
