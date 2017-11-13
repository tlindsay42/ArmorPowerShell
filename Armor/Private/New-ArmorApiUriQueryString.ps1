Function New-ArmorApiUriQueryString
{
	<#
		.SYNOPSIS
		The New-ArmorApiUriQueryString function is used to build a valid URI query string.

		.DESCRIPTION
		{ required: more detailed description of the function's purpose }

		.NOTES
		Troy Lindsay
		Twitter: @troylindsay42
		GitHub: tlindsay42

		.PARAMETER QueryKeys
		All of the query options available to the endpoint.

		.PARAMETER Parameters
		All of the parameter options available within the parent function.

		.PARAMETER Uri
		The endpoint's URI.

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

	Param
	(
		[Parameter( Position = 0 )]
		[String[]] $QueryKeys = @(),
		[Parameter( Position = 1 )]
		[ValidateNotNullOrEmpty()]
		[String[]] $Parameters = @(),
		[Parameter( Position = 2 )]
		[ValidateNotNullOrEmpty()]
		[String] $Uri = ''
	)

	Begin
	{
		$function = $MyInvocation.MyCommand.Name

		Write-Verbose -Message ( 'Beginning {0}.' -f $function )
	} # End of Begin

	Process
	{
		$return = $Uri

		Write-Verbose -Message 'Build the query parameters.'

		$queryString = @()

		# Walk through all of the available query options presented by the endpoint
		# Note: Keys are used to search in case the value changes in the future across different API versions
		ForEach ( $query In $QueryKeys )
		{
			# Walk through all of the parameters defined in the function
			# Both the parameter name and parameter alias are used to match against a query option
			# It is suggested to make the parameter name "human friendly" and set an alias corresponding to the query option name
			ForEach ( $parameter In $Parameters )
			{
				# If the parameter name matches the query option name, build a query string
				If ( $parameter.Name -eq $query )
				{
					If ( $resources.Query[$parameter.Name] -and ( Get-Variable -Name $parameter.Name ).Value )
					{
						$queryString += '{0}={1}' -f $resources.Query[$parameter.Name], ( Get-Variable -Name $parameter.Name ).Value
					}
				}
				# If the parameter alias matches the query option name, build a query string
				ElseIf ( $parameter.Aliases -eq $query )
				{
					If ( $resources.Query[$parameter.Aliases] -and ( Get-Variable -Name $parameter.Name ).Value )
					{
						$queryString += '{0}={1}' -f $resources.Query[$parameter.Aliases], ( Get-Variable -Name $parameter.Name ).Value
					}
				}
			}
		}

		# After all query options are exhausted, build a new URI with all defined query options
		If ( $queryString.Count -gt 0 )
		{
			$return = '?{0}' -f ( $queryString -join '&' )

			Write-Verbose -Message ( 'URI = {0}' -f $return )
		}

		Return $return
	} # End of Process

	End
	{
		Write-Verbose -Message ( 'Ending {0}.' -f $function )
	} # End of End
} # End of Function
