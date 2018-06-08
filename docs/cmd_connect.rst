Connect Commands
=========================
This page contains details on **Connect** commands.

Connect-Armor
-------------------------

NAME
    Connect-Armor
    
SYNOPSIS
    Connects to the Armor API and establishes a session.
    
    
SYNTAX
    Connect-Armor [[-Credential] <PSCredential>] [[-AccountID] <UInt16>] [[-Server] <String>] [[-Port] <UInt16>] [[-ApiVersion] <String>] [<CommonParameters>]
    
    
DESCRIPTION
    Connects to the Armor RESTful API and supplies credentials to the method.  The
    Armor API then returns a unique, temporary authorization code, which is then
    converted into a token to represent the user's credentials for subsequent
    calls.  Last, the account context is set.  If an account ID is not specified,
    one is automatically selected from the list of authorized account IDs.  Returns
    the session details which are stored in the variable: $Global:ArmorSession.
    

PARAMETERS
    -Credential <PSCredential>
        Your Armor API username and password.  If not supplied as a parameter, you will
        be prompted for your credentials.
        
    -AccountID <UInt16>
        Specifies the Armor account ID to use for all subsequent requests.  The
        permitted range is 1-65535.
        
    -Server <String>
        Specifies the Armor API server IP address or FQDN.
        
    -Port <UInt16>
        Specifies the Armor API server listening TCP port.  The permitted range is:
        1-65535.
        
    -ApiVersion <String>
        Specifies the API version for this request.  The specified value is also set as
        the default API version for the session as a parameter of the session variable:
        '$Global:ArmorSession.ApiVersion'.
        
        The API version can be specified when any other public cmdlets are called or
        the value of '$Global:ArmorSession.ApiVersion' can be updated afterward to set
        a different default API version for the session.
        
    <CommonParameters>
        This cmdlet supports the common parameters: Verbose, Debug,
        ErrorAction, ErrorVariable, WarningAction, WarningVariable,
        OutBuffer, PipelineVariable, and OutVariable. For more information, see 
        about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216). 
    
    -------------------------- EXAMPLE 1 --------------------------
    
    PS C:\>Connect-Armor
    
    Prompts for the username and password, and then attempts to log into the Armor
    API.
    
    
    
    
    -------------------------- EXAMPLE 2 --------------------------
    
    PS C:\>Connect-Armor -Credential $pscredential
    
    Attempts to log into the Armor API with the credentials stored in the
    $pscredential object.
    
    
    
    
    -------------------------- EXAMPLE 3 --------------------------
    
    PS C:\>Connect-Armor -Credential $pscredential -AccountID 12345
    
    Attempts to log into the Armor API with the credentials stored in the
    $pscredential object, and sets the account context to '12345'.
    
    
    
    
    -------------------------- EXAMPLE 4 --------------------------
    
    PS C:\>Connect-Armor -Credential $pscredential -ApiVersion 'v1.0'
    
    Attempts to log into the Armor API with the credentials stored in the $pscredential object and sets the specified API version as the default for the session, which is stored in $Global:ArmorSession.ApiVersion.
    
    
    
    
    -------------------------- EXAMPLE 5 --------------------------
    
    PS C:\>Connect-Armor -Credential $pscredential -Server 'localhost' -Port 8443
    
    Attempts to log into a local test/dev Armor API instance listening on port
    8443/tcp with the credentials stored in the $pscredential object.
    
    
    
    
REMARKS
    To see the examples, type: "get-help Connect-Armor -examples".
    For more information, type: "get-help Connect-Armor -detailed".
    For technical information, type: "get-help Connect-Armor -full".
    For online help, type: "get-help Connect-Armor -online"



