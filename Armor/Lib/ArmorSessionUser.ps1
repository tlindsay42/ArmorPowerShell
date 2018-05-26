Class ArmorSessionUser {
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
