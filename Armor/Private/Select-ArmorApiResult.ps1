Function Select-ArmorApiResult
{
	<#
		.SYNOPSIS
		The Select-ArmorApiResult function is used to filter data that has been returned from an endpoint for specific objects important to the user.

		.DESCRIPTION
		{ required: more detailed description of the function's purpose }

		.NOTES
		Troy Lindsay
		Twitter: @troylindsay42
		GitHub: tlindsay42

		.PARAMETER Result
		The formatted API response content.

		.PARAMETER Filter
		The list of parameters that the user can use to filter response data. 
		Each key is the parameter name without the "$" and each value corresponds to the response data's key.

		.INPUTS
		System.Management.Automation.PSCustomObject

		.OUTPUTS
		System.Management.Automation.PSCustomObject

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
		[Parameter( Position = 0, ValueFromPipeline = $true )]
		[PSCustomObject] $Result = $null,
		[Parameter( Position = 1 )]
		[ValidateNotNull()]
		[Hashtable] $Filter = $null
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
		If ( $Result -eq $null ) { Return }

		$return = @()

		Write-Verbose -Message 'Filter the results.'

		ForEach ( $filterKey In $Filter.Keys )
		{
			If ( ( Get-Variable -Name $filterKey -ErrorAction SilentlyContinue ).Value -ne $null )
			{
				Write-Verbose -Message ( 'Filter match = {0}' -f $filterKey )

				$filterKeyValue = ( Get-Variable -Name $filterKey ).Value
				
				# For when a location is one layer deep
				If ( $filterKeyValue -and $Filter[$filterKey].Split( '.' ).Count -eq 1 )
				{
					# The $filterKeyValue check assumes that not all filters will be used in each call
					# If it does exist, the results are filtered using the $filterKeyValue's value against the $Filter[$filterKey]'s key name
					$return = $Result.Where( { $_.$Filter[$filterKey] -eq $filterKeyValue } )
				}
				# For when a location is two layers deep
				ElseIf ( $filterKeyValue -and $Filter[$filterKey].Split( '.' ).Count -eq 2 )
				{
					# The $filterKeyValue check assumes that not all filters will be used in each call
					# If it does exist, the results are filtered using the $filterKeyValue's value against the $Filter[$filterKey]'s key name
					$return = $Result.Where( { $_.( $Filter[$filterKey].Split( '.' )[0] ).( $Filter[$filterKey].Split( '.' )[-1]) -eq $filterKeyValue } )
				}
				Else
				{
					# When no filter is found, return the original $result
					$return = $Result
				}

				Break
			}
		}
    
		Return $return
	} # End of Process

	End
	{
		Write-Verbose -Message ( 'Ending {0}.' -f $function )
	} # End of End
} # End of Function
