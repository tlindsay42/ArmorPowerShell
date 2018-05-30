function Update-ArmorApiToken {
    <#
        .SYNOPSIS
        This cmdlet reissues the authentication token.

        .DESCRIPTION
        This cmdlet reissues an authentication token and updates the variable
        storing the session details: $Global:ArmorSession.

        .INPUTS
        String

        PSCustomObject

        .NOTES
        Troy Lindsay
        Twitter: @troylindsay42
        GitHub: tlindsay42

        .EXAMPLE
        Update-ArmorApiToken -Token '2261bac252204c2ea93ed32ea1ffd3ab' -ApiVersion 'v1.0'

        .LINK
        http://armorpowershell.readthedocs.io/en/latest/index.html

        .LINK
        https://github.com/tlindsay42/ArmorPowerShell

        .LINK
        https://docs.armor.com/display/KBSS/Post+Reissue+Token

        .LINK
        https://developer.armor.com/#!/Authentication/TenantOAuth_ReissueAsync
    #>

    [CmdletBinding()]
    [OutputType( [Void] )]
    param (
        <#
        Specifies the Armor API authorization token.
        #>
        [Parameter(
            Position = 0,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true
        )]
        [ValidateNotNullorEmpty()]
        [String]
        $Token = $Global:ArmorSession.GetToken(),

        <#
        Specifies the API version for this request.
        #>
        [Parameter(
            Position = 1,
            ValueFromPipelineByPropertyName = $true
        )]
        [ValidateSet( 'v1.0' )]
        [String]
        $ApiVersion = $Global:ArmorSession.ApiVersion
    )

    begin {
        $function = $MyInvocation.MyCommand.Name

        Write-Verbose -Message "Beginning: '${function}'."
    } # End of begin

    process {
        $resources = Get-ArmorApiData -FunctionName $function -ApiVersion $ApiVersion

        $uri = New-ArmorApiUri -Endpoints $resources.Endpoints

        $keys = ( $resources.Body | Get-Member -MemberType 'NoteProperty' ).Name
        $parameters = ( Get-Command -Name $function ).Parameters.Values
        $body = Format-ArmorApiRequestBody -Keys $keys -Parameters $parameters

        $results = Submit-ArmorApiRequest -Uri $uri -Method $resources.Method -Body $body -Description $resources.Description

        $Global:ArmorSession.Authorize( $results.Access_Token, $results.Expires_In )
    } # End of process

    end {
        Write-Verbose -Message "Ending: '${function}'."
    } # End of end
} # End of function
