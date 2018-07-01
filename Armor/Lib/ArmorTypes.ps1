#region Enums
enum ArmorStatus {
    # https://docs.armor.com/display/KBSS/Get+VM+Detail#GetVMDetail-Output
    # https://docs.armor.com/display/KBSS/Get+Workload#GetWorkload-Output

    # The object could not be created
    FAILED_CREATION = -1

    # The object is unresolved
    UNRESOLVED = 0

    # The object is resolved
    RESOLVED = 1

    # The object is deployed
    DEPLOYED = 2

    # The object is suspended
    SUSPENDED = 3

    # The object is powered on
    POWERED_ON = 4

    # The object is waiting for user input
    WAITING_FOR_INPUT = 5

    # The object is in an unknown state
    UNKNOWN = 6

    # The object is in an unrecognized state
    UNRECOGNIZED = 7

    # The object is in an unrecognized state
    POWERED_OFF = 8

    # The object is in an inconsistent
    INCONSISTENT_STATE = 9

    # Children do not all have the same status
    MIXED = 10

    # Upload initiated, OVF descriptor pending
    DESCRIPTION_PENDING = 11

    # Upload initiated, copying contents
    COPYING_CONTENTS = 12

    # Upload initiated, disk contents pending
    DISK_CONTENTS_PENDING = 13

    # Upload has been quarantined
    QUARANTINED = 14

    # Upload quarantine period has expired
    QUARANTINE_EXPIRED = 15

    # Upload has been rejected
    REJECTED = 16

    # Upload transfer session timed out
    TRANSFER_TIMEOUT = 17

    # The vApp is resolved and undeployed
    VAPP_UNDEPLOYED = 18

    # The vApp is resolved and partially deployed
    VAPP_PARTIALLY_DEPLOYED = 19

    # Undocumented at this time
    CHANGES_PENDING = 100

    # Undocumented at this time
    COMPLETE = 101

    # Undocumented at this time
    BUSY = 102

    # Undocumented at this time
    TEMPLATE_PENDING = 103
}
#endregion


#region Classes with no dependencies
class ArmorAccount {
    [ValidateRange( 1, 65535 )]
    [UInt16] $ID

    [ValidateNotNullOrEmpty()]
    [String] $Name

    [ValidateNotNullOrEmpty()]
    [String] $Currency

    [ValidateNotNullOrEmpty()]
    [String] $Status

    [ValidateRange( -1, 65535 )]
    [Int32] $Parent

    [AllowNull()]
    [PSObject[]] $Products = @()

    #Constructors
    ArmorAccount () {}
}


class ArmorAccountAddress {
    [ValidateRange( 1, 65535 )]
    [UInt16] $AccountID

    [ValidateNotNullOrEmpty()]
    [String] $Name

    [ValidateNotNullOrEmpty()]
    [String] $AddressLine1

    [AllowEmptyString()]
    [String] $AddressLine2

    [ValidateNotNullOrEmpty()]
    [String] $City

    [ValidateNotNullOrEmpty()]
    [String] $State

    [ValidateNotNullOrEmpty()]
    [String] $PostalCode

    [ValidateNotNullOrEmpty()]
    [String] $Country

    #Constructors
    ArmorAccountAddress () {}
}


class ArmorCompleteDatacenter {
    [ValidateRange( 1, 5 )]
    [UInt16] $ID

    [ValidateSet( 'AMS01', 'DFW01', 'LHR01', 'PHX01', 'SIN01' )]
    [String] $Location

    [ValidateSet( 'AS East', 'EU Central', 'EU West', 'US Central', 'US West' )]
    [String] $Name

    [ValidateSet(
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
    [String[]] $Zones

    #Constructors
    ArmorCompleteDatacenter () {}
}


class ArmorDepartment {
    [ValidateRange( 1, 65535 )]
    [UInt16] $ID

    [ValidateNotNullOrEmpty()]
    [String] $Name

    [ValidateRange( 1, 65535 )]
    [UInt16] $Account

    #Constructors
    ArmorDepartment () {}
}


class ArmorDisk {
    [ValidateRange( 1, 4294967295 )]
    [UInt32] $ID

    [ValidateRange( 1, 9223372036854775807 )]
    [UInt64] $Capacity

    [ValidatePattern( '^Disk (?:[1-9]|[1-5][0-9]|60)$' )]
    [String] $Name

    [ValidateSet( 'SSD', 'Fluid', 'Raw' )]
    [String] $Type

    #Constructors
    ArmorDisk () {}
}


class ArmorFeature {
    [ValidateRange( 1, 65535 )]
    [UInt16] $AccountID

    [ValidateNotNullOrEmpty()]
    [String] $Feature

    [ValidateRange( 1, 65535 )]
    [UInt16] $ProductID

    [ValidateRange( 0, 65535 )]
    [UInt16] $FeatureID

    #Constructors
    ArmorFeature () {}
}


class ArmorPhoneNumber {
    [ValidateRange( 1, 999 )]
    [UInt16] $CountryCode

    [AllowEmptyString()]
    [String] $CountryIsoCode

    [ValidateNotNullOrEmpty()]
    [String] $Number

    [AllowNull()]
    [String] $PhoneExt

    #Constructors
    ArmorPhoneNumber () {}
}


class ArmorScheduledEvent {
    [ValidateRange( 1, 65535 )]
    [UInt16] $EntityType

    [ValidateRange( 1, 65535 )]
    [UInt16] $EntityID

    [ValidateNotNullOrEmpty()]
    [String] $Action

    [DateTime] $TaskDate

    [ValidateRange( 1, 65535 )]
    [UInt16] $MaintenanceWindow

    #Constructors
    ArmorScheduledEvent () {}
}


class ArmorSessionUser {
    [ValidateNotNullOrEmpty()]
    [String] $Type

    [ValidatePattern( '^[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,}$' )]
    [Alias( 'Name' )]
    [String] $UserName

    [ValidateNotNullOrEmpty()]
    [String] $FirstName

    [ValidateNotNullOrEmpty()]
    [String] $LastName

    [ValidateNotNull()]
    [PSCustomObject[]] $Links = @()

    #Constructors
    ArmorSessionUser () {}
}


class ArmorVmProduct {
    [ValidateNotNullOrEmpty()]
    [String] $SKU

    [AllowEmptyString()]
    [String] $Size

    [Boolean] $IsExpired

    [AllowEmptyString()]
    [String] $StoragePolicyClass

    #Constructors
    ArmorVmProduct () {}
}
#endregion


#region Classes with dependencies
class ArmorSession {
    [ValidateNotNull()]
    [ArmorSessionUser] $User

    [ValidateNotNull()]
    [ArmorAccount[]] $Accounts = @()

    [ValidateNotNull()]
    [ArmorDepartment[]] $Departments = @()

    [ValidateNotNull()]
    [PSObject[]] $Permissions = @()

    [ValidateNotNull()]
    [ArmorFeature[]] $Features = @()

    [ValidateNotNullOrEmpty()]
    [String] $Server = 'api.armor.com'

    [ValidateRange( 1, 65535 )]
    [UInt16] $Port = 443

    [ValidateRange( 1, 15 )]
    [UInt16] $SessionLengthInMinutes

    [ValidateNotNull()]
    [DateTime] $SessionStartTime

    [ValidateNotNull()]
    [DateTime] $SessionExpirationTime

    [ValidateSet( 'v1.0', 'internal' )]
    [String] $ApiVersion = 'v1.0'

    [ValidateSet( 'X-Account-Context' )]
    Hidden [String] $AccountContextHeader = 'X-Account-Context'

    [ValidateSet( 'FH-AUTH' )]
    Hidden [String] $AuthenticationType = 'FH-AUTH'

    [ValidateSet( 'application/json' )]
    Hidden [String] $MediaType = 'application/json'

    [ValidateNotNull()]
    Hidden [Hashtable] $Headers = @{}

    # Constructors
    ArmorSession () {
        $this.SessionExpirationTime = Get-Date
        $this.Headers.Add( 'Accept', $this.MediaType )
        $this.Headers.Add( 'Content-Type', $this.MediaType )
    }

    ArmorSession (
        [String] $Server,
        [UInt16] $Port,
        [String] $ApiVersion
    ) {
        $this.Server = $Server
        $this.Port = $Port
        $this.ApiVersion = $ApiVersion
        $this.SessionExpirationTime = Get-Date
        $this.Headers.Add( 'Accept', $this.MediaType )
        $this.Headers.Add( 'Content-Type', $this.MediaType )
    }

    [Boolean] AuthorizationExists () {
        [Boolean] $return = $false

        if ( $this.Headers.Authorization -match "^$( $this.AuthenticationType ) [a-z0-9]+$" ) {
            $return = $true
        }

        return $return
    }

    [Void] Authorize (
        [String] $AccessToken,
        [UInt16] $SessionLengthInMinutes
    ) {
        $now = Get-Date

        if ( $AccessToken -notmatch '^[a-z0-9]{32}$' ) {
            throw "Invalid access token: '${AccessToken}'."
        }

        if ( $this.SessionStartTime -eq '0001-01-01 00:00:00' ) {
            $this.SessionStartTime = $now
        }

        $this.SessionLengthInMinutes = $SessionLengthInMinutes
        $this.SessionExpirationTime = $now.AddMinutes( $this.SessionLengthInMinutes )
        $this.Headers.Authorization = "$( $this.AuthenticationType ) ${AccessToken}"
    }

    [ArmorAccount] GetAccountContext () {
        [ArmorAccount] $return = $null

        if ( $this.Headers.ContainsKey( $this.AccountContextHeader ) ) {
            $return = $this.Accounts.Where( { $_.ID -eq $this.Headers.( $this.AccountContextHeader ) } ) |
                Select-Object -First 1
        }
        else {
            throw 'The account context has not been set.'
        }

        return $return
    }

    [UInt16] GetAccountContextID () {
        [UInt16] $return = 0

        if ( $this.Headers.ContainsKey( $this.AccountContextHeader ) ) {
            $return = $this.Headers.( $this.AccountContextHeader )
        }
        else {
            throw 'The account context has not been set.'
        }

        return $return
    }

    [Int32] GetMinutesRemaining () {
        [Int32] $return = ( $this.SessionExpirationTime - ( Get-Date ) ).Minutes

        return $return
    }

    [Int32] GetSecondsRemaining () {
        [Int32] $return = ( $this.SessionExpirationTime - ( Get-Date ) ).Seconds

        return $return
    }

    [String] GetToken () {
        [String] $return = ''

        if ( $this.Headers.ContainsKey( 'Authorization' ) ) {
            if ( $this.Headers.Authorization -match "^$( $this.AuthenticationType ) [a-z0-9]+$" ) {
                $return = $this.Headers.Authorization.Split( ' ' )[-1]
            }
            elseif ( $this.Headers.Authorization -eq $null ) {
                throw 'The session has not been authorized.'
            }
            else {
                throw 'Invalid authorization.'
            }
        }
        else {
            throw 'The session has not been authorized.'
        }

        return $return
    }

    [Boolean] IsActive () {
        [Boolean] $return = $false

        if ( $this.SessionExpirationTime -gt ( Get-Date ) ) {
            $return = $true
        }

        return $return
    }

    [ArmorAccount] SetAccountContext (
        [UInt16] $ID
    ) {
        [ArmorAccount] $return = $null

        if ( $this.Accounts.Count -eq 0 ) {
            throw 'Accounts have not been initialized for this Armor API session.'
        }
        elseif ( $ID -in $this.Accounts.ID ) {
            $this.Headers.( $this.AccountContextHeader ) = $ID

            $return = $this.Accounts.Where( { $_.ID -eq $ID } ) |
                Select-Object -First 1
        }
        else {
            throw "Invalid account context: '${ID}'.  Available Armor Account IDs are: '$( $this.Accounts.ID -join ', ' )'."
        }

        return $return
    }
}


class ArmorUser {
    [ValidateRange( 1, 65535 )]
    [UInt16] $ID

    [ValidateSet( 'Enabled', 'Disabled' )]
    [String] $Status

    [AllowEmptyString()]
    [String] $Title

    [ValidateNotNullOrEmpty()]
    [String] $FirstName

    [ValidateNotNullOrEmpty()]
    [String] $LastName

    [ValidatePattern( '^[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,}$' )]
    [Alias( 'UserName' )]
    [String] $Email

    [ValidateNotNull()]
    [Alias( 'Phone' )]
    [ArmorPhoneNumber] $PhonePrimary

    # Populated via [TimeZoneInfo]::GetSystemTimeZones().ID
    [ValidateSet(
        'Dateline Standard Time',
        'UTC-11',
        'Aleutian Standard Time',
        'Hawaiian Standard Time',
        'Marquesas Standard Time',
        'Alaskan Standard Time',
        'UTC-09',
        'Pacific Standard Time (Mexico)',
        'UTC-08',
        'Pacific Standard Time',
        'US Mountain Standard Time',
        'Mountain Standard Time (Mexico)',
        'Mountain Standard Time',
        'Central America Standard Time',
        'Central Standard Time',
        'Easter Island Standard Time',
        'Central Standard Time (Mexico)',
        'Canada Central Standard Time',
        'SA Pacific Standard Time',
        'Eastern Standard Time (Mexico)',
        'Eastern Standard Time',
        'Haiti Standard Time',
        'Cuba Standard Time',
        'US Eastern Standard Time',
        'Turks And Caicos Standard Time',
        'Paraguay Standard Time',
        'Atlantic Standard Time',
        'Venezuela Standard Time',
        'Central Brazilian Standard Time',
        'SA Western Standard Time',
        'Pacific SA Standard Time',
        'Newfoundland Standard Time',
        'Tocantins Standard Time',
        'E. South America Standard Time',
        'SA Eastern Standard Time',
        'Argentina Standard Time',
        'Greenland Standard Time',
        'Montevideo Standard Time',
        'Magallanes Standard Time',
        'Saint Pierre Standard Time',
        'Bahia Standard Time',
        'UTC-02',
        'Mid-Atlantic Standard Time',
        'Azores Standard Time',
        'Cape Verde Standard Time',
        'UTC',
        'Morocco Standard Time',
        'GMT Standard Time',
        'Greenwich Standard Time',
        'W. Europe Standard Time',
        'Central Europe Standard Time',
        'Romance Standard Time',
        'Sao Tome Standard Time',
        'Central European Standard Time',
        'W. Central Africa Standard Time',
        'Jordan Standard Time',
        'GTB Standard Time',
        'Middle East Standard Time',
        'Egypt Standard Time',
        'E. Europe Standard Time',
        'Syria Standard Time',
        'West Bank Standard Time',
        'South Africa Standard Time',
        'FLE Standard Time',
        'Israel Standard Time',
        'Kaliningrad Standard Time',
        'Sudan Standard Time',
        'Libya Standard Time',
        'Namibia Standard Time',
        'Arabic Standard Time',
        'Turkey Standard Time',
        'Arab Standard Time',
        'Belarus Standard Time',
        'Russian Standard Time',
        'E. Africa Standard Time',
        'Iran Standard Time',
        'Arabian Standard Time',
        'Astrakhan Standard Time',
        'Azerbaijan Standard Time',
        'Russia Time Zone 3',
        'Mauritius Standard Time',
        'Saratov Standard Time',
        'Georgian Standard Time',
        'Caucasus Standard Time',
        'Afghanistan Standard Time',
        'West Asia Standard Time',
        'Ekaterinburg Standard Time',
        'Pakistan Standard Time',
        'India Standard Time',
        'Sri Lanka Standard Time',
        'Nepal Standard Time',
        'Central Asia Standard Time',
        'Bangladesh Standard Time',
        'Omsk Standard Time',
        'Myanmar Standard Time',
        'SE Asia Standard Time',
        'Altai Standard Time',
        'W. Mongolia Standard Time',
        'North Asia Standard Time',
        'N. Central Asia Standard Time',
        'Tomsk Standard Time',
        'China Standard Time',
        'North Asia East Standard Time',
        'Singapore Standard Time',
        'W. Australia Standard Time',
        'Taipei Standard Time',
        'Ulaanbaatar Standard Time',
        'North Korea Standard Time',
        'Aus Central W. Standard Time',
        'Transbaikal Standard Time',
        'Tokyo Standard Time',
        'Korea Standard Time',
        'Yakutsk Standard Time',
        'Cen. Australia Standard Time',
        'AUS Central Standard Time',
        'E. Australia Standard Time',
        'AUS Eastern Standard Time',
        'West Pacific Standard Time',
        'Tasmania Standard Time',
        'Vladivostok Standard Time',
        'Lord Howe Standard Time',
        'Bougainville Standard Time',
        'Russia Time Zone 10',
        'Magadan Standard Time',
        'Norfolk Standard Time',
        'Sakhalin Standard Time',
        'Central Pacific Standard Time',
        'Russia Time Zone 11',
        'New Zealand Standard Time',
        'UTC+12',
        'Fiji Standard Time',
        'Kamchatka Standard Time',
        'Chatham Islands Standard Time',
        'UTC+13',
        'Tonga Standard Time',
        'Samoa Standard Time',
        'Line Islands Standard Time'
    )]
    [String] $TimeZone

    [ValidateNotNull()]
    [CultureInfo] $Culture

    [Boolean] $IsMfaEnabled = $true

    [ValidateSet( 'PhoneApp', 'VoiceCall' )]
    [String] $MfaMode

    [ValidateSet( 'Standard' )]
    [String] $MfaPinMode

    [ValidateRange( 1, 65535 )]
    [AllowEmptyCollection()]
    [UInt16[]] $Permissions = @()

    [ValidateNotNull()]
    [DateTime] $LastModified

    [ValidateNotNull()]
    [DateTime] $PasswordLastSet

    [Boolean] $MustChangePassword

    [ValidateNotNull()]
    [DateTime] $LastLogin

    #Constructors
    ArmorUser () {}
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

    [AllowEmptyString()]
    [String] $OsProvider

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
    [ArmorScheduledEvent[]] $ScheduledEvents

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


class ArmorCompleteWorkloadTier {
    [ValidateRange( 1, 65535 )]
    [UInt16] $ID

    [ValidateNotNullOrEmpty()]
    [String] $Name

    [AllowEmptyCollection()]
    [ArmorVM[]] $VMs
}


class ArmorCompleteWorkload {
    [ValidateRange( 1, 65535 )]
    [UInt16] $ID

    [ValidateNotNullOrEmpty()]
    [String] $Name

    [ValidateSet( '', 'AMS01', 'DFW01', 'LHR01', 'PHX01', 'SIN01' )]
    [String] $Location

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
    [String] $Zone

    [ArmorStatus] $Status

    [Boolean] $Deployed

    [UInt16] $TierCount

    [UInt16] $VmCount

    [UInt16] $TotalCPU

    [UInt16] $TotalMemory

    [UInt64] $TotalStorage

    [Boolean] $IsRecoveryWorkload

    [AllowEmptyCollection()]
    [ArmorCompleteWorkloadTier[]] $Tiers

    [AllowEmptyString()]
    [String] $Notes

    [UInt16] $Health

    [AllowEmptyCollection()]
    [String[]] $Tags

    #Constructors
    ArmorCompleteWorkload () {}
}
#endregion
