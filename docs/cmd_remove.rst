Remove Commands
=========================
This page contains details on **Remove** commands.

Remove-ArmorCompleteWorkload
-------------------------

NAME
    Remove-ArmorCompleteWorkload
    
SYNOPSIS
    This cmdlet deletes Armor Complete workloads.
    
    
SYNTAX
    Remove-ArmorCompleteWorkload [-ID] <UInt16> [[-ApiVersion] <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
    
    
DESCRIPTION
    The specified workload in the Armor Complete account in context will be deleted
    if is empty.
    

PARAMETERS
    -ID <UInt16>
        Specifies the ID of the Armor Complete workload.
        
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
    
    PS C:\>Remove-ArmorCompleteWorkload -ID 1
    
    If confirmed and empty of child objects, deletes workload with ID=1.
    
    
    
    
    -------------------------- EXAMPLE 2 --------------------------
    
    PS C:\>1 | Remove-ArmorCompleteWorkload
    
    If confirmed and empty of child objects, deletes workload with ID=1 identified
    via pipeline value.
    
    
    
    
    -------------------------- EXAMPLE 3 --------------------------
    
    PS C:\>[PSCustomObject] @{ 'ID' = 1 | Remove-ArmorCompleteWorkload
    
    If confirmed and empty of child objects, deletes workload with ID=1 identified
    via property name in the pipeline.
    
    
    
    
REMARKS
    To see the examples, type: "get-help Remove-ArmorCompleteWorkload -examples".
    For more information, type: "get-help Remove-ArmorCompleteWorkload -detailed".
    For technical information, type: "get-help Remove-ArmorCompleteWorkload -full".
    For online help, type: "get-help Remove-ArmorCompleteWorkload -online"



