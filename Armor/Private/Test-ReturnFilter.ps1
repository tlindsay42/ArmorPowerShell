Function Test-ReturnFilter
{
	<#
		.SYNOPSIS
		The Test-ReturnFilter function is used to perform a search across response content for a particular value.

		.DESCRIPTION
		{ required: more detailed description of the function's purpose }

		.NOTES
		Troy Lindsay
		Twitter: @troylindsay42
		GitHub: tlindsay42

		.PARAMETER Object
		The parent function's variable holding the user generated query data.

		.PARAMETER Location
		The key/value pair that contains the name of the key holding the data to filter through.

		.PARAMETER Result
		The unfiltered API response content.

		.INPUTS
		None
			You cannot pipe objects to Test-FilterObject.

		.OUTPUTS
		{ required: .NET Framework object types that the cmdlet returns and a description of the returned objects }

		.LINK
		https://github.com/tlindsay42/ArmorPowerShell

		.LINK
		https://docs.armor.com/display/KBSS/Armor+API+Guide

		.LINK
		https://developer.armor.com/

		.EXAMPLE
		{required: show one or more examples using the function}
	#>

	[CmdletBinding()]
	Param
	(
		[Parameter( Position = 0 )]
		[ValidateNotNullorEmpty()]
		[String] $Object,
		[Parameter( Position = 1 )]
		[ValidateNotNullorEmpty()]
		[String] $Location,
		[Parameter( Position = 2 )]
		[ValidateNotNullorEmpty()]
		[String] $Result
	)

	Process
	{
		$return = $null

		# For when a location is one layer deep
		If ( $Object -and $Location.Split( '.' ).Count -eq 1 )
		{
			# The $object check assumes that not all filters will be used in each call
			# If it does exist, the results are filtered using the $object's value against the $location's key name
			$return = $Result.Where( { $_.$Location -eq $Object } )
		}
		# For when a location is two layers deep
		ElseIf ( $Object -and $Location.Split( '.' ).Count -eq 2 )
		{
			# The $Object check assumes that not all filters will be used in each call
			# If it does exist, the results are filtered using the $Object's value against the $Location's key name
			$return = $Result.Where( { $_.( $Location.Split( '.' )[0] ).( $Location.Split( '.' )[-1]) -eq $Object } )
		}
		Else
		{
			# When no $location is found, return the original $result
			$return = $Result
		}

		Return $return
	}
}
