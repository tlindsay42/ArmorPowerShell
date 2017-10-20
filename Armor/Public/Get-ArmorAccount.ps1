Function Get-ArmorAccount
{
	<#
		.SYNOPSIS
		Retrieves a list of Armor account memberships for the currently authenticated user.

		.DESCRIPTION
		{ required: more detailed description of the function's purpose }

		.NOTES
		Troy Lindsay
		Twitter: @troylindsay42
		GitHub: tlindsay42

		.PARAMETER ApiVersion
		The API version.  The default value is $global:ArmorConnection.ApiVersion.

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
		[ValidateScript( { $_ -match '^v\d+\.\d$' } )]
		[String] $ApiVersion = $global:ArmorConnection.ApiVersion
	)

	Begin
	{
		# The Begin section is used to perform one-time loads of data necessary to carry out the function's purpose
		# If a command needs to be run with each iteration or pipeline input, place it in the Process section

		# Check to ensure that a session to the Armor cluster exists and load the needed header data for authentication
		Test-ArmorConnection

		# API data references the name of the function
		# For convenience, that name is saved here to $function
		$function = $MyInvocation.MyCommand.Name

		Write-Verbose  -Message ( 'Beginning {0}.' -f $function )
	} # End of Begin

	Process
	{
		# Retrieve all of the URI, method, body, query, location, filter, and success details for the API endpoint
		Write-Verbose -Message ( 'Gather API Data for {0}.' -f $function )

		$resources = Get-ArmorApiData -Endpoint $function -ApiVersion $ApiVersion

		$uri = New-ArmorApiUriString -Server $global:ArmorConnection.Server -Port $global:ArmorConnection.Port -Endpoints $resources.Uri

		$result = Submit-ArmorApiRequest -Uri $uri -Headers $global:ArmorConnection.Headers -Method $resources.Method

		$result = Format-ArmorApiResult -Result $result -Location $resources.Location

		$result = Select-ArmorApiResult -Result $result -Filter $resources.Filter

		$global:ArmorConnection.Accounts = @()
		
		ForEach ( $account In $result.Accounts )
		{
			$temp = New-Object -TypeName PSCustomObject |
				Select-Object -Property 'Name', 'ID', 'Status', 'Parent', 'Currency', 'Products'

			$temp.Name = $account.Name.Trim()
			$temp.ID = $account.Id
			$temp.Status = $account.Status.Trim()
			$temp.Parent = $account.Parent
			$temp.Currency = $account.Currency.Trim()
			$temp.Products = $account.Products

			$global:ArmorConnection.Accounts += $temp
		}

		Return $global:ArmorConnection.Accounts
	} # End of Process

	End
	{
		Write-Verbose -Message ( 'Ending {0}.' -f $function )
	} # End of End
} # End of Function
