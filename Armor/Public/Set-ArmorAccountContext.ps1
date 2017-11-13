Function Set-ArmorAccountContext
{
	<#
		.SYNOPSIS
		Sets the Armor account context, so that all future requests reference the specified account.

		.DESCRIPTION
		{ required: more detailed description of the function's purpose }

		.NOTES
		Troy Lindsay
		Twitter: @troylindsay42
		GitHub: tlindsay42

		.PARAMETER ID
		The Armor account ID to use for all subsequent requests.

		.INPUTS
		System.UInt16

		.OUTPUTS
		None

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
		[ValidateScript( { $_ -in ( Get-ArmorIdentity ).Accounts.ID } )]
		[UInt16] $ID = $null
	)

	Begin
	{
		$function = $MyInvocation.MyCommand.Name

		Write-Verbose -Message ( 'Beginning {0}.' -f $function )

		Test-ArmorSession
	} # End of Begin

	Process
	{
		$Global:ArmorSession.SetAccountContext( $ID )

		$Global:ArmorConnection.Headers.'X-Account-Context' = $ID
	} # End of Process

	End
	{
		Write-Verbose -Message ( 'Ending {0}.' -f $function )
	} # End of End
} # End of Function
