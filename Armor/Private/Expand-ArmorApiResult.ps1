Function Expand-ArmorApiResult
{
	<#
		.SYNOPSIS
		The Expand-ArmorApiResult function is used to remove any parent variables surrounding return data, such as encapsulating results in a "data" key.

		.DESCRIPTION
		{ required: more detailed description of the function's purpose }

		.NOTES
		Troy Lindsay
		Twitter: @troylindsay42
		GitHub: tlindsay42

		.PARAMETER Results
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
		[PSCustomObject[]] $Results = @(),
		[Parameter( Position = 1 )]
		[ValidateNotNull()]
		[String] $Location = $null
	)

	Begin
	{
		$function = $MyInvocation.MyCommand.Name

		Write-Verbose -Message ( 'Beginning {0}.' -f $function )
	} # End of Begin

	Process
	{
		$return = @()

		If ( $Results.Count -eq 0 ) { Return $Results }

		Write-Verbose -Message 'Formatting return values.'

		ForEach ( $result In $Results )
		{
			If ( $Location -and $result.$Location -ne $null )
			{
				# The $Location check assumes that not all endpoints will require finding (and removing) a parent key
				# If one does exist, this extracts the value so that the $result data is consistent across API versions
				$return += $result.$Location
			}
		}

		If ( $return.Count -eq 0 ) { $return = $Results }

		Return $return
	} # End of Process

	End
	{
		Write-Verbose -Message ( 'Ending {0}.' -f $function )
	} # End of End
} # End of Function
