function Connect-Armor {
    <#
        .SYNOPSIS
        Connects to the Armor API and establishes a session.

        .DESCRIPTION
        Connects to the Armor RESTful API and supplies credentials to the method.  The
        Armor API then returns a unique, temporary authorization code, which is then
        converted into a token to represent the user's credentials for subsequent
        calls.  Last, the account context is set.  If an account ID is not specified,
        one is automatically selected from the list of authorized account IDs.  Returns
        the session details which are stored in the variable: $Global:ArmorSession.

        .INPUTS
        None- this function does not accept pipeline inputs.

        .NOTES
        - Troy Lindsay
        - Twitter: @troylindsay42
        - GitHub: tlindsay42

        .EXAMPLE
        Connect-Armor
        Prompts for the username and password, and then attempts to log into the Armor
        API.

        .EXAMPLE
        Connect-Armor -Credential $pscredential
        Attempts to log into the Armor API with the credentials stored in the
        $pscredential object.

        .EXAMPLE
        Connect-Armor -Credential $pscredential -AccountID 12345
        Attempts to log into the Armor API with the credentials stored in the
        $pscredential object, and sets the account context to '12345'.

        .EXAMPLE
        Connect-Armor -Credential $pscredential -ApiVersion 'v1.0'
        Attempts to log into the Armor API with the credentials stored in the $pscredential object and sets the specified API version as the default for the session, which is stored in $Global:ArmorSession.ApiVersion.

        .EXAMPLE
        Connect-Armor -Credential $pscredential -Server 'localhost' -Port 8443
        Attempts to log into a local test/dev Armor API instance listening on port
        8443/tcp with the credentials stored in the $pscredential object.

        .LINK
        https://tlindsay42.github.io/ArmorPowerShell/public/Connect-Armor/

        .LINK
        https://github.com/tlindsay42/ArmorPowerShell/blob/master/Armor/Public/Connect-Armor.ps1

        .LINK
        https://docs.armor.com/display/KBSS/Log+into+Armor+API

        .LINK
        https://docs.armor.com/display/KBSS/Post+Authorize

        .LINK
        https://docs.armor.com/display/KBSS/Post+Token

        .LINK
        https://docs.armor.com/display/KBSS/Get+Authenticated+User+Info

        .LINK
        https://developer.armor.com/#!/Authentication/TenantOAuth_AuthorizeAsync

        .LINK
        https://developer.armor.com/#!/Authentication/TenantOAuth_TokenAsync

        .LINK
        https://developer.armor.com/#!/Authentication/Me_GetMeAsync

        .COMPONENT
        Armor API

        .FUNCTIONALITY
        Armor session management
    #>

    [CmdletBinding()]
    [OutputType( [ArmorSession] )]
    param (
        <#
        Your Armor API username and password.  If not supplied as a parameter, you will
        be prompted for your credentials.
        #>
        [Parameter( Position = 0 )]
        [ValidateNotNull()]
        [PSCredential]
        $Credential = ( Get-Credential ),

        <#
        Specifies the Armor account ID to use for all subsequent requests.  The
        permitted range is 1-65535.
        #>
        [Parameter( Position = 1 )]
        [ValidateRange( 1, 65535 )]
        [UInt16]
        $AccountID = 0,

        # Specifies the Armor API server IP address or FQDN.
        [Parameter( Position = 2 )]
        [ValidateNotNullorEmpty()]
        [String]
        $Server = 'api.armor.com',

        <#
        Specifies the Armor API server listening TCP port.  The permitted range is:
        1-65535.
        #>
        [Parameter( Position = 3 )]
        [ValidateRange( 1, 65535 )]
        [UInt16]
        $Port = 443,

        <#
        Specifies the API version for this request.  The specified value is also set as
        the default API version for the session as a parameter of the session variable:
        '$Global:ArmorSession.ApiVersion'.

        The API version can be specified when any other public cmdlets are called or
        the value of '$Global:ArmorSession.ApiVersion' can be updated afterward to set
        a different default API version for the session.
        #>
        [Parameter( Position = 4 )]
        [ValidateSet( 'v1.0', 'internal' )]
        [String]
        $ApiVersion = 'v1.0'
    )

    begin {
        $function = $MyInvocation.MyCommand.Name

        Write-Verbose -Message "Beginning: '${function}' with ParameterSetName '$( $PSCmdlet.ParameterSetName )' and Parameters: $( $PSBoundParameters | Out-String )"
    }

    process {
        [ArmorSession] $return = $null

        Write-Verbose -Message 'Storing all session details in $Global:ArmorSession.'
        [ArmorSession] $Global:ArmorSession = [ArmorSession]::New( $Server, $Port, $ApiVersion )

        $resources = Get-ArmorApiData -FunctionName $function -ApiVersion $Global:ArmorSession.ApiVersion

        $uri = New-ArmorApiUri -Endpoints $resources.Endpoints

        switch ( $Global:ArmorSession.ApiVersion ) {
            'v1.0' {
                $body = @{
                    $resources.Body.UserName = $Credential.UserName
                    $resources.Body.Password = $Credential.GetNetworkCredential().Password
                } |
                    ConvertTo-Json -ErrorAction 'Stop'
            }
            'internal' {
                $body = @{
                    $resources.Body.UserName = $Credential.UserName
                    $resources.Body.Password = $Credential.GetNetworkCredential().Password
                } |
                    ConvertTo-Json -ErrorAction 'Stop'
            }
        }

        $splat = @{
            Uri         = $uri
            Method      = $resources.Method
            Body        = $body
            SuccessCode = $resources.SuccessCode
        }
        $results = Submit-ArmorApiRequest @splat

        # Destroy variables with passwords since they are no longer needed
        $body = ''
        Remove-Variable -Name 'Credential'
        Remove-Variable -Name 'body'

        # If we find a temporary authorization code and a success message, we know the request was successful
        if ( $results.Code.Length -gt 0 -and $results.Success -eq 'true' ) {
            Write-Verbose -Message "Successfully acquired temporary authorization code: '$( $results.Code )'"

            $token = New-ArmorApiToken -Code $results.Code -GrantType 'authorization_code'
        }
        else {
            throw 'Failed to obtain temporary authorization code.'
        }

        # Final throw for when all versions of the API have failed
        if ( $token -eq $null ) {
            throw 'Unable to acquire authorization token. Check $Error for details or use the -Verbose parameter.'
        }

        $Global:ArmorSession.Authorize( $token.Access_Token, $token.Expires_In )

        Get-ArmorIdentity -ErrorAction 'Stop' |
            Out-Null

        if ( $AccountID -eq 0 ) {
            $AccountID = $Global:ArmorSession.Accounts.ID |
                Select-Object -First 1
        }

        Write-Verbose -Message "Setting the Armor account context ID to: '${AccountID}'."
        Set-ArmorAccountContext -ID $AccountID -ErrorAction 'Stop' |
            Out-Null

        $return = $Global:ArmorSession

        $return
    }

    end {
        Write-Verbose -Message "Ending: '${function}'."
    }
}
