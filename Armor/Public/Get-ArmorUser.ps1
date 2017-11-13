Function Get-ArmorUser
{
	<#
		.SYNOPSIS
		The Get-ArmorVm retrieves a list of users in your account.

		.DESCRIPTION
		{ required: more detailed description of the function's purpose }

		.NOTES
		Troy Lindsay
		Twitter: @troylindsay42
		GitHub: tlindsay42

		.PARAMETER ID
		{ required: description of the specified input parameter's purpose }

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

	[CmdletBinding()]
	Param
	(
		[Parameter( Position = 0 )]
		[ValidateNotNullOrEmpty()]
		[String] $UserName = '',
		[ValidateNotNullOrEmpty()]
		[String] $FirstName = '',
		[ValidateNotNullOrEmpty()]
		[String] $LastName = '',
		[ValidateRange( 1, 65535 )]
		[UInt16] $ID = 0,
		[Parameter( Position = 1 )]
		[ValidateScript( { $_ -match '^v\d+\.\d$' } )]
		[String] $ApiVersion = $Global:ArmorConnection.ApiVersion
	)

	Begin
	{
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

		$uri = New-ArmorApiUriString -Endpoints $resources.Uri -IDs $ID

		$uri = New-ArmorApiUriQueryString -QueryKeys $resources.Query.Keys -Parameters ( Get-Command -Name $function ).Parameters.Values -Uri $uri

		$results = Submit-ArmorApiRequest -Uri $uri -Headers $Global:ArmorConnection.Headers -Method $resources.Method

		$results = Expand-ArmorApiResult -Results $results -Location $resources.Location

		$results = Select-ArmorApiResult -Results $results -Filter $resources.Filter

		If ( $results.Count -eq 0 ) { Write-Host -Object 'Armor user not found.' }

		Return $results
	} # End of Process

	End
	{
		Write-Verbose -Message ( 'Ending {0}.' -f $function )
	} # End of End
} # End of Function
