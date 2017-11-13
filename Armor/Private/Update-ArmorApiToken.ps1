Function Update-ArmorApiToken
{
	<#
		.SYNOPSIS
		Reissues an authentication token if requested prior to session expiration.

		.DESCRIPTION
		{ required: more detailed description of the function's purpose }

		.NOTES
		Troy Lindsay
		Twitter: @troylindsay42
		GitHub: tlindsay42

		.PARAMETER Token
		The authorization token.

		.PARAMETER ApiVersion
		The API version.  The default value is $Global:ArmorConnection.ApiVersion.

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
		Update-ArmorApiToken -Token 2261bac252204c2ea93ed32ea1ffd3ab -ApiVersion 'v1.0'
	#>

	[CmdletBinding()]
	Param
	(
		[Parameter( ValueFromPipeline = $true, Position = 0 )]
		[ValidateNotNullorEmpty()]
		[String] $Token = $Global:ArmorConnection.Token,
		[Parameter( Position = 1 )]
		[ValidateScript( { $_ -match '^v\d+\.\d$' } )]
		[String] $ApiVersion = $Global:ArmorConnection.ApiVersion
	)

	Begin
	{
		$function = $MyInvocation.MyCommand.Name

		Write-Verbose -Message ( 'Beginning {0}.' -f $function )
	} # End of Begin

	Process
	{
		# Retrieve all of the URI, method, body, query, location, filter, and success details for the API endpoint
		Write-Verbose -Message ( 'Gather API Data for {0}.' -f $function )

		$resources = Get-ArmorApiData -Endpoint $function -ApiVersion $ApiVersion

		$uri = New-ArmorApiUriString -Endpoints $resources.Uri

		$body = Format-ArmorApiJsonRequestBody -BodyKeys $resources.Body.Keys -Parameters ( Get-Command -Name $function ).Parameters.Values

		$results = Submit-ArmorApiRequest -Uri $uri -Headers $Global:ArmorConnection.Headers -Method $resources.Method -Body $body

		$results = Expand-ArmorApiResult -Results $results -Location $resources.Location

		$results = Select-ArmorApiResult -Results $results -Filter $resources.Filter

		$Global:ArmorConnection.Token = $results.Access_Token
		$Global:ArmorConnection.SessionExpirationTime = ( Get-Date ).AddSeconds( $results.Expires_In )
		$Global:ArmorConnection.Headers.Authorization = $Global:ArmorConnection.Headers.Authorization -replace '\w+$', $results.Access_Token

		Return $results
	} # End of Process

	End
	{
		Write-Verbose -Message ( 'Ending {0}.' -f $function )
	}
} # End of Function
