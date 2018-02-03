function Get-ArmorIdentity {
    <#
        .SYNOPSIS
        Return information about the current authenticated user, including account membership and permissions.

        .DESCRIPTION
        { required: more detailed description of the function's purpose }

        .NOTES
        Troy Lindsay
        Twitter: @troylindsay42
        GitHub: tlindsay42

        .PARAMETER ApiVersion
        The API version.  The default value is $Global:ArmorSession.ApiVersion.

        .INPUTS
        None
            You cannot pipe objects to Get-ArmorAccount.

        .OUTPUTS
        System.Collections.Hashtable

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

        $uri = New-ArmorApiUriString -Endpoints $resources.Uri

        $results = Submit-ArmorApiRequest -Uri $uri -Method $resources.Method -Description $resources.Description

        $Global:ArmorSession.User = $results.User
        $Global:ArmorSession.Accounts = $results.Accounts
        $Global:ArmorSession.Departments = $results.Departments
        $Global:ArmorSession.Permissions = $results.Permissions
        $Global:ArmorSession.Features = $results.Features

        $return = $Global:ArmorSession

        $return
    } # End of process

    end {
        Write-Verbose -Message ( 'Ending {0}.' -f $function )
    } # End of end
} # End of function
