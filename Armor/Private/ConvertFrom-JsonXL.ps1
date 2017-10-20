Function ConvertFrom-JsonXL
{
	<#
		.SYNOPSIS
		Helper JSON function to resolve the ConvertFrom-Json maxJsonLength limitation, which defaults to 2MB.
		http://stackoverflow.com/questions/16854057/convertfrom-json-max-length/27125027

		.DESCRIPTION
		{ required: more detailed description of the function's purpose }

		.NOTES
		Troy Lindsay
		Twitter: troylindsay42
		GitHub: tlindsay42

		.PARAMETER InputObject
		The JSON string payload.

		.INPUTS
		System.String

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
		[String] $InputObject = $null
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
		[void][System.Reflection.Assembly]::LoadWithPartialName( 'System.Web.Extensions' )
		
		$javaScriptSerializer = New-Object -TypeName System.Web.Script.Serialization.JavaScriptSerializer -Property @{ 'MaxJsonLength' = 64MB }

		$return = $javaScriptSerializer.DeserializeObject( $InputObject ) |
			ConvertFrom-JsonItem

		Return $return
	} # End of Process

	End
	{
		Write-Verbose -Message ( 'Ending {0}.' -f $function )
	} # End of End
} # End of Function
