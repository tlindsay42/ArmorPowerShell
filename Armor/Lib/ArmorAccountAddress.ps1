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
