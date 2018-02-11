Disconnect Commands
=========================
This page contains details on **Disconnect** commands.

Disconnect-Armor
-------------------------

NAME
    Disconnect-Armor
    
SYNOPSIS
    Disconnects from Armor and destroys the session information.
    
    
SYNTAX
    Disconnect-Armor [-WhatIf] [-Confirm] [<CommonParameters>]
    
    
DESCRIPTION
    Disconnects from the Armor API and destroys the $Global:ArmorSession
    session variable.
    

PARAMETERS
    -WhatIf [<SwitchParameter>]
        
    -Confirm [<SwitchParameter>]
        
    <CommonParameters>
        This cmdlet supports the common parameters: Verbose, Debug,
        ErrorAction, ErrorVariable, WarningAction, WarningVariable,
        OutBuffer, PipelineVariable, and OutVariable. For more information, see 
        about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216). 
    
    -------------------------- EXAMPLE 1 --------------------------
    
    PS C:\>Disconnect-Armor
    
    Performing the operation "Disconnect" on target "Armor session".
    [Y] Yes  [A] Yes to All  [N] No  [L] No to All  [S] Suspend  [?] Help (default is "Y"): Y
    
    C:\>( Get-Variable -Scope Global ).Where( { $_.Name -eq 'ArmorSession' } ).Count
    0
    
    
    Description
    -----------
    Disconnects from the Armor API, destroys the $Global:ArmorSession, and
    then proves that the global scope ArmorSession variable no longer exists.
    
    
    
    
REMARKS
    To see the examples, type: "get-help Disconnect-Armor -examples".
    For more information, type: "get-help Disconnect-Armor -detailed".
    For technical information, type: "get-help Disconnect-Armor -full".
    For online help, type: "get-help Disconnect-Armor -online"



