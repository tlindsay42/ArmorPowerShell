Function Get-ArmorAccountAddress
{
	<#
		.SYNOPSIS
		Displays the address for the specified Armor account accessible to the current user.

		.DESCRIPTION
		{ required: more detailed description of the function's purpose }

		.NOTES
		Troy Lindsay
		Twitter: @troylindsay42
		GitHub: tlindsay42

		.PARAMETER ApiVersion
		The API version.  The default value is $Global:ArmorSession.ApiVersion.

		.INPUTS
		None
			You cannot pipe objects to Get-ArmorAccount.

		.OUTPUTS
		System.Collections.Hashtable

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
		[ValidateRange( 1, 65535 )]
		[UInt16] $ID = 0,
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
		$return = $null
		$headers = $Global:ArmorSession.Headers.Clone()
		$headers.( $Global:ArmorSession.AccountContextHeader ) = $ID

		Write-Verbose -Message ( 'Gather API Data for {0}.' -f $function )
		$resources = Get-ArmorApiData -Endpoint $function -ApiVersion $ApiVersion

		$uri = New-ArmorApiUriString -Endpoints $resources.Uri -IDs $ID

		If ( $ID -gt 0 )
		{
			Write-Verbose 'Implementing workaround for specific account query bug.'
		}

		$uri = New-ArmorApiUriQueryString -QueryKeys $resources.Query.Keys -Parameters ( Get-Command -Name $function ).Parameters.Values -Uri $uri

		$results = Submit-ArmorApiRequest -Uri $uri -Headers $headers -Method $resources.Method

		$results = Select-ArmorApiResult -Results $results -Filter $resources.Filter

		If ( $results.Count -eq 0 )
		{
			Write-Host -Object 'Armor account not found.'
		}
		Else
		{
			$return = [ArmorAccountAddress] $results
		}

		Return $return
	} # End of Process

	End
	{
		Write-Verbose -Message ( 'Ending {0}.' -f $function )
	} # End of End
} # End of Function
