Function Connect-Armor
{
	<#
		.SYNOPSIS
		Connects to Armor and retrieves a token value for authentication

		.DESCRIPTION
		The Connect-Armor function is used to connect to the Armor RESTful API and supply credentials to the method.
		Armor then returns a unique, temporary authorization code, which must then be converted into a token to 
		represent the user's credentials for subsequent calls.

		.NOTES
		Troy Lindsay
		Twitter: @troylindsay42
		GitHub: tlindsay42

		.PARAMETER Credential
		Your username and password stored in a PSCredential object for authenticating to the Armor API.

		.PARAMETER Server
		The Armor API server IP address or FQDN.  The default value is 'api.armor.com'.

		.PARAMETER Port
		The Armor API server port.  The default value is '443'.

		.INPUTS
		None
			You cannot pipe objects to Connect-Armor.

		.OUTPUTS
		System.Collections.Hashtable

		.LINK
		https://github.com/tlindsay42/ArmorPowerShell

		.LINK
		https://docs.armor.com/display/KBSS/Armor+API+Guide

		.LINK
		https://developer.armor.com/

		.EXAMPLE
		Connect-Armor -Credential ( Get-Credential )
	#>

	[CmdletBinding()]
	Param
	(
		[Parameter( Position = 0 )]
		[ValidateNotNullorEmpty()]
		[PSCredential] $Credential = $null,
		[Parameter( Position = 1 )]
		[ValidateNotNullorEmpty()]
		[String] $Server = 'api.armor.com',
		[Parameter( Position = 2 )]
		[ValidateRange( 0, 65535 )]
		[UInt16] $Port = 443,
		[Parameter( Position = 3 )]
		[ValidateSet( 'v1.0' )]
		[String] $ApiVersion = 'v1.0'
	)

	Begin
	{
		# The Begin section is used to perform one-time loads of data necessary to carry out the function's purpose
		# If a command needs to be run with each iteration or pipeline input, place it in the Process section

		# API data references the name of the function
		# For convenience, that name is saved here to $function
		$function = $MyInvocation.MyCommand.Name

		Write-Verbose -Message ( 'Beginning {0}.' -f $function )
	}

	Process
	{
		# Retrieve all of the URI, method, body, query, location, filter, and success details for the API endpoint
		Write-Verbose -Message ( 'Gather API Data for {0}.' -f $function )

		$resources = Get-ArmorApiData -Endpoint $function -ApiVersion $ApiVersion

		If ( Test-NetConnection -ComputerName $Server -Port $Port -InformationLevel Quiet )
		{
			Write-Verbose -Message ( 'Verified TCP connection to {0}:{1}.' -f $Server, $Port )
		}
		Else
		{
			Throw ( 'Failed to establish a TCP connection to {0}:{1}.' -f $Server, $Port )
		}

		While ( $Credential -eq $null )
		{
			$Credential = Get-Credential
		}

		Write-Verbose -Message ( 'Connecting to {0}.' -f $resources.Uri )

		# Create the URI
		$uri = New-ArmorApiUriString -Server $Server -Port $Port -Endpoint $resources.Uri

		# Set the Method
		$method = $resources.Method

		$headers = @{ 
			'Content-Type' = 'application/json'
			'Accept' = 'application/json'
		}

		# For API version v1.0, create a body with the credentials
		Switch ( $ApiVersion )
		{
			'v1.0'
			{
				$body = @{
					$resources.Body.UserName = $Credential.UserName
					$resources.Body.Password = $Credential.GetNetworkCredential().Password
				} |
					ConvertTo-Json
			}

			Default
			{
				Throw ( 'Unknown API version number: {0}.' -f $ApiVersion )
			}
		}

		Try
		{
			$content = Submit-ArmorApiRequest -Uri $uri -Headers $headers -Method $method -Body $body

			# If we find a temporary authorization code and a success message, we know the request was successful
			# Anything else will trigger a Throw, which will cause the Catch to break the current loop
			If ( $content.Code.Length -gt 0 -and $content.Success -eq 'true' )
			{
				Write-Verbose -Message ( 'Successfully acquired temporary authorization code: {0}' -f $content.Code )

				$token = New-ArmorApiToken -Code $content.Code -GrantType 'authorization_code'
			}
			Else
			{
				Throw 'Failed to obtain temporary authorization code.'
			}
		}
		Catch
		{
			Write-Verbose -Message $_
			Write-Verbose -Message $_.Exception.InnerException.Message
		}

		# Final throw for when all versions of the API have failed
		If ( $token -eq $null )
		{
			Throw 'Unable to acquire authorization token. Check $Error for details or use the -Verbose parameter.'
		}

		Write-Verbose -Message 'Storing all connection details in $global:ArmorConnection.'

		$now = Get-Date

		$global:ArmorConnection = @{
			'Id' = $token.Id_Token
			'UserName' = $Credential.UserName
			'Token' = $token.Access_Token
			'Server' = $Server
			'Port' = $Port
			'Headers' = $headers
			'SessionStartTime' = $now
			'SessionExpirationTime' = $now.AddSeconds( $token.Expires_In )
			'ApiVersion' = $ApiVersion
		}

		Return $global:ArmorConnection.GetEnumerator().Where( { $_.Name -ne 'Token' } )
	} # End of Process

	End
	{
		Write-Verbose -Message ( 'Ending {0}.' -f $function )
	}
} # End of Function
