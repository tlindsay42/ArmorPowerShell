Reset Commands
=========================
This page contains details on **Reset** commands.

Reset-ArmorCompleteVM
-------------------------

NAME
    Reset-ArmorCompleteVM
    
SYNOPSIS
    Resets Armor Complete virtual machines.
    
    
SYNTAX
    Reset-ArmorCompleteVM [-ID] <UInt16> [[-ApiVersion] <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
    
    
DESCRIPTION
    The specified virtual machine in the Armor Complete account in context will be
    hard reset- effectively disconnecting the virtual power cord from the VM,
    plugging it back in, and then powering it back on.  This reboot method has the
    potential to cause data corruption and should only be used when necessary.
    
    See also: Restart-ArmorCompleteVM
    

PARAMETERS
    -ID <UInt16>
        Specifies the ID of the Armor Complete virtual machine that you want to power
        off & on.
        
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
    
    PS C:\>Reset-ArmorCompleteVM -ID 1
    
    If confirmed, powers off & on the Armor Complete VM with ID=1.
    
    
    
    
    -------------------------- EXAMPLE 2 --------------------------
    
    PS C:\>1 | Reset-ArmorCompleteVM -Confirm:$false
    
    Powers off & on the Armor Complete VM with ID=1 via pipeline value.
    
    
    
    
    -------------------------- EXAMPLE 3 --------------------------
    
    PS C:\>Get-ArmorVM -ID 1 | Reset-ArmorCompleteVM -Confirm:$false
    
    Powers off & on the Armor Complete VM with ID=1 via property name in the
    pipeline without confirmation.
    
    
    
    
REMARKS
    To see the examples, type: "get-help Reset-ArmorCompleteVM -examples".
    For more information, type: "get-help Reset-ArmorCompleteVM -detailed".
    For technical information, type: "get-help Reset-ArmorCompleteVM -full".
    For online help, type: "get-help Reset-ArmorCompleteVM -online"



