Get Commands
=========================
This page contains details on **Get** commands.

Get-ArmorAccount
-------------------------

NAME
    Get-ArmorAccount
    
SYNOPSIS
    Retrieves Armor account details.
    
    
SYNTAX
    Get-ArmorAccount [[-ID] <UInt16>] [[-ApiVersion] <String>] [<CommonParameters>]
    
    Get-ArmorAccount [[-Name] <String>] [[-ApiVersion] <String>] [<CommonParameters>]
    
    
DESCRIPTION
    Retrieves a list of Armor account memberships for the currently authenticated
    user.  Returns a set of accounts that correspond to the filter criteria
    provided by the cmdlet parameters.
    

PARAMETERS
    -ID <UInt16>
        Specifies the ID of the Armor account.
        
    -Name <String>
        Specifies the name of the Armor account.
        
    -ApiVersion <String>
        Specifies the API version for this request.
        
    <CommonParameters>
        This cmdlet supports the common parameters: Verbose, Debug,
        ErrorAction, ErrorVariable, WarningAction, WarningVariable,
        OutBuffer, PipelineVariable, and OutVariable. For more information, see 
        about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216). 
    
    -------------------------- EXAMPLE 1 --------------------------
    
    PS C:\>Get-ArmorAccount
    
    Gets all Armor accounts assigned to the logged in user account.
    
    
    
    
    -------------------------- EXAMPLE 2 --------------------------
    
    PS C:\>Get-ArmorAccount -Name *Child*
    
    Gets all Armor accounts assigned to the logged in user account with a name
    containing the word 'Child'.
    
    
    
    
    -------------------------- EXAMPLE 3 --------------------------
    
    PS C:\>1, 'Example Child Account' | Get-ArmorAccount
    
    Gets the Armor accounts assigned to the logged in user account with ID=1 and
    Name='Example Child Account' via pipeline values.
    
    
    
    
    -------------------------- EXAMPLE 4 --------------------------
    
    PS C:\>[PSCustomObject] @{ 'ID' = 1 } | Get-ArmorAccount
    
    Gets the Armor account assigned to the logged in user account with ID=1 via
    property name in the pipeline.
    
    
    
    
    -------------------------- EXAMPLE 5 --------------------------
    
    PS C:\>[PSCustomObject] @{ 'Name' = 'My Secure Account' } | Get-ArmorAccount
    
    Gets the Armor account assigned to the logged in user account with
    Name='My Secure Account' via property name in the pipeline.
    
    
    
    
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
    Retrieves the mailing address on file for Armor accounts.
    
    
SYNTAX
    Get-ArmorAccountAddress [[-ID] <UInt16>] [[-ApiVersion] <String>] [<CommonParameters>]
    
    
DESCRIPTION
    This cmdlet retrieves the mailing address on file for Armor accounts that your
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
    
    Retrieves the mailing address of the Armor account currently in context.
    
    
    
    
    -------------------------- EXAMPLE 2 --------------------------
    
    PS C:\>Get-ArmorAccountAddress -ID 1
    
    Retrieves the mailing address of the Armor account with ID 1.
    
    
    
    
    -------------------------- EXAMPLE 3 --------------------------
    
    PS C:\>1, 2 | Get-ArmorAccountAddress
    
    Retrieves the mailing address of the Armor accounts with ID=1 and ID=2 via
    pipeline values.
    
    
    
    
    -------------------------- EXAMPLE 4 --------------------------
    
    PS C:\>[PSCustomObject] @{ 'ID' = 1 } | Get-ArmorAccountAddress
    
    Retrieves the mailing address of the Armor account with ID=1 and ID=2 via
    property names in the pipeline.
    
    
    
    
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
    Retrieves the Armor Anywhere or Armor Complete account currently in context.
    
    
SYNTAX
    Get-ArmorAccountContext [<CommonParameters>]
    
    
DESCRIPTION
    If your user account has access to more than one Armor Anywhere and/or Armor
    Complete accounts, this cmdlet allows you to get the current context, which all
    future requests will reference.
    

PARAMETERS
    <CommonParameters>
        This cmdlet supports the common parameters: Verbose, Debug,
        ErrorAction, ErrorVariable, WarningAction, WarningVariable,
        OutBuffer, PipelineVariable, and OutVariable. For more information, see 
        about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216). 
    
    -------------------------- EXAMPLE 1 --------------------------
    
    PS C:\>Get-ArmorAccountContext
    
    Retrieves the Armor account currently in context.
    
    
    
    
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
    Retrieves Armor Complete datacenter details.
    
    
SYNTAX
    Get-ArmorCompleteDatacenter [[-ID] <UInt16>] [[-ApiVersion] <String>] [<CommonParameters>]
    
    Get-ArmorCompleteDatacenter [-Name <String>] [[-ApiVersion] <String>] [<CommonParameters>]
    
    Get-ArmorCompleteDatacenter [[-Location] <String>] [[-ApiVersion] <String>] [<CommonParameters>]
    
    
DESCRIPTION
    Retrieves details about the Armor Complete datacenters, regions, and compute
    zones.  Returns a set of datacenters that correspond to the filter criteria
    provided by the cmdlet parameters.
    

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
    
    PS C:\>Get-ArmorCompleteDatacenter
    
    Retrieves the details for all Armor Complete datacenters.
    
    
    
    
    -------------------------- EXAMPLE 2 --------------------------
    
    PS C:\>Get-ArmorCompleteDatacenter -ID 2
    
    Retrieves the details for the Armor Complete datacenter with ID=2.
    
    
    
    
    -------------------------- EXAMPLE 3 --------------------------
    
    PS C:\>1, 'PHX01' | Get-ArmorCompleteDatacenter
    
    Retrieves the details for the Armor Complete datacenter with ID=1 and
    Location='PHX01' via pipeline values.
    
    
    
    
    -------------------------- EXAMPLE 4 --------------------------
    
    PS C:\>[PSCustomObject] @{ 'Location' = 'EU West' } | Get-ArmorCompleteDatacenter
    
    Retrieves the details for the Armor Complete datacenter with Name='EU West' via
    property name in the pipeline.
    
    
    
    
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
    Workloads and tiers are logical grouping tools for helping you organize your
    virtual machines and corresponding resources in your Armor Complete
    software-defined datacenters.
    
    Workloads contain tiers, and tiers contain virtual machines.
    
    Workloads are intended to help you describe the business function of a group of
    servers, such as 'My Secure Website', which could be useful for chargeback or
    showback to your customers, as well as helping your staff and the Armor Support
    teams understand the architecture of your environment.
    
    Tiers are intended to describe the application tiers within each workload.  A
    typical three tiered application workload is comprised of presentation,
    business logic, and persistence tiers.  Common labels for each are: web,
    application, and database respectively, but you can group your VMs however you
    choose.
    
    Returns a set of workloads that correspond to the filter criteria provided by
    the cmdlet parameters.
    

PARAMETERS
    -ID <UInt16>
        Specifies the ID of the Armor Complete workload.
        
    -Name <String>
        Specifies the name of the Armor Complete workload.
        
    -ApiVersion <String>
        Specifies the API version for this request.
        
    <CommonParameters>
        This cmdlet supports the common parameters: Verbose, Debug,
        ErrorAction, ErrorVariable, WarningAction, WarningVariable,
        OutBuffer, PipelineVariable, and OutVariable. For more information, see 
        about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216). 
    
    -------------------------- EXAMPLE 1 --------------------------
    
    PS C:\>Get-ArmorCompleteWorkload
    
    Retrieves the details for all workloads in the Armor Complete account that
    currently has context.
    
    
    
    
    -------------------------- EXAMPLE 2 --------------------------
    
    PS C:\>Get-ArmorCompleteWorkload -ID 1
    
    Retrieves the details for the workload with ID=1.
    
    
    
    
    -------------------------- EXAMPLE 3 --------------------------
    
    PS C:\>Get-ArmorCompleteWorkload -Name 'LAMP stack'
    
    Retrieves the details for the workload with Name='LAMP stack'.
    
    
    
    
    -------------------------- EXAMPLE 4 --------------------------
    
    PS C:\>2, 'WISP stack' | Get-ArmorCompleteWorkload -ApiVersion 'v1.0'
    
    Retrieves the API version 1.0 details for the workloads with ID=2 and
    Name='WISP stack' via pipeline values.
    
    
    
    
    -------------------------- EXAMPLE 5 --------------------------
    
    PS C:\>[PSCustomObject] @{ 'Name' = 'Secure stack' } | Get-ArmorCompleteWorkload
    
    Retrieves the details for the workload with Name='Secure stack' via property
    name in the pipeline.
    
    
    
    
    -------------------------- EXAMPLE 6 --------------------------
    
    PS C:\>[PSCustomObject] @{ 'ID' = 1 } | Get-ArmorCompleteWorkload
    
    Retrieves the details for the workload with ID=1 via property name in the
    pipeline.
    
    
    
    
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
    Workloads and tiers are logical grouping tools for helping you organize your
    virtual machines and corresponding resources in your Armor Complete
    software-defined datacenters.
    
    Workloads contain tiers, and tiers contain virtual machines.
    
    Workloads are intended to help you describe the business function of a group of
    servers, such as 'My Secure Website', which could be useful for chargeback or
    showback to your customers, as well as helping your staff and the Armor Support
    teams understand the architecture of your environment.
    
    Tiers are intended to describe the application tiers within each workload.  A
    typical three tiered application workload is comprised of presentation,
    business logic, and persistence tiers.  Common labels for each are: web,
    application, and database respectively, but you can group your VMs however you
    choose.
    
    Returns a set of tiers in a workload that correspond to the filter criteria
    provided by the cmdlet parameters.
    

PARAMETERS
    -WorkloadID <UInt16>
        Specifies the ID of the workload that contains the tier(s).
        
    -ID <UInt16>
        Specifies the ID of the workload tier.
        
    -Name <String>
        Specifies the names of the workload tiers.
        
    -ApiVersion <String>
        Specifies the API version for this request.
        
    <CommonParameters>
        This cmdlet supports the common parameters: Verbose, Debug,
        ErrorAction, ErrorVariable, WarningAction, WarningVariable,
        OutBuffer, PipelineVariable, and OutVariable. For more information, see 
        about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216). 
    
    -------------------------- EXAMPLE 1 --------------------------
    
    PS C:\>Get-ArmorCompleteWorkloadTier -WorkloadID 1
    
    Retrieves the details for all workload tiers in the workload with WorkloadID=1
    in the Armor Complete account that currently has context.
    
    
    
    
    -------------------------- EXAMPLE 2 --------------------------
    
    PS C:\>Get-ArmorCompleteWorkloadTier -WorkloadID 1 -ID 1
    
    Retrieves the details for the workload tier with ID=1 in the workload with
    WorkloadID=1.
    
    
    
    
    -------------------------- EXAMPLE 3 --------------------------
    
    PS C:\>Get-ArmorCompleteWorkloadTier -WorkloadID 1 -Name 'Database'
    
    Retrieves the details for the workload tier with Name='Database' in the
    workload with WorkloadID=1.
    
    
    
    
    -------------------------- EXAMPLE 4 --------------------------
    
    PS C:\>2, 3 | Get-ArmorCompleteWorkloadTier -ApiVersion 'v1.0'
    
    Retrieves the API version 1.0 details for all of the workload tiers in
    workloads with WorkloadID=2 and WorkloadID=3 via pipeline values.
    
    
    
    
    -------------------------- EXAMPLE 5 --------------------------
    
    PS C:\>[PSCustomObject] @{ 'WorkloadID' = 1; 'ID' = 1 } | Get-ArmorCompleteWorkloadTier
    
    Retrieves the details for the workload tier with ID=1 in the workload with
    WorkloadID=1 via property names in the pipeline.
    
    
    
    
    -------------------------- EXAMPLE 6 --------------------------
    
    PS C:\>[PSCustomObject] @{ 'WorkloadID' = 1; 'Name' = 'Presentation' } | Get-ArmorCompleteWorkloadTier
    
    Retrieves the details for the workload tier with Name='Presentation' in the
    workload with WorkloadID=1 via property names in the pipeline.
    
    
    
    
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
    Retrieves identity details about your Armor user account.
    
    
SYNTAX
    Get-ArmorIdentity [[-ApiVersion] <String>] [<CommonParameters>]
    
    
DESCRIPTION
    Retrieves details about your Armor user account that you used to establish the
    session, including account membership and permissions.
    
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
    
    PS C:\>Get-ArmorIdentity
    
    Retrieves the identity details about your Armor user account.
    
    
    
    
    -------------------------- EXAMPLE 2 --------------------------
    
    PS C:\>Get-ArmorIdentity -ApiVersion 1.0
    
    Retrieves the Armor API version 1.0 identity details about your Armor user
    account.
    
    
    
    
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
    Retrieves details about the user accounts in your account.
    
    
SYNTAX
    Get-ArmorUser [[-ID] <UInt16>] [[-ApiVersion] <String>] [<CommonParameters>]
    
    Get-ArmorUser [[-UserName] <String>] [[-ApiVersion] <String>] [<CommonParameters>]
    
    Get-ArmorUser [-FirstName <String>] [-LastName <String>] [[-ApiVersion] <String>] [<CommonParameters>]
    
    
DESCRIPTION
    Retrieves details about the user accounts in the Armor Anywhere or Armor
    Complete account in context.  Returns a set of user accounts that correspond to
    the filter criteria provided by the cmdlet parameters.
    

PARAMETERS
    -ID <UInt16>
        Specifies the ID of the Armor user account.
        
    -UserName <String>
        Specifies the username of the Armor user account.
        
    -FirstName <String>
        Specifies the first name of the Armor user account.
        
    -LastName <String>
        Specifies the last name of the Armor user account.
        
    -ApiVersion <String>
        Specifies the API version for this request.
        
    <CommonParameters>
        This cmdlet supports the common parameters: Verbose, Debug,
        ErrorAction, ErrorVariable, WarningAction, WarningVariable,
        OutBuffer, PipelineVariable, and OutVariable. For more information, see 
        about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216). 
    
    -------------------------- EXAMPLE 1 --------------------------
    
    PS C:\>Get-ArmorUser
    
    Retrieves the details for all user accounts in the Armor account that currently
    has context.
    
    
    
    
    -------------------------- EXAMPLE 2 --------------------------
    
    PS C:\>Get-ArmorUser -ID 1
    
    Retrieves the details for all user accounts in the Armor account that currently
    has context.
    
    
    
    
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
    Retrieves virtual machine details.
    
    
SYNTAX
    Get-ArmorVM [[-ID] <UInt16>] [[-ApiVersion] <String>] [<CommonParameters>]
    
    Get-ArmorVM [[-CoreInstanceID] <Guid>] [[-ApiVersion] <String>] [<CommonParameters>]
    
    Get-ArmorVM [[-Name] <String>] [[-ApiVersion] <String>] [<CommonParameters>]
    
    
DESCRIPTION
    Retrieves details about the virtual machines in the Armor Anywhere or Armor
    Complete account in context.  Returns a set of virtual machines that correspond
    to the filter criteria provided by the cmdlet parameters.
    

PARAMETERS
    -ID <UInt16>
        Specifies the IDs of the virtual machines that you want to retrieve.
        
    -CoreInstanceID <Guid>
        Specifies the Armor Anywhere Core Agent instance IDs of the virtual machines
        that you want to retrieve.
        
    -Name <String>
        Specifies the names of the virtual machines that you want to retrieve.
        
    -ApiVersion <String>
        Specifies the API version for this request.
        
    <CommonParameters>
        This cmdlet supports the common parameters: Verbose, Debug,
        ErrorAction, ErrorVariable, WarningAction, WarningVariable,
        OutBuffer, PipelineVariable, and OutVariable. For more information, see 
        about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216). 
    
    -------------------------- EXAMPLE 1 --------------------------
    
    PS C:\>Get-ArmorVM
    
    Retrieves the details for all VMs in the Armor account that currently has
    context.
    
    
    
    
    -------------------------- EXAMPLE 2 --------------------------
    
    PS C:\>Get-ArmorVM -ID 1
    
    Retrieves the details for the VM with ID=1.
    
    
    
    
    -------------------------- EXAMPLE 3 --------------------------
    
    PS C:\>Get-ArmorVM -Name 'web1'
    
    Retrieves the details for the VM with Name='web1'.
    
    
    
    
    -------------------------- EXAMPLE 4 --------------------------
    
    PS C:\>Get-ArmorVM -Name db*
    
    Retrieves all VMs in the Armor account that currently has context that have a
    name that starts with 'db'.
    
    
    
    
    -------------------------- EXAMPLE 5 --------------------------
    
    PS C:\>1 | Get-ArmorVM
    
    Retrieves the details for the VM with ID=1 via pipeline value.
    
    
    
    
    -------------------------- EXAMPLE 6 --------------------------
    
    PS C:\>'*secure*' | Get-ArmorVM
    
    Retrieves all VMs containing the word 'secure' in the name via pipeline value.
    
    
    
    
    -------------------------- EXAMPLE 7 --------------------------
    
    PS C:\>[PSCustomObject] @{ 'ID' = 1 } | Get-ArmorVM
    
    Retrieves the details for the VM with ID=1 via property name in the pipeline.
    
    
    
    
    -------------------------- EXAMPLE 8 --------------------------
    
    PS C:\>[PSCustomObject] @{ 'Name' = 'app1' } | Get-ArmorVM
    
    Retrieves the details for the VM with Name='app1' via property name in the
    pipeline.
    
    
    
    
REMARKS
    To see the examples, type: "get-help Get-ArmorVM -examples".
    For more information, type: "get-help Get-ArmorVM -detailed".
    For technical information, type: "get-help Get-ArmorVM -full".
    For online help, type: "get-help Get-ArmorVM -online"



