Function Expand-JsonItem
{
	<#
		.SYNOPSIS
		{ required: high level overview }

		.DESCRIPTION
		{ required: more detailed description of the function's purpose }

		.NOTES
		Troy Lindsay
		Twitter: @troylindsay42
		GitHub: tlindsay42

		.PARAMETER InputObject
		{ required: description of the specified input parameter's purpose }

		.INPUTS
		System.Management.Automation.PSObject

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

	[CmdletBinding()]
	Param
	(
		[Parameter( Position = 0, ValueFromPipeline = $true )]
		$InputObject = $null
	)

	Begin
	{
		#$function = $MyInvocation.MyCommand.Name

		#Write-Verbose -Message ( 'Beginning {0}.' -f $function )
	} # End of Begin

	Process
	{
		$return = $null

		Switch -Regex ( $InputObject.PSObject.TypeNames )
		{
			'Array'
			{
				$return = @()

				$InputObject.ForEach( 
					{
						# Recurse
						$return += $_ |
							Expand-JsonItem
					}
				)

				Break
			}

			'Dictionary'
			{
				$return = New-Object -TypeName PSCustomObject

				ForEach ( $jsonItemKey In ( [HashTable]$InputObject ).Keys )
				{
					If ( $InputObject[$jsonItemKey] )
					{
						# Recurse
						$parsedItem = $InputObject.$jsonItemKey |
							Expand-JsonItem
					}
					Else
					{
						$parsedItem = $null
					}

					$return |
						Add-Member -MemberType NoteProperty -Name $jsonItemKey -Value $parsedItem
				}

				Break
			}

			Default
			{
				$return = $InputObject
			}
		}

		Return $return
	} # End of Process

	End
	{
		#Write-Verbose -Message ( 'Ending {0}.' -f $function )
	} # End of End
} # End of Function
