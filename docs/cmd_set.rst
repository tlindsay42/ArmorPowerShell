Set Commands
=========================
This page contains details on **Set** commands.

Set-ArmorAccountContext
-------------------------

NAME
    Set-ArmorAccountContext
    
SYNOPSIS
    Sets the Armor Anywhere or Armor Complete account context.
    
    
SYNTAX
    Set-ArmorAccountContext [-ID] <UInt16> [<CommonParameters>]
    
    
DESCRIPTION
    If your user account has access to more than one Armor Anywhere and/or Armor
    Complete accounts, this cmdlet allows you to update the context, so that all
    future requests reference the specified account.
    

PARAMETERS
    -ID <UInt16>
        Specifies which Armor account should be used for the context of all
        subsequent requests.
        
    <CommonParameters>
        This cmdlet supports the common parameters: Verbose, Debug,
        ErrorAction, ErrorVariable, WarningAction, WarningVariable,
        OutBuffer, PipelineVariable, and OutVariable. For more information, see 
        about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216). 
    
    -------------------------- EXAMPLE 1 --------------------------
    
    PS C:\>Set-ArmorAccountContext -ID 1
    
    Set the account context to the specified account ID so that all subsequent
    commands reference that account.
    
    
    
    
    -------------------------- EXAMPLE 2 --------------------------
    
    PS C:\>2 | Set-ArmorAccountContext
    
    Set the account context to 2 via the value in the pipeline.
    
    
    
    
    -------------------------- EXAMPLE 3 --------------------------
    
    PS C:\>Get-ArmorAccount -ID 3 | Set-ArmorAccountContext
    
    Set the account context to 3 via the ID property name in the pipeline.
    
    
    
    
REMARKS
    To see the examples, type: "get-help Set-ArmorAccountContext -examples".
    For more information, type: "get-help Set-ArmorAccountContext -detailed".
    For technical information, type: "get-help Set-ArmorAccountContext -full".
    For online help, type: "get-help Set-ArmorAccountContext -online"



