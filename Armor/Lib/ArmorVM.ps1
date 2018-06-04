foreach ( $className in 'ArmorDisk', 'ArmorVmProduct', 'ArmorStatus' ) {
    $classPath = Split-Path -Path $MyInvocation.MyCommand.Path -Parent |
        Join-Path -ChildPath "${className}.ps1"
    . $classPath
}

class ArmorVM {
    [UInt16] $AccountID

    [ValidatePattern( '^(?:|[0-9A-Z]{5}-[0-9A-Z]{5}-[0-9A-Z]{5}-[0-9A-Z]{5}-[0-9A-Z]{5})$' )]
    [String] $ActivationKey

    [AllowEmptyCollection()]
    [PSCustomObject[]] $AdvBackupSKU

    [Boolean] $AdvBackupStatus

    [ValidatePattern( '^(?:\d+\.\d+\.\d+|$)' )]
    [String] $AgentVersion

    [UInt16] $AppID

    [AllowEmptyString()]
    [String] $AppName

    [Guid] $BiosUuid

    [Boolean] $CanReplicate

    [Boolean] $CanUseFluidScale

    [AllowEmptyString()]
    [String] $CoreDateRegistered

    [Guid] $CoreInstanceID

    [AllowEmptyString()]
    [String] $CoreLastPing

    [UInt16] $CPU

    [AllowEmptyString()]
    [String] $CustomLocation

    [AllowEmptyString()]
    [String] $CustomProvider

    [AllowEmptyString()]
    [String] $DateCreated

    [AllowEmptyString()]
    [String] $DateRegistered

    [Boolean] $Deployed

    [AllowEmptyCollection()]
    [ArmorDisk[]] $Disks

    [ValidatePattern( '^(?:|(?:[1-9]?\d|1\d\d|2[0-4]\d|25[0-5])\.(?:[1-9]?\d|1\d\d|2[0-4]\d|25[0-5])\.(?:[1-9]?\d|1\d\d|2[0-4]\d|25[0-5])\.(?:[1-9]?\d|1\d\d|2[0-4]\d|25[0-5]))$' )]
    [String] $ExternalAddress

    [Boolean] $ExternalVmIsDeleted

    [UInt16] $Health

    [AllowEmptyString()]
    [String] $HostName

    [AllowEmptyString()]
    [String] $HostType

    [ValidatePattern( '^(?:|\d+|[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12})$' )]
    [String] $ID

    [AllowEmptyString()]
    [String] $InstanceType

    [ValidatePattern( '^(?:|(?:[1-9]?\d|1\d\d|2[0-4]\d|25[0-5])\.(?:[1-9]?\d|1\d\d|2[0-4]\d|25[0-5])\.(?:[1-9]?\d|1\d\d|2[0-4]\d|25[0-5])\.(?:[1-9]?\d|1\d\d|2[0-4]\d|25[0-5]))$' )]
    [String] $IPAddress

    [Boolean] $IsArmor

    [Boolean] $IsCore

    [Boolean] $IsDeleted

    [AllowEmptyString()]
    [String] $IsHealthy

    [Boolean] $IsRecoveryVM

    [Boolean] $IsRegistered

    [AllowEmptyString()]
    [String] $LastPing

    [ValidateSet( '', 'AMS01', 'DFW01', 'LHR01', 'PHX01', 'SIN01' )]
    [String] $Location

    [UInt16] $Memory

    [Boolean] $MultiVmVapp

    [AllowEmptyString()]
    [String] $Name

    [Boolean] $NeedsReboot

    [AllowEmptyString()]
    [String] $Notes

    [AllowEmptyString()]
    [String] $OperatingSystem

    [AllowEmptyString()]
    [String] $OS

    [AllowEmptyString()]
    [String] $OsID

    [AllowEmptyCollection()]
    [ArmorVmProduct[]] $Product

    [AllowEmptyString()]
    [String] $ProfileName

    [AllowEmptyString()]
    [String] $Provider

    [UInt16] $ProviderID

    [AllowEmptyString()]
    [String] $ProviderRefID

    [AllowEmptyCollection()]
    [PSCustomObject[]] $ScheduledEvents

    [ArmorStatus] $Status

    [UInt16] $StatusID

    [UInt64] $Storage

    [AllowEmptyCollection()]
    [String[]] $Tags

    [String] $Uuid

    [AllowEmptyString()]
    [String] $VmDateCreated

    [UInt16] $vCenterID

    [ValidateSet(
        '',
        'AMS01T01-VC01',
        'DFW01R01-VC01',
        'DFW01T01-VC01',
        'DFW01T01-VC02',
        'DFW01T01-VC03',
        'DFW01T01-VC04',
        'LHR01T01-VC01',
        'PHX01R01-VC01',
        'PHX01T01-VC01',
        'PHX01T01-VC02',
        'PHX01T01-VC03',
        'SIN01T01-VC01'
    )]
    [String] $vCenterName

    [UInt16] $vCDOrgVdcID

    [Boolean] $VmBackupInProgress

    [UInt16] $VmID

    [AllowEmptyCollection()]
    [PSCustomObject[]] $VmServices

    [UInt16] $WorkloadID

    [AllowEmptyString()]
    [String] $WorkloadName

    [ValidateSet( '', 'AMS01-CD01', 'DFW01-CD01', 'LHR01-CD01', 'PHX01-CD01', 'SIN01-CD01' )]
    [String] $Zone

    #Constructors
    ArmorVM () {}
}
