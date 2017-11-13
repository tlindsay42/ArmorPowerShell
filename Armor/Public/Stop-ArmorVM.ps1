Function Stop-ArmorVM
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
		[ValidateSet( 'Shutdown', 'Off', 'ForceOff' )]
		[String] $Type = 'Shutdown',
		[Parameter( Position = 2 )]
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
		Write-Verbose -Message ( 'Gather API Data for {0}.' -f $function )
		$resources = Get-ArmorApiData -Endpoint $function -ApiVersion $ApiVersion

		If ( $PSCmdlet.ShouldProcess( $ID, $resources.Description ) )
		{
			$uri = New-ArmorApiUriString -Endpoints $resources.Uri.Where( { $_ -match ( '/{0}$' -f $Type ) } ) -IDs $ID

			$uri = New-ArmorApiUriQueryString -QueryKeys $resources.Query.Keys -Parameters ( Get-Command -Name $function ).Parameters.Values -Uri $uri

			$results = Submit-ArmorApiRequest -Uri $uri -Headers $global:ArmorConnection.Headers -Method $resources.Method

			$results = Expand-ArmorApiResult -Results $results -Location $resources.Location

			$results = Select-ArmorApiResult -Results $results -Filter $resources.Filter

			Return $results
		}
	} # End of Process

	End
	{
		Write-Verbose -Message ( 'Ending {0}.' -f $function )
	} # End of End
} # End of Function
