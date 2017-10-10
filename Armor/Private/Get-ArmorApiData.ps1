Function Get-ArmorApiData
{
	<#
		.SYNOPSIS
		Helper function that retrieves data for making requests to the Armor API.

		.DESCRIPTION
		This command gets all of the data necessary to construct an API request based on the specified cmdlet name.

		.NOTES
		Written by Troy Lindsay
		Twitter: @troylindsay42
		GitHub: tlindsay42

		.PARAMETER Endpoint
		Specifies the cmdlet name to lookup the API data for.  The default value is 'Example', which provides example
		API data for each of the fields for reference.

		.INPUTS
		System.String
			Get-ArmorApiData accepts the cmdlet endpoint string via the pipeline.

		.OUTPUTS
		System.Collections.Hashtable
			Get-ArmorApiData returns a hashtable with the data necessary to construct an API
			request based on the specified cmdlet name.

		.LINK
		https://github.com/tlindsay42/ArmorPowerShell

		.LINK
		https://docs.armor.com/display/KBSS/Armor+API+Guide

		.LINK
		https://developer.armor.com/

		.EXAMPLE
		Get-ArmorApiData -Endpoint 'Connect-Armor'

		Name                           Value
		----                           -----
		v1.0                           {Query, Result, Filter, Method...}

		Description
		-----------

		This command gets all of the data necessary to construct an API request for the Connect-Armor cmdlet.
	#>

	[CmdletBinding()]
	Param
	(
		[Parameter( Mandatory = $true, Position = 0, ValueFromPipeline = $true )]
		[String] $Endpoint = 'Example'
	)

	Process
	{
		$api = @{
			'Example' = @{
				'v1.0' = @{
					'Description' = 'Details about the API endpoint'
					'URI'         = 'The URI expressed as /api/v#/endpoint'
					'Method'      = 'Method to use against the endpoint'
					'Body'        = 'Parameters to use in the body'
					'Query'       = 'Parameters to use in the URI query'
					'Result'      = 'If the result content is stored in a higher level key, express it here to be unwrapped in the return'
					'Filter'      = 'If the result content needs to be filtered based on key names, express them here'
					'Success'     = 'The expected HTTP status code for a successful call'
				}
			}
			'Connect-Armor' = @{
				'v1.0' = @{
					'Description' = 'Create a new login session'
					'URI'         = '/auth/authorize'
					'Method'      = 'Post'
					'Body'        = @( 'username', 'password' )
					'Query'       = ''
					'Result'      = ''
					'Filter'      = ''
					'Success'     = '200'
				}
			}
		} # End of $api

		Return $api.$Endpoint
	} # End of Process
} # End of Function
