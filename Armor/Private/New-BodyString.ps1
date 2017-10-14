Function New-BodyString
{
	<#
		.SYNOPSIS
		Helper function used to create a valid body payload.

		.DESCRIPTION
		{ required: more detailed description of the function's purpose }

		.NOTES
		Written by Troy Lindsay
		Twitter: @troylindsay42
		GitHub: tlindsay42

		.PARAMETER BodyKeys
		All of the body options available to the endpoint.

		.PARAMETER Parameters
		All of the parameter options available within the parent function.

		.INPUTS
		None
			You cannot pipe objects to New-BodyString.

		.OUTPUTS
		System.String

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
		[String[]] $BodyKeys,
		[String[]] $Parameters
	)

	If ( $resources.Method -eq 'Get' ) { Return $null }

	# Inventory all invoked parameters
	$setParameters = $PSCmdlet.MyInvocation.BoundParameters

	Write-Verbose -Message ( 'List of set parameters: {0}.' -f $setParameters.GetEnumerator() )

	Write-Verbose -Message 'Build the body parameters.'

	$bodyString = @{}

	# Walk through all of the available body options presented by the endpoint
	# Note: Keys are used to search in case the value changes in the future across different API versions
	ForEach ( $body in $BodyKeys )
	{
		Write-Verbose -Message ( 'Adding {0}...' -f $body )

		# Array Object
		If ( $resources.Body.$body.GetType().BaseType.Name -eq 'Array' )
		{
			$arraystring = @{}

			ForEach ( $arrayItem In $resources.Body.$body.Keys )
			{
				# Walk through all of the parameters defined in the function
				# Both the parameter name and parameter alias are used to match against a body option
				# It is suggested to make the parameter name "human friendly" and set an alias corresponding to the body option name
				ForEach ( $parameter In $Parameters )
				{
					# If the parameter name or alias matches the body option name, build a body string
					If ( $parameter.Name -eq $arrayItem -or $parameter.Aliases -eq $arrayItem)
					{
						# Switch variable types
						If ( ( Get-Variable -Name $parameter.Name ).Value.GetType().Name -eq 'SwitchParameter' )
						{
							$arraystring.Add( $arrayItem, ( Get-Variable -Name $parameter.Name ).Value.IsPresent )
						}
						# All other variable types
						ElseIf ( ( Get-Variable -Name $parameter.Name ).Value -ne $null )
						{
							$arraystring.Add( $arrayItem, ( Get-Variable -Name $parameter.Name ).Value )
						}
					}
				}
			}

			$bodyString.Add( $body, @( $arraystring ) )
		}
		# Non-Array Object
		Else
		{
			# Walk through all of the parameters defined in the function
			# Both the parameter name and parameter alias are used to match against a body option
			# It is suggested to make the parameter name "human friendly" and set an alias corresponding to the body option name
			ForEach ( $parameter In $parameters )
			{
				# If the parameter name or alias matches the body option name, build a body string
				If ( ( $parameter.Name -eq $body -or $parameter.Aliases -eq $body ) -and $setParameters.ContainsKey( $parameter.Name ) )
				{
					# Switch variable types
					If ( ( Get-Variable -Name $parameter.Name ).Value.GetType().Name -eq 'SwitchParameter' )
					{
						$bodyString.Add( $body, ( Get-Variable -Name $parameter.Name ).Value.IsPresent )
					}
					# All other variable types
					ElseIf ( ( Get-Variable -Name $parameter.Name ).Value -ne $null -and ( Get-Variable -Name $parameter.Name ).Value.Length -gt 0 )
					{
						$bodyString.Add( $body, ( Get-Variable -Name $parameter.Name ).Value )
					}
				}
			}
		}
	}

	# Store the results into a JSON string
	$bodyString = ConvertTo-Json -InputObject $bodyString

	Write-Verbose -Message ( 'Body = {0}' -f $bodyString )

	Return $bodyString
}
