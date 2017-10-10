#Requires -Version 4
#Requires -Module NetTCPIP

Function Connect-Armor
{
	<#
		.SYNOPSIS
		Connects to Armor and retrieves a token value for authentication

		.DESCRIPTION
		The Connect-Armor function is used to connect to the Armor RESTful API and supply credentials to the /login method.
		Armor then returns a unique token to represent the user's credentials for subsequent calls.
		Acquire a token before running other Armor cmdlets.
		Note that you can pass a username and password or an entire set of credentials.

		.NOTES
		Written by Troy Lindsay
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
			Get-ArmorApiData returns a hashtable with the data necessary to construct an API request based on the
			specified cmdlet name.

		.LINK
		https://github.com/tlindsay42/ArmorPowerShell

		.LINK
		https://docs.armor.com/display/KBSS/Armor+API+Guide

		.LINK
		https://developer.armor.com/

		.EXAMPLE
		Connect-Armor -Credential ( Get-Credential )
		You can submit an entire set of credentials using the -Credentials parameter.
	#>

	[CmdletBinding()]
	Param
	(
		[Parameter( Position = 0 )]
		[ValidateNotNullorEmpty()]
		[PSCredential] $Credential = $null,
		[Parameter( Position = 1 )]
		[ValidateScript( { Test-NetConnection -ComputerName $_ -InformationLevel Quiet } )]
		[String] $Server = 'api.armor.com',
		[Parameter( Position = 2 )]
		[ValidateRange( 0, 65535 )]
		[UInt16] $Port = 443
	)

	Begin
	{
		# API data references the name of the function
		# For convenience, that name is saved here to $function
		$function = $MyInvocation.MyCommand.Name

		# Retrieve all of the URI, method, body, query, result, filter, and success details for the API endpoint
		Write-Verbose -Message ( "Gather API Data for {0}." -f $function )
		$resources = Get-ArmorApiData -Endpoint $function
	}

	Process
	{
		If ( Test-NetConnection -ComputerName $Server -Port $Port -InformationLevel Quiet )
		{
			Write-Verbose -Message ( 'Verified TCP connection to {0}:{1}.' -f $Server, $Port )
		}
		Else
		{
			Throw ( 'Failed to establish a TCP connection to {0}:{1}.' -f $Server, $Port )
		}

		$Credential = Test-ArmorCredential -Credential $Credential

		ForEach ( $versionNumber In $resources.Keys | Sort-Object -Descending )
		{
			# Load the version specific data from the resources array
			$version = $resources[$versionNumber]

			Write-Verbose -Message ( "Connecting to {0}." -f $version.Uri )

			# Create the URI
			$uri = 'https://{0}{1}' -f $Server, $version.Uri

			# Set the Method
			$method = $version.Method

			# For API version v1.0, create a body with the credentials
			If ( $versionNumber -eq 'v1.0' )
			{
				$body = @{
					$version.Body[0] = $Credential.UserName
					$version.Body[1] = $Credential.GetNetworkCredential().Password
				} |
					ConvertTo-Json
			}
			# For API version v1.1 or greater, use a standard Basic Auth Base64 encoded header with username:password
			Else
			{
				$headers = @{
					'Authorization' = 'Basic {0}' -f
						[System.Convert]::ToBase64String(
							[System.Text.Encoding]::UTF8.GetBytes( '{0}:{1}' -f $Credential.UserName, $Credential.GetNetworkCredential().Password )
						)
				}
			}

			Write-Verbose -Message 'Submitting the request'
			Try
			{
				$request = Invoke-WebRequest -Uri $uri -Method $method -Body $body -Headers $headers
				$content = $request.Content |
					ConvertFrom-Json

				# If we find a successful call code and also an OAuth code, we know the request was successful
				# Anything else will trigger a Throw, which will cause the Catch to break the current loop and try another version
				If ( $request.StatusCode -eq $version.Success -and $content.Code -ne $null )
				{
					Write-Verbose -Message ( 'Successfully acquired code: {0}' -f $content.Code )
					Break
				}
				Else
				{
					Throw 'Unable to connect to the Armor API.'
				}
			}
			Catch
			{
				Write-Verbose -Message $_
				Write-Verbose -Message $_.Exception.InnerException.Message
			}
		}

		# Final throw for when all versions of the API have failed
		If ( $content.token -eq $null )
		{
			throw 'Unable to connect with any available API version. Check $Error for details or use the -Verbose parameter.'
		}

		# For API version v1.0, use a standard Basic Auth Base64 encoded header with token:$null
		if ($versionNumber -eq 'v1.0')
		{
			Write-Verbose -Message 'Validate token and build Base64 Auth string'
			$auth = [System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($($content.token)+':'))
			$headers = @{
			'Authorization' = "Basic $auth"
			}
		}
		# For API version v1.1 or greater, use Bearer and token
		else
		{
			$headers = @{
			'Authorization' = "Bearer $($content.token)"
			}
		}

		# v1.0 uses a different auth method compared to v1.1
		# If we find v1.1 is in use, reset the version number to 'v1' to match the remainder of v1 calls
		if ($versionNumber -match 'v1')
		{
			$versionNumber = 'v1'
		}

		Write-Verbose -Message 'Storing all connection details into $global:ArmorConnection'
		$global:ArmorConnection = @{
			id      = $content.id
			userId  = $content.userId
			token   = $content.token
			server  = $Server
			header  = $headers
			time    = (Get-Date)
			api     = $versionNumber
			version = Get-ArmorSoftwareVersion -Server $Server
		}

		Write-Verbose -Message 'Adding connection details into the $global:ArmorConnections array'
		[array]$global:ArmorConnections += $ArmorConnection

		$global:ArmorConnection.GetEnumerator() | Where-Object -FilterScript {
			$_.name -notmatch 'token'
		}
	} # End of Process
} # End of Function