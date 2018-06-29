function New-ArmorApiToken {
    <#
        .SYNOPSIS
        Retrieves an authentication token.

        .DESCRIPTION
        Retrieves an authentication token from a temporary authorization code.

        .INPUTS
        None- this function does not accept pipeline inputs.

        .NOTES
        - Troy Lindsay
        - Twitter: @troylindsay42
        - GitHub: tlindsay42

        .EXAMPLE
        New-ArmorApiToken -Code '+8oaKtcO9kuVbjUXlfnlHCY3HmXXCidHjzOBGwr+iTo='
        Submits the temporary authorization code to retrieve a new Armor API session
        token.

        .LINK
        https://tlindsay42.github.io/ArmorPowerShell/private/New-ArmorApiToken/

        .LINK
        https://github.com/tlindsay42/ArmorPowerShell/blob/master/Armor/Private/New-ArmorApiToken.ps1

        .LINK
        https://docs.armor.com/display/KBSS/Post+Token

        .LINK
        https://developer.armor.com/#!/Authentication/TenantOAuth_TokenAsync

        .COMPONENT
        Armor API

        .FUNCTIONALITY
        Armor sessions management
    #>

    [CmdletBinding()]
    [OutputType( [PSCustomObject] )]
    param (
        # Specifies the temporary authorization code to redeem for a token.
        [Parameter(
            Mandatory = $true,
            Position = 0
        )]
        [ValidateNotNullorEmpty()]
        [String]
        $Code,

        # Specifies the type of permission.
        [Parameter( Position = 1 )]
        [ValidateSet( 'authorization_code' )]
        [String]
        $GrantType = 'authorization_code',

        # Specifies the API version for this request.
        [Parameter( Position = 2 )]
        [ValidateSet( 'v1.0', 'internal' )]
        [String]
        $ApiVersion = $Global:ArmorSession.ApiVersion
    )

    begin {
        $function = $MyInvocation.MyCommand.Name

        Write-Verbose -Message "Beginning: '${function}' with ParameterSetName '$( $PSCmdlet.ParameterSetName )' and Parameters: $( $PSBoundParameters | Out-String )"
    }

    process {
        [PSCustomObject] $return = $null

        $resources = Get-ArmorApiData -FunctionName $function -ApiVersion $ApiVersion

        $uri = New-ArmorApiUri -Endpoints $resources.Endpoints

        $keys = ( $resources.Body | Get-Member -MemberType 'NoteProperty' ).Name
        $parameters = ( Get-Command -Name $function ).Parameters.Values
        $body = Format-ArmorApiRequestBody -Keys $keys -Parameters $parameters

        $splat = @{
            'Uri'         = $uri
            'Method'      = $resources.Method
            'Body'        = $body
            'SuccessCode' = $resources.SuccessCode
        }
        $results = Submit-ArmorApiRequest @splat

        $filters = $resources.Filter |
            Get-Member -MemberType 'NoteProperty'
        $results = Select-ArmorApiResult -Results $results -Filters $filters

        $return = $results

        $return
    }

    end {
        Write-Verbose -Message "Ending: '${function}'."
    }
}
