Function Disconnect-Armor
{
	<#
		.SYNOPSIS
		Disconnects from Armor and destroys the session information.

		.DESCRIPTION
		{ required: more detailed description of the function's purpose }

		.NOTES
		Troy Lindsay
		Twitter: @troylindsay42
		GitHub: tlindsay42

		.INPUTS
		None
			You cannot pipe objects to Disonnect-Armor.

		.OUTPUTS
		None

		.LINK
		https://github.com/tlindsay42/ArmorPowerShell

		.LINK
		https://docs.armor.com/display/KBSS/Armor+API+Guide

		.LINK
		https://developer.armor.com/

		.EXAMPLE
		Disconnect-Armor
	#>

	[CmdletBinding( SupportsShouldProcess = $true, ConfirmImpact = 'High' )]
	Param ()

	Begin
	{
		# The Begin section is used to perform one-time loads of data necessary to carry out the function's purpose
		# If a command needs to be run with each iteration or pipeline input, place it in the Process section

		# API data references the name of the function
		# For convenience, that name is saved here to $function
		$function = $MyInvocation.MyCommand.Name

		Write-Verbose -Message ( 'Beginning {0}.' -f $function )
	} # End of Begin

	Process
	{
		If ( $PSCmdlet.ShouldProcess( 'Armor session', 'Disconnect' ) )
		{
			# Retrieve all of the URI, method, body, query, location, filter, and success details for the API endpoint
			Write-Verbose -Message 'Disconnecting from Armor.'

			Remove-Variable -Name ArmorConnection -Scope Global
		}
	} # End of Process

	End
	{
		Write-Verbose -Message ( 'Ending {0}.' -f $function )
	} # End of End
} # End of Function
