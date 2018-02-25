function New-ArmorApiToken {
    <#
        .SYNOPSIS
        Creates an authentication token from an authorization code.

        .DESCRIPTION
        { required: more detailed description of the function's purpose }

        .INPUTS
        System.String

        .NOTES
        Troy Lindsay
        Twitter: @troylindsay42
        GitHub: tlindsay42

        .EXAMPLE
        New-ArmorApiToken -Code 'HJTX3gAAAAN2q1UP7cvFtOh1qffrfWIpKetdnIgvOfpJRSC5W7b3vVqMBn8pZHtRY8I4nLRzW95gdWPdRMVUrgsnJ2mwqB8kgxOu8lhH1LOggfwrRCvxLGvGmwET59gIzJ60rxpEdM0dTLw58kNnWVbaQI1NmPQJwjvD/1RIPTnOL5d+z29wyJ/BI/POlPKNlVfHsJGYJl8ql0/3D3czNGhXCqfV20Uj0r8EX7zsQz/9t1YCqKKj9OpPv3sypXS6h4hNb/v4yLD33G+EnwOajJQ62sA='

        .LINK
        http://armorpowershell.readthedocs.io/en/latest/index.html

        .LINK
        https://github.com/tlindsay42/ArmorPowerShell

        .LINK
        https://docs.armor.com/display/KBSS/Post+Token

        .LINK
        https://developer.armor.com/#!/Authentication/TenantOAuth_TokenAsync
    #>

    [CmdletBinding()]
    [OutputType( [PSCustomObject] )]
    param (
        <#
        Specifies the temporary authorization code to redeem for a token.
        #>
        [Parameter(
            Mandatory = $true,
            Position = 0,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true
        )]
        [ValidateNotNullorEmpty()]
        [String]
        $Code,

        <#
        Specifies the type of permission.
        #>
        [Parameter( Position = 1 )]
        [ValidateSet( 'authorization_code' )]
        [String]
        $GrantType = 'authorization_code',

        <#
        Specifies the API version for this request.
        #>
        [Parameter( Position = 2 )]
        [ValidateSet( 'v1.0' )]
        [String]
        $ApiVersion = $Global:ArmorSession.ApiVersion
    )

    begin {
        $function = $MyInvocation.MyCommand.Name

        Write-Verbose -Message "Beginning: '${function}'."
    } # End of begin

    process {
        [PSCustomObject] $return = $null

        $resources = Get-ArmorApiData -Endpoint $function -ApiVersion $ApiVersion

        $uri = New-ArmorApiUriString -Endpoints $resources.Uri

        $body = Format-ArmorApiJsonRequestBody -BodyKeys $resources.Body.Keys -Parameters ( Get-Command -Name $function ).Parameters.Values

        $results = Submit-ArmorApiRequest -Uri $uri -Method $resources.Method -Body $body -Description $resources.Description

        $results = Select-ArmorApiResult -Results $results -Filter $resources.Filter

        $return = $results

        $return
    } # End of process

    end {
        Write-Verbose -Message "Ending: '${function}'."
    } # End of end
} # End of function
