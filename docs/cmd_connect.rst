Connect Commands
=========================
This page contains details on **Connect** commands.

Connect-Armor
-------------------------

NAME
    Connect-Armor
    
SYNOPSIS
    This cmdlet connects to Armor and establishes a session.
    
    
SYNTAX
    Connect-Armor [[-Credential] <PSCredential>] [[-AccountID] <UInt16>] [[-Server] <String>] [[-Port] <UInt16>] [[-ApiVersion] <String>] [<CommonParameters>]
    
    
DESCRIPTION
    This cmdlet connects to the Armor RESTful API and supplies credentials
    to the method.  The Armor API then returns a unique, temporary
    authorization code, which is then converted into a token to represent
    the user's credentials for subsequent calls.  Last, the account context
    is set.  If an account ID is not specified, one is automatically
    selected from the list of authorized account IDs.  Returns the session
    details which are stored in the variable: $Global:ArmorSession.
    

PARAMETERS
    -Credential <PSCredential>
        Your Armor API username and password.  If not supplied as a parameter,
        you will be prompted for your credentials.
        
    -AccountID <UInt16>
        Specifies the Armor account ID to use for all subsequent requests.
        The permitted range is 1-65535.
        
    -Server <String>
        Specifies the Armor API server IP address or FQDN.
        
    -Port <UInt16>
        Specifies the Armor API server listening TCP port.  The permitted range
        is: 1-65535.
        
    -ApiVersion <String>
        Specifies the API version for this request.  The specified value is
        also set as the default API version for the session as a parameter of
        the session variable: '$Global:ArmorSession.ApiVersion'.
        
        The API version can be specified when any other public cmdlets are
        called or the value of '$Global:ArmorSession.ApiVersion' can be updated
        afterward to set a different default API version for the session.
        
    <CommonParameters>
        This cmdlet supports the common parameters: Verbose, Debug,
        ErrorAction, ErrorVariable, WarningAction, WarningVariable,
        OutBuffer, PipelineVariable, and OutVariable. For more information, see 
        about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216). 
    
    -------------------------- EXAMPLE 1 --------------------------
    
    PS C:\>Connect-Armor
    
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
    
    
    
    
    -------------------------- EXAMPLE 2 --------------------------
    
    PS C:\>$pscredential = Get-Credential
    
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
    
    
    
    
    -------------------------- EXAMPLE 3 --------------------------
    
    PS C:\>$session = Connect-Armor -Credential $pscredential -AccountID 12345
    
    PS C:\>$session -eq $Global:ArmorSession
    True
    
    
    Description
    -----------
    Logs into the Armor API with the credentials defined in the
    $pscredential object, sets the account context to '12345', stores the
    returned session details in the $session variable, and then compares
    the value to the value of $Global:ArmorSession, which are equal.
    
    
    
    
    -------------------------- EXAMPLE 4 --------------------------
    
    PS C:\>Connect-Armor -Credential $pscredential -ApiVersion 'v1.0' | Out-Null
    
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
    
    
    
    
    -------------------------- EXAMPLE 5 --------------------------
    
    PS C:\>Connect-Armor -Credential $pscredential -Server 'localhost' -Port 8443 |
    
    Out-Null
    
    
    Description
    -----------
    Logs into a test/dev Armor API instance with the credentials defined in
    the $pscredential object, and discards the output by piping it to
    Out-Null.
    
    
    
    
REMARKS
    To see the examples, type: "get-help Connect-Armor -examples".
    For more information, type: "get-help Connect-Armor -detailed".
    For technical information, type: "get-help Connect-Armor -full".
    For online help, type: "get-help Connect-Armor -online"



