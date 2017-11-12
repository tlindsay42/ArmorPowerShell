Function Restart-ArmorVM
{
	<#
		.SYNOPSIS
		{ required: high level overview }

		.DESCRIPTION
		{ required: more detailed description of the function's purpose }

		.NOTES
		Name Troy Lindsay
		Twitter: @troylindsay42
		GitHub: tlindsay42

		.PARAMETER ID
		The ID of a VM in the Armor account.  The default value is 0.

		.PARAMETER ApiVersion
		The API version.  The default value is $Global:ArmorConnection.ApiVersion.

		.INPUTS
		{ required: .NET Framework object types that can be piped in and a description of the input objects }

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

	[CmdletBinding( SupportsShouldProcess = $true, ConfirmImpact = 'High' )]
	Param
	(
		[Parameter( Position = 0 )]
		[ValidateRange( 1, 65535 )]
		[UInt16] $ID = 0,
		[Parameter( Position = 1 )]
		[ValidateScript( { $_ -match '^v\d+\.\d$' } )]
		[String] $ApiVersion = $Global:ArmorConnection.ApiVersion
	)

	Begin
	{
		# The Begin section is used to perform one-time loads of data necessary to carry out the function's purpose
		# If a command needs to be run with each iteration or pipeline input, place it in the Process section

		# API data references the name of the function
		# For convenience, that name is saved here to $function
		$function = $MyInvocation.MyCommand.Name

		Write-Verbose -Message ( 'Beginning {0}.' -f $function )

		# Check to ensure that a session to the Armor cluster exists and load the needed header data for authentication
		Test-ArmorConnection
	} # End of Begin

	Process
	{
		# Retrieve all of the URI, method, body, query, location, filter, and success details for the API endpoint
		Write-Verbose -Message ( 'Gather API Data for {0}.' -f $function )
		
		$resources = Get-ArmorApiData -Endpoint $function -ApiVersion $ApiVersion

		If ( $PSCmdlet.ShouldProcess( $ID, $resources.Description ) )
		{
			$uri = New-ArmorApiUriString -Endpoints $resources.Uri -IDs $ID

			$results = Select-ArmorApiResult -Results $results -Filter $resources.Filter

			Return $results
		}
	} # End of Process

	End
	{
		Write-Verbose -Message ( 'Ending {0}.' -f $function )
	} # End of End
} # End of Function
