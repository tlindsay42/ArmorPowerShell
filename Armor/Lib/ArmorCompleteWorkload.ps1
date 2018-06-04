foreach ( $className in 'ArmorCompleteWorkloadTier', 'ArmorStatus' ) {
    $classPath = Split-Path -Path $MyInvocation.MyCommand.Path -Parent |
        Join-Path -ChildPath "${className}.ps1"
    . $classPath
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
