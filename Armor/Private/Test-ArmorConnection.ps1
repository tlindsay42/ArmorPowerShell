Function Test-ArmorConnection
{
	<#
		.SYNOPSIS
		Armor API session test.

		.DESCRIPTION
		Test to see if a session has been established with the Armor API.
		If no token is found, this will throw an error and halt the script.
		Otherwise, the token is loaded into the script's $Header variable.

		.NOTES
		Written by Troy Lindsay
		Twitter: @troylindsay42
		GitHub: tlindsay42

		.LINK
		https://github.com/tlindsay42/ArmorPowerShell

		.EXAMPLE
		Test-ArmorConnection
	#>

	Process
	{
		Write-Verbose -Message 'Validate that the Armor token exists.'
		
		If ( -not $global:ArmorConnection.Token )
		{
			Write-Warning -Message 'Please connect to only one Armor API session before running this command.'
			Throw 'A single connection with Connect-Armor is required.'
		}

		Write-Verbose -Message 'Found an Armor token for authentication.'

		$script:Header = $global:ArmorConnection.Header
	} # End of Process
} # End of Function
