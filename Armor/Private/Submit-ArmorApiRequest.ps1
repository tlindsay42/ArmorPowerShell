Function Submit-ArmorApiRequest
{
	<#
		.SYNOPSIS
		Helper function used to send data to an endpoint and then format the response for further use.

		.DESCRIPTION
		{ required: more detailed description of the function's purpose }

		.NOTES
		Troy Lindsay
		Twitter: @troylindsay42
		GitHub: tlindsay42

		.PARAMETER URI
		The endpoint's URI.  The default value is null.

		.PARAMETER Headers
		The headers containing authentication details.  The default value is $Global:ArmorSession.Headers.

		.PARAMETER Method
		The action/method to perform on the endpoint.  The default value is null.

		.PARAMETER Body
		Any optional request body data being submitted to the endpoint.  The default value is null.

		.INPUTS
		None
			You cannot pipe objects to Submit-ArmorApiRequest.

		.OUTPUTS
		System.Management.Automation.PSCustomObject[]

		.LINK
		https://github.com/tlindsay42/ArmorPowerShell

		.LINK
		https://docs.armor.com/display/KBSS/Armor+API+Guide

		.LINK
		https://developer.armor.com/

		.EXAMPLE
		{required: show one or more examples using the function}
	#>

	[CmdletBinding( SupportsShouldProcess = $true )]
	Param
	(
		[Parameter( Position = 0 )]
		[ValidateNotNullorEmpty()]
		[String] $Uri = '',
		[Parameter( Position = 1 )]
		[ValidateNotNull()]
		[Hashtable] $Headers = $Global:ArmorSession.Headers,
		[Parameter( Position = 2 )]
		[ValidateSet( 'Delete', 'Get', 'Patch', 'Post', 'Put' )]
		[String] $Method = '',
		[Parameter( Position = 3 )]
		[String] $Body = ''
	)

	Begin
	{
		$function = $MyInvocation.MyCommand.Name

		Write-Verbose -Message ( 'Beginning {0}.' -f $function )
	} # End of Begin

	Process
	{
		$return = $null
		$request = $null

		If ( $PSCmdlet.ShouldProcess( $ID, $resources.Description ) )
		{
			Try
			{
				Write-Verbose -Message 'Submitting the request.'

				If ( $Method -eq 'Get' )
				{
					$getHeaders = $Headers.Clone()
					$getHeaders.Remove( 'Content-Type' )

					$request = Invoke-WebRequest -Uri $Uri -Headers $getHeaders -Method $Method
				}
				Else
				{
					$request = Invoke-WebRequest -Uri $Uri -Headers $Headers -Method $Method -Body $Body
				}

				If ( $request.StatusCode -eq $resources.SuccessCode )
				{
					If ( $request.Content.Length -gt 2MB )
					{
						# Because some calls require more than the default payload limit of 2MB, ConvertFrom-JsonXL dynamically adjusts the payload limit
						Write-Verbose -Message 'Converting JSON payload more than 2MB.'

						$return = $request.Content |
							ConvertFrom-JsonXL
					}
					Else
					{
						Write-Verbose -Message 'Converting JSON payload less than or equal to 2MB.'

						$return = $request.Content |
							ConvertFrom-Json
					}
				}
				Else
				{
					Throw $request.StatusDescription
				}
			}
			Catch
			{
				$warningMessage = 'The endpoint supplied to the Armor API is invalid. Likely this is due to an incompatible version of the API or references pointing to a non-existent endpoint. The URI passed was: {0}' -f $Uri

				Switch -Wildcard ( $_ )
				{
					'Route not defined.'
					{
						Write-Warning -Message $warningMessage -Verbose

						Throw $_.Exception
					}
					
					'Invalid ManagedId*'
					{
						Write-Warning -Message $warningMessage -Verbose

						Throw $_.Exception 
					}

					Default { Throw $_ }
				}
			}
		}

		Return $return
	} # End of Process

	End
	{
		Write-Verbose -Message ( 'Ending {0}.' -f $function )
	} # End of End
} # End of Function
