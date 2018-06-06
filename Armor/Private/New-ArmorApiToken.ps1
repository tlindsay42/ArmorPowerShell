function New-ArmorApiToken {
    <#
        .SYNOPSIS
        Creates an authentication token from an authorization code.

        .DESCRIPTION
        { required: more detailed description of the function's purpose }

        .INPUTS
        String

        PSCustomObject

        .NOTES
        Troy Lindsay
        Twitter: @troylindsay42
        GitHub: tlindsay42

        .EXAMPLE
        New-ArmorApiToken -Code '+8oaKtcO9kuVbjUXlfnlHCY3HmXXCidHjzOBGwr+iTo='

        .LINK
        http://armorpowershell.readthedocs.io/en/latest/index.html

        .LINK
        https://github.com/tlindsay42/ArmorPowerShell/blob/master/Armor/Private/New-ArmorApiToken.ps1

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
            'Description' = $resources.Description
        }
        $results = Submit-ArmorApiRequest @splat

        $filters = $resources.Filter |
            Get-Member -MemberType 'NoteProperty'
        $results = Select-ArmorApiResult -Results $results -Filters $filters

        $return = $results

        $return
    } # End of process

    end {
        Write-Verbose -Message "Ending: '${function}'."
    } # End of end
} # End of function
