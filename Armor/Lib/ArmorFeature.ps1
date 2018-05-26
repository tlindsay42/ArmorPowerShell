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
