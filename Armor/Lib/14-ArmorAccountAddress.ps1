Class ArmorAccountAddress
{
	[ValidateRange( 1, 65535 )]
	[UInt16] $AccountID

	[ValidateNotNullOrEmpty()]
	[String] $Name

	[String] $AddressLine1

	[String] $AddressLine2

	[String] $City

	[String] $State

	[String] $PostalCode

	[String] $Country

	#Constructors
	ArmorAccountAddress () {}
}
