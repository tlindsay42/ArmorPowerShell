function Get-ArmorIdentity {
    <#
        .SYNOPSIS
        This cmdlet retrieves details about your Armor user account.

        .DESCRIPTION
        This cmdlet retrieves details about your Armor user account that you
        used to establish the session.  Returns information about the current
        authenticated user, including account membership and permissions.

        This also updates the identity information in the session variable:
        $Global:ArmorSession.

        .INPUTS
        None- you cannot pipe objects to this cmdlet.

        .NOTES
        Troy Lindsay
        Twitter: @troylindsay42
        GitHub: tlindsay42

        .EXAMPLE
        {required: show one or more examples using the function}

        .LINK
        http://armorpowershell.readthedocs.io/en/latest/cmd_get.html#get-armoridentity

        .LINK
        https://github.com/tlindsay42/ArmorPowerShell

        .LINK
        https://docs.armor.com/display/KBSS/Get+Authenticated+User+Info

        .LINK
        https://developer.armor.com/#!/Authentication/Me_GetMeAsync
    #>

    [CmdletBinding()]
    [OutputType( [ArmorSession] )]
    param (
        <#
        Specifies the API version for this request.
        #>
        [Parameter( Position = 0 )]
        [ValidateSet( 'v1.0' )]
        [String]
        $ApiVersion = $Global:ArmorSession.ApiVersion
    )

    begin {
        $function = $MyInvocation.MyCommand.Name

        Write-Verbose -Message "Beginning: '${function}'."

        Test-ArmorSession
    } # End of begin

    process {
        [ArmorSession] $return = $null

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
        Write-Verbose -Message "Ending: '${function}'."
    } # End of end
} # End of function
