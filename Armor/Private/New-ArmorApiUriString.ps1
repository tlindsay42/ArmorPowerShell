Function New-ArmorApiUriString
{
	<#
		.SYNOPSIS
		The New-ArmorApiUriString function is used to build a valid URI.

		.DESCRIPTION
		{ required: more detailed description of the function's purpose }

		.NOTES
		Troy Lindsay
		Twitter: @troylindsay42
		GitHub: tlindsay42

		.PARAMETER Server
		The Armor API server IP address or FQDN.  The default value is 'api.armor.com'.

		.PARAMETER Port
		The Armor API server port.  The default value is '443'.

		.PARAMETER Endpoint
		The endpoint path.

		.PARAMETER ID
		An id value to be planted into the path or optionally at the end of the URI to retrieve a single object.

		.INPUTS
		None
			You cannot pipe objects to New-ArmorApiUriString.

		.OUTPUTS
		System.String
			New-ArmorApiUriString returns the formatted URI string to use for the Armor API request.

		.LINK
		https://github.com/tlindsay42/ArmorPowerShell

		.LINK
		https://docs.armor.com/display/KBSS/Armor+API+Guide

		.LINK
		https://developer.armor.com/

		.EXAMPLE
		New-ArmorApiUriString -Server 'api.armor.com' -Port 443 -Endpoint '/auth/authorize'
		This will return 'https://api.armor.com:443/auth/authorize'.
	#>

	[CmdletBinding()]
	Param
	(
		[Parameter( Position = 0 )]
		[ValidateScript( { Test-NetConnection -ComputerName $_ -InformationLevel Quiet } )]
		[String] $Server = 'api.armor.com',
		[Parameter( Position = 1 )]
		[ValidateRange( 0, 65535 )]
		[UInt16] $Port = 443,
		[Parameter( Position = 2 )]
		[ValidateNotNullorEmpty()]
		[String] $Endpoint = '/',
		[Parameter( Position = 3 )]
		[ValidateNotNullorEmpty()]
		[String] $Id = $null
	)

	Begin
	{
		# The Begin section is used to perform one-time loads of data necessary to carry out the function's purpose
		# If a command needs to be run with each iteration or pipeline input, place it in the Process section

		$function = $MyInvocation.MyCommand.Name

		Write-Verbose -Message ( 'Beginning {0}.' -f $function )
	} # End of Begin

	Process
	{
		Write-Verbose -Message 'Build the URI.'

		$return = 'https://{0}:{1}{2}' -f $Server, $Port, $Endpoint

		# If we find {id} in the path, replace it with the $Id value
		If ( $return -match '{id}' -and $Id.Length -gt 0 )
		{
			$return = $return -replace '{id}', $Id
		}
		# If we find {id} in the path, but $Id is not set, throw an error
		ElseIf ( $return -match '{id}' -and $Id.Length -eq 0 )
		{
			Throw 'Missing ID value.'
		}
		# Otherwise, only add the $id value at the end if it exists (for single object retrieval)
		ElseIf ( $Id.Length -gt 0 )
		{
			$return += '/{0}' -f $Id
		}

		Write-Verbose -Message ( 'URI = {0}' -f $return )
			
		Return $return
	} # End of Process

	End
	{
		Write-Verbose -Message ( 'Ending {0}.' -f $function )
	}
} # End of Function
