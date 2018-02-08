Connect Commands
=========================
This page contains details on **Connect** commands.

Connect-Armor
-------------------------

NAME
    Connect-Armor
    
SYNOPSIS
    Connects to Armor and retrieves an authentication token.
    
    
SYNTAX
    Connect-Armor [[-Credential] <PSCredential>] [[-AccountID] <UInt16>] [[-Server] <String>] [[-Port] <UInt16>] [[-ApiVersion] <String>] [<CommonParameters>]
    
    
DESCRIPTION
    The Connect-Armor function is used to connect to the Armor RESTful API and supply credentials to the method.
    Armor then returns a unique, temporary authorization code, which must then be converted into a token to 
    represent the user's credentials for subsequent calls.
    

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
    
    PS C:\>Connect-Armor -Credential ( Get-Credential )
    
    
    
    
    
    
REMARKS
    To see the examples, type: "get-help Connect-Armor -examples".
    For more information, type: "get-help Connect-Armor -detailed".
    For technical information, type: "get-help Connect-Armor -full".
    For online help, type: "get-help Connect-Armor -online"



