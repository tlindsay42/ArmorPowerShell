Class ArmorAccount
{
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

	[PSObject[]] $Products = @()

	#Constructors
	ArmorAccount () {}
}
