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
