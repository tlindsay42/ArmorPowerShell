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
