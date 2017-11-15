Function Invoke-ArmorWebRequest
{
	<#
		.SYNOPSIS
		{ required: high level overview }

		.DESCRIPTION
		{ required: more detailed description of the function's purpose }

		.NOTES
		Troy Lindsay
		Twitter: @troylindsay42
		GitHub: @tlindsay42

		.PARAMETER Parameter
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
		[ValidateNotNullorEmpty()]
		[String] $Endpoint = '/',
		[Parameter( Position = 1 )]
		[ValidateNotNull()]
		[Hashtable] $Headers = $Global:ArmorSession.Headers,
		[Parameter( Position = 2 )]
		[ValidateSet( 'Delete', 'Get', 'Patch', 'Post', 'Put' )]
		[String] $Method = '',
		[Parameter( Position = 3 )]
		[String] $Body = '',
		[Parameter( Position = 4 )]
		[ValidateSet( 200 )]
		[UInt16] $SuccessCode = 200,
		[Parameter( Position = 5 )]
		[ValidateNotNullorEmpty()]
		[String] $Description = 'Test Armor API request'
	)

	Begin
	{
		$function = $MyInvocation.MyCommand.Name

		Write-Verbose -Message ( 'Beginning {0}.' -f $function )

		Test-ArmorSession
	} # End of Begin

	Process
	{
		$uri = New-ArmorApiUriString -Endpoints $Endpoint

		$results = Submit-ArmorApiRequest -Uri $uri -Method $Method -Body ( $Body | ConvertTo-Json ) -SuccessCode $SuccessCode -Description $Description

		Return $results
	} # End of Process

	End
	{
		Write-Verbose -Message ( 'Ending {0}.' -f $function )
	} # End of End
} # End of Function
