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
    Disconnects from the Armor API and destroys the $Global:ArmorSession session
    variable.
    

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
    
    Disconnects from the Armor API and destroys the $Global:ArmorSession session
    variable.
    
    
    
    
REMARKS
    To see the examples, type: "get-help Disconnect-Armor -examples".
    For more information, type: "get-help Disconnect-Armor -detailed".
    For technical information, type: "get-help Disconnect-Armor -full".
    For online help, type: "get-help Disconnect-Armor -online"



