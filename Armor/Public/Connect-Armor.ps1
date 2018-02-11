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



        .LINK
        https://github.com/tlindsay42/ArmorPowerShell

        .LINK
        https://docs.armor.com/display/KBSS/Armor+API+Guide

        .LINK
        https://developer.armor.com/
    #>

    [CmdletBinding()]
    [OutputType( 'ArmorSession' )]
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

        Write-Verbose -Message ( 'Beginning {0}.' -f $function )
    } # End of begin

    process {
        [ArmorSession] $return = $null

        Write-Verbose -Message 'Storing all session details in $Global:ArmorSession.'
        $Global:ArmorSession = [ArmorSession]::New( $Server, $Port, $ApiVersion )

        $resources = Get-ArmorApiData -Endpoint $function -ApiVersion $Global:ArmorSession.ApiVersion

        $uri = New-ArmorApiUriString -Endpoints $resources.Uri

        # Set the Method
        $method = $resources.Method

        # For API version v1.0, create a body with the credentials
        switch ( $Global:ArmorSession.ApiVersion ) {
            'v1.0' {
                $body = @{
                    $resources.Body.UserName = $Credential.UserName
                    $resources.Body.Password = $Credential.GetNetworkCredential().Password
                } |
                    ConvertTo-Json -ErrorAction 'Stop'
            }

            Default {
                throw ( 'Unknown API version number: {0}.' -f $Global:ArmorSession.ApiVersion )
            }
        }

        $content = Submit-ArmorApiRequest -Uri $uri -Method $method -Body $body -Description $resources.Description

        # If we find a temporary authorization code and a success message, we know the request was successful
        if ( $content.Code.Length -gt 0 -and $content.Success -eq 'true' ) {
            Write-Verbose -Message ( 'Successfully acquired temporary authorization code: {0}' -f $content.Code )

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

        if ( $AccountID -eq 0 ) {
            $AccountID = ( Get-ArmorIdentity ).Accounts.ID |
                Select-Object -First 1

            if ( $AccountID -eq 0 ) {
                throw 'Failed to get the default Armor account ID.'
            }
        }

        Write-Verbose -Message ( 'Setting the Armor account context to ID {0}.' -f $AccountID )
        Set-ArmorAccountContext -ID $AccountID |
            Out-Null

        $return = $Global:ArmorSession

        $return
    } # End of process

    end {
        Write-Verbose -Message ( 'Ending {0}.' -f $function )
    } # End of end
} # End of function
