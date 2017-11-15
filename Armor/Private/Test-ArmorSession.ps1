Function Test-ArmorSession
{
	<#
		.SYNOPSIS
		Armor API session test.

		.DESCRIPTION
		Test to see if a session has been established with the Armor API.
		If no token is found, this will throw an error and halt the script.
		Otherwise, the token is loaded into the script's $Header variable.

		.NOTES
		Troy Lindsay
		Twitter: @troylindsay42
		GitHub: tlindsay42

		.INPUTS
		None
			You cannot pipe objects to Test-ArmorSession.

		.OUTPUTS
		None
			Test-ArmorSession has no output.

		.LINK
		https://github.com/tlindsay42/ArmorPowerShell

		.LINK
		https://docs.armor.com/display/KBSS/Armor+API+Guide

		.LINK
		https://developer.armor.com/

		.EXAMPLE
		Test-ArmorSession

		Description
		-----------

		Validates that there is one Armor API connection token stored in '$Global:ArmorSession.Token'.
	#>

	[CmdletBinding()]
	Param()

	Begin
	{
		$function = $MyInvocation.MyCommand.Name

		Write-Verbose -Message ( 'Beginning {0}.' -f $function )
	} # End of Begin

	Process
	{
		Write-Verbose -Message 'Verify that the session authorization exists.'
		If ( -not $Global:ArmorSession )
		{
			Throw 'Session not found.  Please log in again.'
		}
		ElseIf ( -not $Global:ArmorSession.AuthorizationExists() )
		{
			Throw 'Session authorization not found.  Please log in again.'
		}

		Write-Verbose -Message 'Verify that the session is active.'
		If ( $Global:ArmorSession.IsActive() )
		{
			$minutesRemaining = $Global:ArmorSession.GetMinutesRemaining()

			Write-Verbose -Message ( '{0} minutes remaining until session expiration.' -f $minutesRemaining )

			If ( $minutesRemaining -lt 25 )
			{
				Write-Verbose -Message 'Renewing session token.'
				Update-ArmorApiToken -Token $Global:ArmorSession.GetToken()
			}
		}
		Else
		{
			$expirationTime = $Global:ArmorSession.SessionExpirationTime

			Disconnect-Armor -Confirm:$false

			Throw ( 'Session expired at {0}.  Please log in again.' -f $expirationTime )
		}
	} # End of Process

	End
	{
		Write-Verbose -Message ( 'Ending {0}.' -f $function )
	} # End of End
} # End of Function
