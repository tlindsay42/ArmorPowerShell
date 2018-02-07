Invoke Commands
=========================
This page contains details on **Invoke** commands.

Invoke-ArmorWebRequest
-------------------------

NAME
    Invoke-ArmorWebRequest
    
SYNOPSIS
    { required: high level overview }
    
    
SYNTAX
    Invoke-ArmorWebRequest [[-Endpoint] <String>] [[-Headers] <Hashtable>] [[-Method] <String>] [[-Body] <String>] [[-SuccessCode] <UInt16>] [[-Description] <String>] [<CommonParameters>]
    
    
DESCRIPTION
    { required: more detailed description of the function's purpose }
    

PARAMETERS
    -Endpoint <String>
        Specifies the Armor API endpoint.
        
    -Headers <Hashtable>
        Specifies the headers of the Armor API web request.
        
    -Method <String>
        Specifies the method used for the Armor API web request.  The permitted
        values are:
        - Delete
        - Get
        - Patch
        - Post
        - Put
        
    -Body <String>
        Specifies the body of the Armor API web request.  This parameter is
        ignored for Get requests.
        
    -SuccessCode <UInt16>
        Specifies the value of the HTTP response code that indicates success
        for this Armor API web request.
        
    -Description <String>
        If the PowerShell $ConfirmPreference value is elevated for this Armor
        API web request by setting the -Confirm parameter to $true, this
        specifies the text to display at the user prompt.
        
    <CommonParameters>
        This cmdlet supports the common parameters: Verbose, Debug,
        ErrorAction, ErrorVariable, WarningAction, WarningVariable,
        OutBuffer, PipelineVariable, and OutVariable. For more information, see 
        about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216). 
    
    -------------------------- EXAMPLE 1 --------------------------
    
    PS C:\>{required: show one or more examples using the function}
    
    
    
    
    
    
REMARKS
    To see the examples, type: "get-help Invoke-ArmorWebRequest -examples".
    For more information, type: "get-help Invoke-ArmorWebRequest -detailed".
    For technical information, type: "get-help Invoke-ArmorWebRequest -full".
    For online help, type: "get-help Invoke-ArmorWebRequest -online"



