Function Format-ArmorApiResult
{
	<#
		.SYNOPSIS
		The Format-ArmorApiResult function is used to remove any parent variables surrounding return data, such as encapsulating results in a "data" key.

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
		System.Management.Automation.PSCustomObject

		.OUTPUTS
		System.Management.Automation.PSCustomObject

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
		[Parameter( Position = 0, ValueFromPipeline = $true )]
		[PSCustomObject] $Result = $null,
		[Parameter( Position = 1 )]
		[ValidateNotNull()]
		[String] $Location = $null
	)

	Begin
	{
		# The Begin section is used to perform one-time loads of data necessary to carry out the function's purpose
		# If a command needs to be run with each iteration or pipeline input, place it in the Process section

		$function = $MyInvocation.MyCommand.Name

		Write-Verbose -Message ( 'Beginning {0}.' -f $function )
	} # End of Begin

	Process
	{
		$return = $Result

		If ( $return -eq $null ) { Return }

		Write-Verbose -Message 'Formatting return value.'

		If ( $Location -and $Result.$Location -ne $null )
		{
			# The $Location check assumes that not all endpoints will require finding (and removing) a parent key
			# If one does exist, this extracts the value so that the $Result data is consistent across API versions
			$return = $Result.$Location
		}

		Return $return
	} # End of Process

	End
	{
		Write-Verbose -Message ( 'Ending {0}.' -f $function )
	} # End of End
} # End of Function
