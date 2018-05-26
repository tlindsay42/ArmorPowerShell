Get Commands
=========================
This page contains details on **Get** commands.

Get-ArmorAccount
-------------------------

NAME
    Get-ArmorAccount
    
SYNOPSIS
    This cmdlet retrieves Armor account details.
    
    
SYNTAX
    Get-ArmorAccount [[-ID] <UInt16>] [[-ApiVersion] <String>] [<CommonParameters>]
    
    Get-ArmorAccount [[-Name] <String>] [[-ApiVersion] <String>] [<CommonParameters>]
    
    
DESCRIPTION
    This cmdlet retrieves a list of Armor account memberships for the
    currently authenticated user.  Returns a set of accounts that
    correspond to the filter criteria provided by the cmdlet parameters.
    

PARAMETERS
    -ID <UInt16>
        Specifies the ID of the Armor account.
        
    -Name <String>
        Specifies the name of the Armor account.  Wildcard searches are permitted.
        
    -ApiVersion <String>
        Specifies the API version for this request.
        
    <CommonParameters>
        This cmdlet supports the common parameters: Verbose, Debug,
        ErrorAction, ErrorVariable, WarningAction, WarningVariable,
        OutBuffer, PipelineVariable, and OutVariable. For more information, see 
        about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216). 
    
    -------------------------- EXAMPLE 1 --------------------------
    
    PS C:\>Get-ArmorAccount
    
    ID       : 65536
    Name     : Example Parent Account
    Currency : USD
    Status   : Claimed
    Parent   : -1
    Products : {@{AA-CORE=System.Object[]; ARMOR-COMPLETE=System.Object[]}}
    
    ID       : 65537
    Name     : Example Child Account
    Currency : GBP
    Status   : Claimed
    Parent   : 65536
    Products : {@{AA-CORE=System.Object[]}}
    
    
    Description
    -----------
    Gets all Armor accounts assigned to the logged in user account.
    
    
    
    
    -------------------------- EXAMPLE 2 --------------------------
    
    PS C:\>Get-ArmorAccount -Name *Child*
    
    ID       : 65537
    Name     : Example Child Account
    Currency : GBP
    Status   : Claimed
    Parent   : 65536
    Products : {@{AA-CORE=System.Object[]}}
    
    
    Description
    -----------
    Gets all Armor accounts assigned to the logged in user account with a
    name containing the word 'Child'.
    
    
    
    
    -------------------------- EXAMPLE 3 --------------------------
    
    PS C:\>65536, 'Example Child Account' | Get-ArmorAccount
    
    ID       : 65536
    Name     : Example Parent Account
    Currency : USD
    Status   : Claimed
    Parent   : -1
    Products : {@{AA-CORE=System.Object[]; ARMOR-COMPLETE=System.Object[]}}
    
    ID       : 65537
    Name     : Example Child Account
    Currency : GBP
    Status   : Claimed
    Parent   : 65536
    Products : {@{AA-CORE=System.Object[]}}
    
    
    Description
    -----------
    Gets the Armor accounts assigned to the logged in user account with
    ID=65536 and Name='Example Child Account'.
    
    
    
    
REMARKS
    To see the examples, type: "get-help Get-ArmorAccount -examples".
    For more information, type: "get-help Get-ArmorAccount -detailed".
    For technical information, type: "get-help Get-ArmorAccount -full".
    For online help, type: "get-help Get-ArmorAccount -online"

Get-ArmorAccountAddress
-------------------------
NAME
    Get-ArmorAccountAddress
    
SYNOPSIS
    This cmdlet retrieves the address on file for Armor accounts.
    
    
SYNTAX
    Get-ArmorAccountAddress [[-ID] <UInt16>] [[-ApiVersion] <String>] [<CommonParameters>]
    
    
DESCRIPTION
    This cmdlet retrieves the address on file for Armor accounts that your
    user account has access to.
    

PARAMETERS
    -ID <UInt16>
        Specifies the ID of the Armor account with the desired address details.
        
    -ApiVersion <String>
        Specifies the API version for this request.
        
    <CommonParameters>
        This cmdlet supports the common parameters: Verbose, Debug,
        ErrorAction, ErrorVariable, WarningAction, WarningVariable,
        OutBuffer, PipelineVariable, and OutVariable. For more information, see 
        about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216). 
    
    -------------------------- EXAMPLE 1 --------------------------
    
    PS C:\>Get-ArmorAccountAddress
    
    AccountID    : 65536
    Name         : Example Parent Account
    AddressLine1 : 2360 Campbell Creek Blvd.
    AddressLine2 : Suite 525
    City         : Richardson
    State        : TX
    PostalCode   : 75082
    Country      : US
    
    
    Description
    -----------
    Gets the address of the Armor account currently in context.
    
    
    
    
    -------------------------- EXAMPLE 2 --------------------------
    
    PS C:\>Get-ArmorAccountAddress -ID 65537
    
    AccountID    : 65537
    Name         : Example Child Account
    AddressLine1 : 2360 Campbell Creek Blvd.
    AddressLine2 : Suite 525
    City         : Richardson
    State        : TX
    PostalCode   : 75082
    Country      : US
    
    
    Description
    -----------
    Gets the address of Armor account ID 65537.
    
    
    
    
    -------------------------- EXAMPLE 3 --------------------------
    
    PS C:\>65536 | Get-ArmorAccountAddress
    
    AccountID    : 65536
    Name         : Example Parent Account
    AddressLine1 : 2360 Campbell Creek Blvd.
    AddressLine2 : Suite 525
    City         : Richardson
    State        : TX
    PostalCode   : 75082
    Country      : US
    
    
    Description
    -----------
    Gets the address of Armor account ID 65536.
    
    
    
    
REMARKS
    To see the examples, type: "get-help Get-ArmorAccountAddress -examples".
    For more information, type: "get-help Get-ArmorAccountAddress -detailed".
    For technical information, type: "get-help Get-ArmorAccountAddress -full".
    For online help, type: "get-help Get-ArmorAccountAddress -online"

Get-ArmorAccountContext
-------------------------
NAME
    Get-ArmorAccountContext
    
SYNOPSIS
    This cmdlet gets the Armor Anywhere or Armor Complete account context.
    
    
SYNTAX
    Get-ArmorAccountContext [<CommonParameters>]
    
    
DESCRIPTION
    If your user account has access to more than one Armor Anywhere and/or
    Armor Complete accounts, this cmdlet allows you to get the current
    context, which all future requests will reference.
    

PARAMETERS
    <CommonParameters>
        This cmdlet supports the common parameters: Verbose, Debug,
        ErrorAction, ErrorVariable, WarningAction, WarningVariable,
        OutBuffer, PipelineVariable, and OutVariable. For more information, see 
        about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216). 
    
    -------------------------- EXAMPLE 1 --------------------------
    
    PS C:\>Get-ArmorAccountContext
    
    ID       : 65536
    Name     : Example Parent Account
    Currency : USD
    Status   : Claimed
    Parent   : -1
    Products :
    
    
    Description
    -----------
    Gets the Armor account currently in context.
    
    
    
    
REMARKS
    To see the examples, type: "get-help Get-ArmorAccountContext -examples".
    For more information, type: "get-help Get-ArmorAccountContext -detailed".
    For technical information, type: "get-help Get-ArmorAccountContext -full".
    For online help, type: "get-help Get-ArmorAccountContext -online"

Get-ArmorCompleteDatacenter
-------------------------
NAME
    Get-ArmorCompleteDatacenter
    
SYNOPSIS
    This cmdlet retrieves Armor Complete datacenters.
    
    
SYNTAX
    Get-ArmorCompleteDatacenter [[-ID] <UInt16>] [[-ApiVersion] <String>] [<CommonParameters>]
    
    Get-ArmorCompleteDatacenter [-Name <String>] [[-ApiVersion] <String>] [<CommonParameters>]
    
    Get-ArmorCompleteDatacenter [[-Location] <String>] [[-ApiVersion] <String>] [<CommonParameters>]
    
    
DESCRIPTION
    This cmdlet retrieves details about the Armor Complete datacenters,
    regions, and compute zones.  Returns a set of datacenters that
    correspond to the filter criteria provided by the cmdlet parameters.
    

PARAMETERS
    -ID <UInt16>
        Specifies the ID of the Armor Complete datacenter.
        
    -Name <String>
        Specifies the name of the Armor Complete region.
        
    -Location <String>
        Specifies the name of the Armor Complete datacenter.
        
    -ApiVersion <String>
        Specifies the API version for this request.
        
    <CommonParameters>
        This cmdlet supports the common parameters: Verbose, Debug,
        ErrorAction, ErrorVariable, WarningAction, WarningVariable,
        OutBuffer, PipelineVariable, and OutVariable. For more information, see 
        about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216). 
    
    -------------------------- EXAMPLE 1 --------------------------
    
    PS C:\>Get-ArmorCompleteDatacenter |
    
    Select-Object -Property ID, Location, Name
    
    ID Location Name
    -- -------- ----
     1 DFW01    US Central
     2 PHX01    US West
     3 LHR01    EU West
     4 AMS01    EU Central
     5 SIN01    AS East
    
    
    Description
    -----------
    Gets the Armor Complete datacenters and filters the compute zones.
    
    
    
    
    -------------------------- EXAMPLE 2 --------------------------
    
    PS C:\>Get-ArmorCompleteDatacenter -ID 2 |
    
    Select-Object -Property ID, Location, Name
    
    ID Location Name
    -- -------- ----
     2 PHX01    US West
    
    
    Description
    -----------
    Gets the Armor Complete datacenter with ID=2 and filters the compute
    zones.
    
    
    
    
    -------------------------- EXAMPLE 3 --------------------------
    
    PS C:\>1, 'PHX01' | Get-ArmorCompleteDatacenter |
    
    Select-Object -Property ID, Location, Name
    
    ID Location Name
    -- -------- ----
     1 DFW01    US Central
     2 PHX01    US West
    
    
    Description
    -----------
    Gets the Armor Complete datacenter with ID=1 and Location='PHX01' and
    filters the compute zones.
    
    
    
    
REMARKS
    To see the examples, type: "get-help Get-ArmorCompleteDatacenter -examples".
    For more information, type: "get-help Get-ArmorCompleteDatacenter -detailed".
    For technical information, type: "get-help Get-ArmorCompleteDatacenter -full".
    For online help, type: "get-help Get-ArmorCompleteDatacenter -online"

Get-ArmorCompleteWorkload
-------------------------
NAME
    Get-ArmorCompleteWorkload
    
SYNOPSIS
    This cmdlet retrieves Armor Complete workloads.
    
    
SYNTAX
    Get-ArmorCompleteWorkload [[-ID] <UInt16>] [[-ApiVersion] <String>] [<CommonParameters>]
    
    Get-ArmorCompleteWorkload [[-Name] <String>] [[-ApiVersion] <String>] [<CommonParameters>]
    
    
DESCRIPTION
    Workloads and tiers are logical grouping tools for helping you
    organize your virtual machines and corresponding resources in your
    Armor Complete software-defined datacenters.
    
    Workloads contain tiers, and tiers contain virtual machines.
    
    Workloads are intended to help you describe the business function of a
    group of servers, such as 'My Secure Website', which could be useful
    for chargeback or showback to your customers, as well as helping your
    staff and the Armor Support teams understand the architecture of your
    environment.
    
    Tiers are intended to describe the application tiers within each
    workload.  A typical three tiered application workload is comprised
    of presentation, business logic, and persistence tiers.  Common labels
    for each are: web, application, and database respectively, but you can
    group your VMs however you choose.
    
    Returns a set of workloads that correspond to the filter criteria
    provided by the cmdlet parameters.
    

PARAMETERS
    -ID <UInt16>
        Specifies the ID of the Armor Complete workload.
        
    -Name <String>
        Specifies the name of the Armor Complete workload.  Wildcard searches
        are permitted.
        
    -ApiVersion <String>
        Specifies the API version for this request.
        
    <CommonParameters>
        This cmdlet supports the common parameters: Verbose, Debug,
        ErrorAction, ErrorVariable, WarningAction, WarningVariable,
        OutBuffer, PipelineVariable, and OutVariable. For more information, see 
        about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216). 
    
    -------------------------- EXAMPLE 1 --------------------------
    
    PS C:\>{required: show one or more examples using the function}
    
    
    
    
    
    
REMARKS
    To see the examples, type: "get-help Get-ArmorCompleteWorkload -examples".
    For more information, type: "get-help Get-ArmorCompleteWorkload -detailed".
    For technical information, type: "get-help Get-ArmorCompleteWorkload -full".
    For online help, type: "get-help Get-ArmorCompleteWorkload -online"

Get-ArmorCompleteWorkloadTier
-------------------------
NAME
    Get-ArmorCompleteWorkloadTier
    
SYNOPSIS
    This cmdlet retrieves the tiers in an Armor Complete workload.
    
    
SYNTAX
    Get-ArmorCompleteWorkloadTier [-WorkloadID] <UInt16> [[-ID] <UInt16>] [[-ApiVersion] <String>] [<CommonParameters>]
    
    Get-ArmorCompleteWorkloadTier [-WorkloadID] <UInt16> [[-Name] <String>] [[-ApiVersion] <String>] [<CommonParameters>]
    
    
DESCRIPTION
    Workloads and tiers are logical grouping tools for helping you
    organize your virtual machines and corresponding resources in your
    Armor Complete software-defined datacenters.
    
    Workloads contain tiers, and tiers contain virtual machines.
    
    Workloads are intended to help you describe the business function of a
    group of servers, such as 'My Secure Website', which could be useful
    for chargeback or showback to your customers, as well as helping your
    staff and the Armor Support teams understand the architecture of your
    environment.
    
    Tiers are intended to describe the application tiers within each
    workload.  A typical three tiered application workload is comprised
    of presentation, business logic, and persistence tiers.  Common labels
    for each are: web, application, and database respectively, but you can
    group your VMs however you choose.
    
    Returns a set of tiers in a workload that correspond to the filter
    criteria provided by the cmdlet parameters.
    

PARAMETERS
    -WorkloadID <UInt16>
        Specifies the ID of the Armor Complete workload that contains the
        tier(s).
        
    -ID <UInt16>
        Specifies the IDs of the tiers in the Armor Complete that you want to
        retrieve.
        
    -Name <String>
        Specifies the names of the tiers in the Armor Complete that you want to
        retrieve.  Wildcard searches are permitted.
        
    -ApiVersion <String>
        Specifies the API version for this request.
        
    <CommonParameters>
        This cmdlet supports the common parameters: Verbose, Debug,
        ErrorAction, ErrorVariable, WarningAction, WarningVariable,
        OutBuffer, PipelineVariable, and OutVariable. For more information, see 
        about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216). 
    
    -------------------------- EXAMPLE 1 --------------------------
    
    PS C:\>{required: show one or more examples using the function}
    
    
    
    
    
    
REMARKS
    To see the examples, type: "get-help Get-ArmorCompleteWorkloadTier -examples".
    For more information, type: "get-help Get-ArmorCompleteWorkloadTier -detailed".
    For technical information, type: "get-help Get-ArmorCompleteWorkloadTier -full".
    For online help, type: "get-help Get-ArmorCompleteWorkloadTier -online"

Get-ArmorIdentity
-------------------------
NAME
    Get-ArmorIdentity
    
SYNOPSIS
    This cmdlet retrieves details about your Armor user account.
    
    
SYNTAX
    Get-ArmorIdentity [[-ApiVersion] <String>] [<CommonParameters>]
    
    
DESCRIPTION
    This cmdlet retrieves details about your Armor user account that you
    used to establish the session.  Returns information about the current
    authenticated user, including account membership and permissions.
    
    This also updates the identity information in the session variable:
    $Global:ArmorSession.
    

PARAMETERS
    -ApiVersion <String>
        Specifies the API version for this request.
        
    <CommonParameters>
        This cmdlet supports the common parameters: Verbose, Debug,
        ErrorAction, ErrorVariable, WarningAction, WarningVariable,
        OutBuffer, PipelineVariable, and OutVariable. For more information, see 
        about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216). 
    
    -------------------------- EXAMPLE 1 --------------------------
    
    PS C:\>{required: show one or more examples using the function}
    
    
    
    
    
    
REMARKS
    To see the examples, type: "get-help Get-ArmorIdentity -examples".
    For more information, type: "get-help Get-ArmorIdentity -detailed".
    For technical information, type: "get-help Get-ArmorIdentity -full".
    For online help, type: "get-help Get-ArmorIdentity -online"

Get-ArmorUser
-------------------------
NAME
    Get-ArmorUser
    
SYNOPSIS
    This cmdlet retrieves a list of users in your account.
    
    
SYNTAX
    Get-ArmorUser [[-ID] <UInt16>] [[-ApiVersion] <String>] [<CommonParameters>]
    
    Get-ArmorUser [[-UserName] <String>] [[-ApiVersion] <String>] [<CommonParameters>]
    
    Get-ArmorUser [-FirstName <String>] [-LastName <String>] [[-ApiVersion] <String>] [<CommonParameters>]
    
    
DESCRIPTION
    This cmdlet retrieves details about the user accounts in the
    Armor Anywhere or Armor Complete account in context.  Returns a set of
    user accounts that correspond to the filter criteria provided by the
    cmdlet parameters.
    

PARAMETERS
    -ID <UInt16>
        Specifies the ID of the Armor user account.
        
    -UserName <String>
        Specifies the username of the Armor user account.  Wildcard searches
        are permitted.
        
    -FirstName <String>
        Specifies the first name of the Armor user account.  Wildcard searches
        are permitted.
        
    -LastName <String>
        Specifies the last name of the Armor user account.  Wildcard searches
        are permitted.
        
    -ApiVersion <String>
        Specifies the API version for this request.
        
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
    This cmdlet retrieves the virtual machines in your Armor account.
    
    
SYNTAX
    Get-ArmorVM [[-ID] <UInt16>] [[-ApiVersion] <String>] [<CommonParameters>]
    
    Get-ArmorVM [[-Name] <String>] [[-ApiVersion] <String>] [<CommonParameters>]
    
    
DESCRIPTION
    This cmdlet retrieves details about the virtual machines in the
    Armor Anywhere or Armor Complete account in context.  Returns a set of
    virtual machines that correspond to the filter criteria provided by the
    cmdlet parameters.
    

PARAMETERS
    -ID <UInt16>
        Specifies the IDs of the virtual machines that you want to retrieve.
        
    -Name <String>
        Specifies the names of the virtual machines that you want to retrieve.
        Wildcard matches are supported.
        
    -ApiVersion <String>
        Specifies the API version for this request.
        
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



