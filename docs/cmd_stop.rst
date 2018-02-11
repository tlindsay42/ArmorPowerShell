Stop Commands
=========================
This page contains details on **Stop** commands.

Stop-ArmorCompleteVM
-------------------------

NAME
    Stop-ArmorCompleteVM
    
SYNOPSIS
    This cmdlet powers off Armor Complete virtual machines.
    
    
SYNTAX
    Stop-ArmorCompleteVM [-ID] <UInt16> [[-Type] <String>] [[-ApiVersion] <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
    
    
DESCRIPTION
    The specified virtual machine in the Armor Complete account in context
    will be powered off.
    

PARAMETERS
    -ID <UInt16>
        Specifies the ID of the Armor Complete virtual machine that you want
        to stop.
        
    -Type <String>
        Specifies how you want to stop the Armor Complete virtual machine.
        
        Types:
        
        - Shutdown initiates a graceful shutdown of the operating system.
          VMware Tools or open-vm-tools must be installed and running for this
          request to succeed.  This the recommend way to stop your VMs.
        
        - Off initiates a hard shutdown of the VM- effectively disconnecting
          the virtual power cord from the VM.  This shutdown method has the
          potential to cause data corruption and should only be used when
          necessary.
        
        - ForceOff should not be used.  It breaks the state of the environment
          by marking the VM as powered off in the Armor Management Portal (AMP)
          and vCloud Director, but leaves the VM running in vSphere.
        
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
    To see the examples, type: "get-help Stop-ArmorCompleteVM -examples".
    For more information, type: "get-help Stop-ArmorCompleteVM -detailed".
    For technical information, type: "get-help Stop-ArmorCompleteVM -full".
    For online help, type: "get-help Stop-ArmorCompleteVM -online"



