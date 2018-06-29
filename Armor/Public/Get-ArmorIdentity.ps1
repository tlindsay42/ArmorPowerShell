function Get-ArmorIdentity {
    <#
        .SYNOPSIS
        Retrieves identity details about your Armor user account.

        .DESCRIPTION
        Retrieves details about your Armor user account that you used to establish the
        session, including account membership and permissions.

        This also updates the identity information in the session variable:
        $Global:ArmorSession.

        .INPUTS
        None- this function does not accept pipeline inputs.

        .NOTES
        - Troy Lindsay
        - Twitter: @troylindsay42
        - GitHub: tlindsay42

        .EXAMPLE
        Get-ArmorIdentity
        Retrieves the identity details about your Armor user account.

        .EXAMPLE
        Get-ArmorIdentity -ApiVersion 1.0
        Retrieves the Armor API version 1.0 identity details about your Armor user
        account.

        .LINK
        https://tlindsay42.github.io/ArmorPowerShell/public/Get-ArmorIdentity/

        .LINK
        https://github.com/tlindsay42/ArmorPowerShell/blob/master/Armor/Public/Get-ArmorIdentity.ps1

        .LINK
        https://docs.armor.com/display/KBSS/Get+Authenticated+User+Info

        .LINK
        https://developer.armor.com/#!/Authentication/Me_GetMeAsync

        .COMPONENT
        Armor API

        .FUNCTIONALITY
        Armor account management
    #>

    [CmdletBinding()]
    [OutputType( [ArmorSession] )]
    param (
        # Specifies the API version for this request.
        [Parameter( Position = 0 )]
        [ValidateSet( 'v1.0', 'internal' )]
        [String]
        $ApiVersion = $Global:ArmorSession.ApiVersion
    )

    begin {
        $function = $MyInvocation.MyCommand.Name

        Write-Verbose -Message "Beginning: '${function}' with ParameterSetName '$( $PSCmdlet.ParameterSetName )' and Parameters: $( $PSBoundParameters | Out-String )"

        Test-ArmorSession
    }

    process {
        [ArmorSession] $return = $null
        [ArmorSessionUser[]] $temp = @()

        $resources = Get-ArmorApiData -FunctionName $function -ApiVersion $ApiVersion

        $uri = New-ArmorApiUri -Endpoints $resources.Endpoints

        $splat = @{
            Uri         = $uri
            Method      = $resources.Method
            SuccessCode = $resources.SuccessCode
        }
        $results = Submit-ArmorApiRequest @splat

        $temp = $results.User
        $Global:ArmorSession.User = $temp |
            Select-Object -First 1
        $Global:ArmorSession.Accounts = $results.Accounts
        $Global:ArmorSession.Departments = $results.Departments
        $Global:ArmorSession.Permissions = $results.Permissions
        $Global:ArmorSession.Features = $results.Features

        $return = $Global:ArmorSession

        $return
    }

    end {
        Write-Verbose -Message "Ending: '${function}'."
    }
}
