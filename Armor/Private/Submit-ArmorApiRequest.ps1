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
		The endpoint's URI.

		.PARAMETER Headers
		The headers containing authentication details.

		.PARAMETER Method
		The action (method) to perform on the endpoint.

		.PARAMETER Body
		Any optional request body data being submitted to the endpoint.

		.INPUTS
		None
			You cannot pipe objects to Submit-ArmorApiRequest.

		.OUTPUTS
		Microsoft.PowerShell.Commands.HtmlWebResponseObject

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
		[String] $Uri = $null,
		[Parameter( Position = 1 )]
		[ValidateNotNull()]
		[Hashtable] $Headers = $Global:ArmorConnection.Headers,
		[Parameter( Position = 2 )]
		[ValidateSet( 'Delete', 'Get', 'Patch', 'Post', 'Put' )]
		[String] $Method = $null,
		[Parameter( Position = 3 )]
		[String] $Body = $null
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
		$return = $null
		$request = $null

		If ( $PSCmdlet.ShouldProcess( $id, $resources.Description ) )
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
