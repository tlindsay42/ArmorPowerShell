<#
    Helper JSON functions to resolve the ConvertFrom-JSON maxJsonLength limitation, which defaults to 2 MB
    http://stackoverflow.com/questions/16854057/convertfrom-json-max-length/27125027
#>

Function ConvertFrom-JsonXL
{
	Param
	(
		[Parameter( Position = 0, ValueFromPipeline = $true )]
		[String] $InputObject = $null
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
		[void][System.Reflection.Assembly]::LoadWithPartialName( 'System.Web.Extensions' )
		
		$javaScriptSerializer = New-Object -TypeName System.Web.Script.Serialization.JavaScriptSerializer -Property @{ 'MaxJsonLength' = 64MB }

		$return = $javaScriptSerializer.DeserializeObject( $InputObject ) |
			Convert-JsonItem

		Return $return
	} # End of Process

	End
	{
		Write-Verbose -Message ( 'Ending {0}.' -f $function )
	} # End of End
} # End of Function

Function Convert-JsonItem
{
	Param
	(
		[Parameter( Position = 0, ValueFromPipeline = $true )]
		$InputObject = $null
	)

	Begin
	{
		# The Begin section is used to perform one-time loads of data necessary to carry out the function's purpose
		# If a command needs to be run with each iteration or pipeline input, place it in the Process section

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

				$InputObject.ForEach( { <# Recurse #> $return += , ( Convert-JsonItem -InputObject $_ ) } )

				Break
			}

			'Dictionary'
			{
				$return = New-Object -TypeName PSCustomObject

				ForEach ( $jsonItemKey In ( [HashTable]$InputObject ).Keys )
				{
					If ( $InputObject[$jsonItemKey] ) { <# Recurse #> $parsedItem = Convert-JsonItem -InputObject $InputObject[$jsonItemKey] }
					Else { $parsedItem = $null }

					$return |
						Add-Member -MemberType NoteProperty -Name $jsonItemKey -Value $parsedItem
				}

				Break
			}

			Default { $return = $InputObject }
		}

		Return $return
	} # End of Process

	End
	{
		#Write-Verbose -Message ( 'Ending {0}.' -f $function )
	} # End of End
} # End of Function
