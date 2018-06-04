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
