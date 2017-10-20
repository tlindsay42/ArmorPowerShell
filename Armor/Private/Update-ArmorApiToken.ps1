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
		The API version.  The default value is $global:ArmorConnection.ApiVersion.

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
		[String] $Token = $global:ArmorConnection.Token,
		[Parameter( Position = 1 )]
		[ValidateScript( { $_ -match '^v\d+\.\d$' } )]
		[String] $ApiVersion = $global:ArmorConnection.ApiVersion
	)

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
		# Retrieve all of the URI, method, body, query, location, filter, and success details for the API endpoint
		Write-Verbose -Message ( 'Gather API Data for {0}.' -f $function )

		$resources = Get-ArmorApiData -Endpoint $function -ApiVersion $ApiVersion

		$uri = New-ArmorApiUriString -Server $global:ArmorConnection.Server -Port $global:ArmorConnection.Port -Endpoints $resources.Uri

		$uri = New-ArmorApiUriQueryString -QueryKeys $resources.Query.Keys -Parameters ( Get-Command -Name $function ).Parameters.Values -Uri $uri

		$body = Format-ArmorApiJsonRequestBody -BodyKeys $resources.Body.Keys -Parameters ( Get-Command -Name $function ).Parameters.Values

		$result = Submit-ArmorApiRequest -Uri $uri -Headers $global:ArmorConnection.Headers -Method $resources.Method -Body $body

		$result = Format-ArmorApiResult -Result $result -Location $resources.Location

		$result = Select-ArmorApiResult -Result $result -Filter $resources.Filter

		$global:ArmorConnection.Token = $result.Access_Token
		$global:ArmorConnection.SessionExpirationTime = ( Get-Date ).AddSeconds( $result.Expires_In )
		$global:ArmorConnection.Headers.Authorization = $global:ArmorConnection.Headers.Authorization -replace '\w+$', $result.Access_Token

		Return $result
	} # End of Process

	End
	{
		Write-Verbose -Message ( 'Ending {0}.' -f $function )
	}
} # End of Function
