Function Get-ArmorVM
{
	<#
		.SYNOPSIS
		The Get-ArmorVM function displays a list of virtual machines in your account.

		.DESCRIPTION
		{ required: more detailed description of the function's purpose }

		.NOTES
		Troy Lindsay
		Twitter: @troylindsay42
		GitHub: tlindsay42

		.PARAMETER Name
		The name of a VM in the Armor account.  Wildcard matches are supported.  The default value is null.

		.PARAMETER ID
		The ID of a VM in the Armor account.  The default value is 0.

		.PARAMETER ApiVersion
		The API version.  The default value is $Global:ArmorSession.ApiVersion.

		.INPUTS
		None
			You cannot pipe objects to Get-ArmorVM.

		.OUTPUTS
		System.Management.Automation.PSCustomObject[]

		.LINK
		https://github.com/tlindsay42/ArmorPowerShell

		.LINK
		https://docs.armor.com/display/KBSS/Armor+API+Guide

		.LINK
		https://developer.armor.com/

		.EXAMPLE
		Get-ArmorVM

		Description
		-----------

		Returns all VMs in the Armor account that currently has context.

		.EXAMPLE
		Get-ArmorVM -Name ARMO25VML01-gen4

		Description
		-----------

		Returns the specified VM in the Armor account that currently has context.

		.EXAMPLE
		Get-ArmorVM -Name *-gen4

		Description
		-----------

		Returns all VMs in the Armor account that currently has context that have a name that ends with '-gen4'.

		.EXAMPLE
		Get-ArmorVM -Name *hacked*

		Description
		-----------

		Returns null.
	#>

	[CmdletBinding()]
	Param
	(
		[Parameter( Position = 0 )]
		[String] $Name = '',
		[ValidateRange( 1, 65535 )]
		[UInt16] $ID = 0,
		[Parameter( Position = 1 )]
		[ValidateSet( 'v1.0' )]
		[String] $ApiVersion = $Global:ArmorSession.ApiVersion
	)

	Begin
	{
		$function = $MyInvocation.MyCommand.Name

		Write-Verbose -Message ( 'Beginning {0}.' -f $function )

		Test-ArmorSession
	} # End of Begin

	Process
	{
		Write-Verbose -Message ( 'Gather API Data for {0}.' -f $function )
		$resources = Get-ArmorApiData -Endpoint $function -ApiVersion $ApiVersion

		$uri = New-ArmorApiUriString -Endpoints $resources.Uri -IDs $ID

		$uri = New-ArmorApiUriQueryString -QueryKeys $resources.Query.Keys -Parameters ( Get-Command -Name $function ).Parameters.Values -Uri $uri

		$results = Submit-ArmorApiRequest -Uri $uri -Method $resources.Method

		$results = Select-ArmorApiResult -Results $results -Filter $resources.Filter

		If ( $results.Count -eq 0 ) { Write-Host -Object 'Armor VM not found.' }

		Return $results
	} # End of Process

	End
	{
		Write-Verbose -Message ( 'Ending {0}.' -f $function )
	} # End of End
} # End of Function
