function Connect-Armor {
    <#
        .SYNOPSIS
        This cmdlet connects to Armor and establishes a session.

        .DESCRIPTION
        This cmdlet connects to the Armor RESTful API and supplies credentials
        to the method.  The Armor API then returns a unique, temporary
        authorization code, which is then converted into a token to represent
        the user's credentials for subsequent calls.  Last, the account context
        is set.  If an account ID is not specified, one is automatically
        selected from the list of authorized account IDs.  Returns the session
        details which are stored in the variable: $Global:ArmorSession.

        .INPUTS
        None- you cannot pipe objects to this cmdlet.

        .NOTES
        Troy Lindsay
        Twitter: @troylindsay42
        GitHub: tlindsay42

        .EXAMPLE
        Connect-Armor

        PowerShell credential request
        Enter your credentials.
        User: your.email.address@your.company.com
        Password for user your.email.address@your.company.com: ****************


        User                   : {your.email.address@your.company.com}
        Accounts               : {Your Company Account 1, Your Company Account 2}
        Departments            : {Department 1, Department 2}
        Permissions            : {@{1=System.Object[]}
        Features               : {1, 1, 1, 1...}
        Server                 : api.armor.com
        Port                   : 443
        SessionLengthInSeconds : 1800
        SessionStartTime       : 10/3/17 1:21:22 PM
        SessionExpirationTime  : 10/3/17 1:51:33 PM
        ApiVersion             : v1.0


        Description
        -----------
        Logs into the Armor API with the default parameters and the username
        and password entered at the prompts.

        .EXAMPLE
        $pscredential = Get-Credential
        
        PowerShell credential request
        Enter your credentials.
        User: your.email.address@your.company.com
        Password for user your.email.address@your.company.com: ****************
        
        PS C:\>Connect-Armor -Credential $pscredential
        ...

        PS C:\>$Global:ArmorSession

        User                   : {your.email.address@your.company.com}
        Accounts               : {Your Company Account 1, Your Company Account 2}
        Departments            : {Department 1, Department 2}
        Permissions            : {@{1=System.Object[]}
        Features               : {1, 1, 1, 1...}
        Server                 : api.armor.com
        Port                   : 443
        SessionLengthInSeconds : 1800
        SessionStartTime       : 10/3/17 1:21:22 PM
        SessionExpirationTime  : 10/3/17 1:51:33 PM
        ApiVersion             : v1.0


        Description
        -----------
        Logs into the Armor API with the credentials stored in the
        $pscredential object, and then outputs the session details.

        .EXAMPLE
        $session = Connect-Armor -Credential $pscredential -AccountID 12345

        PS C:\>$session -eq $Global:ArmorSession
        True


        Description
        -----------
        Logs into the Armor API with the credentials defined in the
        $pscredential object, sets the account context to '12345', stores the
        returned session details in the $session variable, and then compares
        the value to the value of $Global:ArmorSession, which are equal.

        .EXAMPLE
        Connect-Armor -Credential $pscredential -ApiVersion 'v1.0' | Out-Null

        PS C:\>$Global:ArmorSession.ApiVersion
        v1.0


        Description
        -----------
        Logs into the Armor API with the credentials defined in the
        $pscredential object with the specified API version, and discards the
        output by piping it to Out-Null.  The API version defined by this
        cmdlet, either implicitly or explicitly, defines the default API
        version for the session, which is stored in
        $Global:ArmorSession.ApiVersion.

        .EXAMPLE
        Connect-Armor -Credential $pscredential -Server 'localhost' -Port 8443 |
            Out-Null


        Description
        -----------
        Logs into a test/dev Armor API instance with the credentials defined in
        the $pscredential object, and discards the output by piping it to
        Out-Null.

        .LINK
        http://armorpowershell.readthedocs.io/en/latest/cmd_connect.html#connect-armor

        .LINK
        https://github.com/tlindsay42/ArmorPowerShell

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
    #>

    [CmdletBinding()]
    [OutputType( [ArmorSession] )]
    param (
        <#
        Your Armor API username and password.  If not supplied as a parameter,
        you will be prompted for your credentials.
        #>
        [Parameter( Position = 0 )]
        [ValidateNotNull()]
        [PSCredential]
        $Credential = ( Get-Credential ),

        <#
        Specifies the Armor account ID to use for all subsequent requests.
        The permitted range is 1-65535.
        #>
        [Parameter( Position = 1 )]
        [ValidateRange( 1, 65535 )]
        [UInt16]
        $AccountID = 0,

        <#
        Specifies the Armor API server IP address or FQDN.
        #>
        [Parameter( Position = 2 )]
        [ValidateNotNullorEmpty()]
        [String]
        $Server = 'api.armor.com',

        <#
        Specifies the Armor API server listening TCP port.  The permitted range
        is: 1-65535.
        #>
        [Parameter( Position = 3 )]
        [ValidateRange( 1, 65535 )]
        [UInt16]
        $Port = 443,

        <#
        Specifies the API version for this request.  The specified value is
        also set as the default API version for the session as a parameter of
        the session variable: '$Global:ArmorSession.ApiVersion'.

        The API version can be specified when any other public cmdlets are
        called or the value of '$Global:ArmorSession.ApiVersion' can be updated
        afterward to set a different default API version for the session.
        #>
        [Parameter( Position = 4 )]
        [ValidateSet( 'v1.0' )]
        [String]
        $ApiVersion = 'v1.0'
    )

    begin {
        $function = $MyInvocation.MyCommand.Name

        Write-Verbose -Message "Beginning: '${function}'."
    } # End of begin

    process {
        [ArmorSession] $return = $null

        Write-Verbose -Message 'Storing all session details in $Global:ArmorSession.'
        [ArmorSession] $Global:ArmorSession = [ArmorSession]::New( $Server, $Port, $ApiVersion )

        $resources = Get-ArmorApiData -FunctionName $function -ApiVersion $Global:ArmorSession.ApiVersion

        $uri = New-ArmorApiUriString -Endpoints $resources.Uri

        switch ( $Global:ArmorSession.ApiVersion ) {
            'v1.0' {
                $body = @{
                    $resources.Body.UserName = $Credential.UserName
                    $resources.Body.Password = $Credential.GetNetworkCredential().Password
                } |
                    ConvertTo-Json -ErrorAction 'Stop'
            }

            Default {
                throw "Unknown API version number: '${ApiVersion}'."
            }
        }

        $content = Submit-ArmorApiRequest -Uri $uri -Method $resources.Method -Body $body -Description $resources.Description

        # Destroy variables with passwords since they are no longer needed
        $body = ''
        Remove-Variable -Name 'Credential'
        Remove-Variable -Name 'body'

        # If we find a temporary authorization code and a success message, we know the request was successful
        if ( $content.Code.Length -gt 0 -and $content.Success -eq 'true' ) {
            Write-Verbose -Message "Successfully acquired temporary authorization code: '$( $content.Code )'"

            $token = New-ArmorApiToken -Code $content.Code -GrantType 'authorization_code'
        }
        else {
            throw 'Failed to obtain temporary authorization code.'
        }

        # Final throw for when all versions of the API have failed
        if ( $token -eq $null ) {
            throw 'Unable to acquire authorization token. Check $Error for details or use the -Verbose parameter.'
        }

        $Global:ArmorSession.Authorize( $token.Access_Token, $token.Expires_In )

        Get-ArmorIdentity |
            Out-Null

        if ( $AccountID -eq 0 ) {
            $AccountID = $Global:ArmorSession.Accounts.ID |
                Select-Object -First 1

            if ( $AccountID -eq 0 ) {
                throw 'Failed to get the default Armor account ID.'
            }
        }

        Write-Verbose -Message "Setting the Armor account context ID to: '${AccountID}'."
        Set-ArmorAccountContext -ID $AccountID |
            Out-Null

        $return = $Global:ArmorSession

        $return
    } # End of process

    end {
        Write-Verbose -Message "Ending: '${function}'."
    } # End of end
} # End of function
