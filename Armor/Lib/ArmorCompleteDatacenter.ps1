Class ArmorCompleteDatacenter {
    [ValidateRange( 1, 5 )]
    [UInt16]
    $ID

    [ValidateSet( 'AMS01', 'DFW01', 'LHR01', 'PHX01', 'SIN01' )]
    [String]
    $Location

    [ValidateSet( 'AS East', 'EU Central', 'EU West', 'US Central', 'US West' )]
    [String]
    $Name

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
    [String[]]
    $Zones

    #Constructors
    ArmorCompleteDatacenter () {}
}
