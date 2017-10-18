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
		The Armor API server IP address or FQDN.  The default value is $global:ArmorConnection.Server.

		.PARAMETER Port
		The Armor API server port.  The default value is $global:ArmorConnection.Port.

		.PARAMETER Endpoint
		The endpoint path.

		.PARAMETER ID
		An id value to be planted into the path or optionally at the end of the URI to retrieve a single object.

		.INPUTS
		None
			You cannot pipe objects to New-ArmorApiUriString.

		.OUTPUTS
		System.String

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
		[ValidateNotNullOrEmpty()]
		[String] $Server = $global:ArmorConnection.Server,
		[Parameter( Position = 1 )]
		[ValidateRange( 0, 65535 )]
		[UInt16] $Port = $global:ArmorConnection.Port,
		[Parameter( Position = 2 )]
		[ValidateNotNullorEmpty()]
		[String] $Endpoint = '/',
		[Parameter( Position = 3 )]
		[ValidateNotNullorEmpty()]
		[String] $ID = $null
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

		# If we find {id} in the path, replace it with the $ID value
		If ( $return -match '{id}' -and $ID.Length -gt 0 )
		{
			$return = $return -replace '{id}', $ID
		}
		# If we find {id} in the path, but $ID is not set, throw an error
		ElseIf ( $return -match '{id}' -and $ID.Length -eq 0 )
		{
			Throw 'Missing ID value.'
		}
		# Otherwise, only add the $id value at the end if it exists (for single object retrieval)
		ElseIf ( $ID.Length -gt 0 )
		{
			$return += '/{0}' -f $ID
		}

		Write-Verbose -Message ( 'URI = {0}' -f $return )
			
		Return $return
	} # End of Process

	End
	{
		Write-Verbose -Message ( 'Ending {0}.' -f $function )
	}
} # End of Function
