Get Commands
=========================

This page contains details on **Get** commands.

Get-ArmorAccount
-------------------------


NAME
    Get-ArmorAccount
    
SYNOPSIS
    Retrieves a list of Armor account memberships for the currently authenticated user.
    
    
SYNTAX
    Get-ArmorAccount [[-ApiVersion] <String>] [<CommonParameters>]
    
    
DESCRIPTION
    { required: more detailed description of the function's purpose }
    

PARAMETERS
    -ApiVersion <String>
        The API version.  The default value is $Global:ArmorConnection.ApiVersion.
        
    <CommonParameters>
        This cmdlet supports the common parameters: Verbose, Debug,
        ErrorAction, ErrorVariable, WarningAction, WarningVariable,
        OutBuffer, PipelineVariable, and OutVariable. For more information, see 
        about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216). 
    
    -------------------------- EXAMPLE 1 --------------------------
    
    PS C:\>{required: show one or more examples using the function}
    
    
    
    
    
    
REMARKS
    To see the examples, type: "get-help Get-ArmorAccount -examples".
    For more information, type: "get-help Get-ArmorAccount -detailed".
    For technical information, type: "get-help Get-ArmorAccount -full".
    For online help, type: "get-help Get-ArmorAccount -online"


Get-ArmorDatacenter
-------------------------

NAME
    Get-ArmorDatacenter
    
SYNOPSIS
    { required: high level overview }
    
    
SYNTAX
    Get-ArmorDatacenter [-Name <String>] [[-Location] <String>] [-ID <UInt16>] [[-ApiVersion] <String>] [<CommonParameters>]
    
    
DESCRIPTION
    { required: more detailed description of the function's purpose }
    

PARAMETERS
    -Name <String>
        { required: description of the specified input parameter's purpose }
        
    -Location <String>
        { required: description of the specified input parameter's purpose }
        
    -ID <UInt16>
        { required: description of the specified input parameter's purpose }
        
    -ApiVersion <String>
        The API version.  The default value is $Global:ArmorConnection.ApiVersion.
        
    <CommonParameters>
        This cmdlet supports the common parameters: Verbose, Debug,
        ErrorAction, ErrorVariable, WarningAction, WarningVariable,
        OutBuffer, PipelineVariable, and OutVariable. For more information, see 
        about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216). 
    
    -------------------------- EXAMPLE 1 --------------------------
    
    PS C:\>{required: show one or more examples using the function}
    
    
    
    
    
    
REMARKS
    To see the examples, type: "get-help Get-ArmorDatacenter -examples".
    For more information, type: "get-help Get-ArmorDatacenter -detailed".
    For technical information, type: "get-help Get-ArmorDatacenter -full".
    For online help, type: "get-help Get-ArmorDatacenter -online"


Get-ArmorUser
-------------------------

NAME
    Get-ArmorUser
    
SYNOPSIS
    The Get-ArmorVm retrieves a list of users in your account.
    
    
SYNTAX
    Get-ArmorUser [[-UserName] <String>] [-FirstName <String>] [-LastName <String>] [-ID <UInt16>] [[-ApiVersion] <String>] [<CommonParameters>]
    
    
DESCRIPTION
    { required: more detailed description of the function's purpose }
    

PARAMETERS
    -UserName <String>
        
    -FirstName <String>
        
    -LastName <String>
        
    -ID <UInt16>
        { required: description of the specified input parameter's purpose }
        
    -ApiVersion <String>
        
    <CommonParameters>
        This cmdlet supports the common parameters: Verbose, Debug,
        ErrorAction, ErrorVariable, WarningAction, WarningVariable,
        OutBuffer, PipelineVariable, and OutVariable. For more information, see 
        about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216). 
    
    -------------------------- EXAMPLE 1 --------------------------
    
    PS C:\>{required: show one or more examples using the function}
    
    
    
    
    
    
REMARKS
    To see the examples, type: "get-help Get-ArmorUser -examples".
    For more information, type: "get-help Get-ArmorUser -detailed".
    For technical information, type: "get-help Get-ArmorUser -full".
    For online help, type: "get-help Get-ArmorUser -online"


Get-ArmorVM
-------------------------

NAME
    Get-ArmorVM
    
SYNOPSIS
    The Get-ArmorVM function displays a list of virtual machines in your account.
    
    
SYNTAX
    Get-ArmorVM [[-Name] <String>] [-ID <UInt16>] [[-ApiVersion] <String>] [<CommonParameters>]
    
    
DESCRIPTION
    { required: more detailed description of the function's purpose }
    

PARAMETERS
    -Name <String>
        The name of a VM in the Armor account.  Wildcard matches are supported.  The default value is null.
        
    -ID <UInt16>
        The ID of a VM in the Armor account.  The default value is 0.
        
    -ApiVersion <String>
        The API version.  The default value is $Global:ArmorConnection.ApiVersion.
        
    <CommonParameters>
        This cmdlet supports the common parameters: Verbose, Debug,
        ErrorAction, ErrorVariable, WarningAction, WarningVariable,
        OutBuffer, PipelineVariable, and OutVariable. For more information, see 
        about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216). 
    
    -------------------------- EXAMPLE 1 --------------------------
    
    PS C:\>Get-ArmorVM
    
    Description
    -----------
    
    Returns all VMs in the Armor account that currently has context.
    
    
    
    
    -------------------------- EXAMPLE 2 --------------------------
    
    PS C:\>Get-ArmorVM -Name ARMO25VML01-gen4
    
    Description
    -----------
    
    Returns the specified VM in the Armor account that currently has context.
    
    
    
    
    -------------------------- EXAMPLE 3 --------------------------
    
    PS C:\>Get-ArmorVM -Name *-gen4
    
    Description
    -----------
    
    Returns all VMs in the Armor account that currently has context that have a name that ends with '-gen4'.
    
    
    
    
    -------------------------- EXAMPLE 4 --------------------------
    
    PS C:\>Get-ArmorVM -Name *hacked*
    
    Description
    -----------
    
    Returns null.
    
    
    
    
REMARKS
    To see the examples, type: "get-help Get-ArmorVM -examples".
    For more information, type: "get-help Get-ArmorVM -detailed".
    For technical information, type: "get-help Get-ArmorVM -full".
    For online help, type: "get-help Get-ArmorVM -online"




