Rename Commands
=========================
This page contains details on **Rename** commands.

Rename-ArmorCompleteVM
-------------------------

NAME
    Rename-ArmorCompleteVM
    
SYNOPSIS
    Renames Armor Complete virtual machines.
    
    
SYNTAX
    Rename-ArmorCompleteVM [-ID] <UInt16> [-NewName] <String> [[-ApiVersion] <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
    
    
DESCRIPTION
    The specified virtual machine in the Armor Complete account in context will be
    renamed.
    

PARAMETERS
    -ID <UInt16>
        Specifies the ID of the Armor Complete virtual machine that you want to
        rename.
        
    -NewName <String>
        Specifies the new name for the Armor Complete virtual machine.
        
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
    
    PS C:\>Rename-ArmorCompleteVM -ID 1 -NewName TEST-VM
    
    Renames the VM with ID=1 to 'TEST-VM'.
    
    
    
    
    -------------------------- EXAMPLE 2 --------------------------
    
    PS C:\>[PSCustomObject] @{ 'ID' = 1; 'NewName' = 'TEST-VM' } | Rename-ArmorCompleteVM
    
    Renames the VM with ID=1 to 'TEST-VM' via property names in the pipeline.
    
    
    
    
REMARKS
    To see the examples, type: "get-help Rename-ArmorCompleteVM -examples".
    For more information, type: "get-help Rename-ArmorCompleteVM -detailed".
    For technical information, type: "get-help Rename-ArmorCompleteVM -full".
    For online help, type: "get-help Rename-ArmorCompleteVM -online"

Rename-ArmorCompleteWorkload
-------------------------
NAME
    Rename-ArmorCompleteWorkload
    
SYNOPSIS
    Renames Armor Complete workloads.
    
    
SYNTAX
    Rename-ArmorCompleteWorkload [-ID] <UInt16> [-NewName] <String> [[-ApiVersion] <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
    
    
DESCRIPTION
    The specified workload in the Armor Complete account in context will be
    renamed.
    

PARAMETERS
    -ID <UInt16>
        Specifies the ID of the Armor Complete workload that you want to rename.
        
    -NewName <String>
        Specifies the new name of the Armor Complete workload.
        
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
    
    PS C:\>Rename-ArmorCompleteWorkload -ID 1 -NewName TEST-WORKLOAD
    
    Renames the workload with ID=1 to 'TEST-WORKLOAD'.
    
    
    
    
    -------------------------- EXAMPLE 2 --------------------------
    
    PS C:\>[PSCustomObject] @{ 'ID' = 1; 'NewName' = 'TEST-WORKLOAD' } | Rename-ArmorCompleteWorkload
    
    Renames the workload with ID=1 to 'TEST-WORKLOAD' via property names in the
    pipeline.
    
    
    
    
REMARKS
    To see the examples, type: "get-help Rename-ArmorCompleteWorkload -examples".
    For more information, type: "get-help Rename-ArmorCompleteWorkload -detailed".
    For technical information, type: "get-help Rename-ArmorCompleteWorkload -full".
    For online help, type: "get-help Rename-ArmorCompleteWorkload -online"



