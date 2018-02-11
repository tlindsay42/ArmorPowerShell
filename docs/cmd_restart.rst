Restart Commands
=========================
This page contains details on **Restart** commands.

Restart-ArmorCompleteVM
-------------------------

NAME
    Restart-ArmorCompleteVM
    
SYNOPSIS
    This cmdlet gracefully reboots virtual machines.
    
    
SYNTAX
    Restart-ArmorCompleteVM [-ID] <UInt16> [[-ApiVersion] <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
    
    
DESCRIPTION
    The specified virtual machine will be gracefully rebooted in the Armor
    Complete account in context.  VMware Tools or open-vm-tools must be
    installed and running for this request to succeed.
    
    See also: Reset-ArmorCompleteVM
    

PARAMETERS
    -ID <UInt16>
        Specifies the ID of the Armor Complete virtual machine that you want to
        gracefully reboot.
        
    -ApiVersion <String>
        Specifies the API version for this request.
        
    -WhatIf [<SwitchParameter>]
        
    -Confirm [<SwitchParameter>]
        
    <CommonParameters>
        This cmdlet supports the common parameters: Verbose, Debug,
        ErrorAction, ErrorVariable, WarningAction, WarningVariable,
        OutBuffer, PipelineVariable, and OutVariable. For more information, see 
        about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216). 
    
    -------------------------- EXAMPLE 1 --------------------------
    
    PS C:\>{required: show one or more examples using the function}
    
    
    
    
    
    
REMARKS
    To see the examples, type: "get-help Restart-ArmorCompleteVM -examples".
    For more information, type: "get-help Restart-ArmorCompleteVM -detailed".
    For technical information, type: "get-help Restart-ArmorCompleteVM -full".
    For online help, type: "get-help Restart-ArmorCompleteVM -online"



