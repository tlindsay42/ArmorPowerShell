Function Connect-Armor
{
	<#
		.SYNOPSIS
		Connects to Armor and retrieves an authentication token.

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

		.PARAMETER AccountID
		The Armor account ID to use for all subsequent requests.

		.PARAMETER Server
		The Armor API server IP address or FQDN.  The default value is 'api.armor.com'.

		.PARAMETER Port
		The Armor API server port.  The default value is '443'.

		.PARAMETER ApiVersion
		The API version.  The default value is 'v1.0'.

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
		[ValidateRange( 0, 65535 )]
		[UInt16] $AccountID = $null,
		[Parameter( Position = 2 )]
		[ValidateNotNullorEmpty()]
		[String] $Server = 'api.armor.com',
		[Parameter( Position = 3 )]
		[ValidateRange( 0, 65535 )]
		[UInt16] $Port = 443,
		[Parameter( Position = 4 )]
		[ValidateSet( 'v1.0' )]
		[String] $ApiVersion = 'v1.0'
	)

	Begin
	{
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

		If ( $Credential -eq $null )
		{
			Try { $Credential = Get-Credential }
			Catch { Throw 'Failed to set credentials.' }
		}

		$Global:ArmorConnection = @{
			'ID' = $null
			'UserName' = $Credential.UserName
			'AccountContextID' = $null
			'Accounts' = @()
			'Token' = $null
			'Server' = $Server
			'Port' = $Port
			'Headers' = @{ 
				'Content-Type' = 'application/json'
				'Accept' = 'application/json'
			}
			'SessionStartTime' = $null
			'SessionExpirationTime' = $null
			'ApiVersion' = $ApiVersion
		}

		Write-Verbose -Message ( 'Connecting to {0}.' -f $resources.Uri )

		# Create the URI
		$uri = New-ArmorApiUriString -Server $Global:ArmorConnection.Server -Port $Global:ArmorConnection.Port -Endpoints $resources.Uri

		# Set the Method
		$method = $resources.Method

		# For API version v1.0, create a body with the credentials
		Switch ( $Global:ArmorConnection.ApiVersion )
		{
			'v1.0'
			{
				$body = @{
					$resources.Body.UserName = $Global:ArmorConnection.UserName
					$resources.Body.Password = $Credential.GetNetworkCredential().Password
				} |
					ConvertTo-Json
			}

			Default
			{
				Throw ( 'Unknown API version number: {0}.' -f $Global:ArmorConnection.ApiVersion )
			}
		}

		Try
		{
			$content = Submit-ArmorApiRequest -Uri $uri -Headers $Global:ArmorConnection.Headers -Method $method -Body $body

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

		Write-Verbose -Message 'Storing all connection details in $Global:ArmorConnection.'

		$now = Get-Date

		$Global:ArmorConnection.ID = $token.Id_Token
		$Global:ArmorConnection.Token = $token.Access_Token
		$Global:ArmorConnection.SessionStartTime = $now
		$Global:ArmorConnection.SessionExpirationTime = $now.AddSeconds( $token.Expires_In )
		$Global:ArmorConnection.Headers.Authorization = 'FH-AUTH {0}' -f $token.Access_Token
		
		If ( $AccountID -eq 0 )
		{
			Try
			{
				$AccountID = ( Get-ArmorAccount ).ID |
					Select-Object -First 1 
   		}
			Catch { Throw 'Failed to get the default Armor account ID.' }
		}

		Write-Verbose -Message ( 'Setting the Armor account context to ID {0}.' -f $AccountID )
		Set-ArmorAccountContext -ID $AccountID

		Return $Global:ArmorConnection.GetEnumerator().Where( { $_.Name -ne 'Token' } )
	} # End of Process

	End
	{
		Write-Verbose -Message ( 'Ending {0}.' -f $function )
	}
} # End of Function
