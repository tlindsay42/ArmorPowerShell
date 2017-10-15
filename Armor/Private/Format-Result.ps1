Function Format-Result
{
	<#
		.SYNOPSIS
		The Format-Result function is used to remove any parent variables surrounding return data, such as encapsulating results in a "data" key.

		.DESCRIPTION
		{ required: more detailed description of the function's purpose }

		.NOTES
		Troy Lindsay
		Twitter: @troylindsay42
		GitHub: tlindsay42

		.PARAMETER Result
		The unformatted API response content.

		.PARAMETER Location
		The key/value pair that contains the name of the key holding the response content's data.

		.INPUTS
		None
			You cannot pipe objects to Format-Result.

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
		[String] $Result = $null,
		[Parameter( Position = 1 )]
		[ValidateNotNullorEmpty()]
		[String] $Location = $null
	)

	Process
	{
		$return = $null

		Write-Verbose -Message 'Formatting return value'

		If ( $Location -and $Result.$Location -ne $null )
		{
			# The $Location check assumes that not all endpoints will require findng (and removing) a parent key
			# If one does exist, this extracts the value so that the $Result data is consistent across API versions
			$return = $Result.$Location
		}
		Else
		{
			# When no $Location is found, return the original $Result
			$return = $Result
		}

		Return $return
	}
}
