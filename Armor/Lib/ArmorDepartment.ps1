Class ArmorDepartment {
    [ValidateRange( 1, 65535 )]
    [UInt16] $ID

    [ValidateNotNullOrEmpty()]
    [String] $Name

    [ValidateRange( 1, 65535 )]
    [UInt16] $Account

    #Constructors
    ArmorDepartment () {}
}
