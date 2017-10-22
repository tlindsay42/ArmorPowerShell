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
        Your username and password stored in a PSCredential object for authenticating to the Armor API.
        
    -AccountID <UInt16>
        The Armor account ID to use for all subsequent requests.
        
    -Server <String>
        The Armor API server IP address or FQDN.  The default value is 'api.armor.com'.
        
    -Port <UInt16>
        The Armor API server port.  The default value is '443'.
        
    -ApiVersion <String>
        The API version.  The default value is 'v1.0'.
        
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




