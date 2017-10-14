Function Test-FilterObject
{
	<#
		.SYNOPSIS
		The Test-FilterObject function is used to filter data that has been returned from an endpoint for specific objects important to the user.

		.DESCRIPTION
		{ required: more detailed description of the function's purpose }

		.NOTES
		Troy Lindsay
		Twitter: @troylindsay42
		GitHub: tlindsay42

		.PARAMETER Filter
		The list of parameters that the user can use to filter response data. Each key is the parameter name without the "$" and each value corresponds to the response data's key.

		.PARAMETER Result
		The formatted API response content.

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
		[Hashtable] $Filter = $null,
		[Parameter( Position = 1 )]
		[ValidateNotNullorEmpty()]
		[String] $Result = $null
	)

	Process
	{
		$return = $null

		Write-Verbose -Message 'Filter the results'

		ForEach ( $parameter In $Filter.Keys )
		{
			If ( ( Get-Variable -Name $parameter -ErrorAction SilentlyContinue ).Value -ne $null )
			{
				Write-Verbose -Message ( 'Filter match = {0}' -f $parameter )

				$return = Test-ReturnFilter -Object ( Get-Variable -Name $parameter ).Value -Location $Filter[$parameter] -Result $Result

				Break
			}
		}
    
		Return $return
	}
}
