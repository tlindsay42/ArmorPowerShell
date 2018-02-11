function Get-ArmorNoun {
    <#
        .SYNOPSIS
        { required: high level overview }

        .DESCRIPTION
        { required: more detailed description of the function's purpose }

        .INPUTS
        { required: .NET Framework object types that can be piped in and a description of the input objects }

        .NOTES
        Name { optional }
        Twitter: { optional }
        GitHub: { optional }
        Any other links you'd like here

        .EXAMPLE
        {required: show one or more examples using the function}

        .LINK
        https://github.com/tlindsay42/ArmorPowerShell

        .LINK
        https://docs.armor.com/display/KBSS/Armor+API+Guide

        .LINK
        https://developer.armor.com/
    #>

    [CmdletBinding( DefaultParameterSetName = 'ID' )]
    [OutputType( [PSCustomObject[]] )]
    param (
        <#
        { required: description of the specified input parameter's purpose }
        #>
        [Parameter(
            ParameterSetName = 'ID',
            Position = 0,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true
        )]
        [ValidateRange( 1, 65535 )]
        [UInt16]
        $ID = 0,

        <#
        { required: description of the specified input parameter's purpose }
        #>
        [Parameter(
            ParameterSetName = 'Name',
            Position = 0,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true
        )]
        [ValidateRange( 1, 65535 )]
        [String]
        $Name = '',

        <#
        { required: description of the specified input parameter's purpose }
        #>
        [Parameter( Position = 1 )]
        [ValidateSet( 'v1.0' )]
        [String]
        $ApiVersion = $Global:ArmorSession.ApiVersion
    )

    begin {
            <#
            The begin section is used to perform one-time loads of data
            necessary to carry out the cmdlet's purpose.  If a command needs to
            be run with each iteration or pipeline input, place it in the
            process section.
            #>

            # The name of the cmdlet
            $function = $MyInvocation.MyCommand.Name

            Write-Verbose -Message ( 'Beginning {0}.' -f $function )

            # Check to ensure that a session to the Armor session is valid.
            Test-ArmorSession
        } # End of begin

        process {
            [PSCustomObject[]] $return = $null

            <#
            Retrieve all of the URI, method, body, query, location, filter, and
            expected HTTP response success code for the API endpoint.
            #>
            $resources = Get-ArmorApiData -Endpoint $function -ApiVersion $ApiVersion

            # Build the URI
            $uri = New-ArmorApiUriString -Endpoints $resources.Uri -IDs $ID

            # Get the collection of parameter values
            $parameterValues = ( Get-Command -Name $function ).Parameters.Values

            # Append a filter to the URI
            $uri = New-ArmorApiUriQueryString -QueryKeys $resources.Query.Keys -Parameters $parameterValues -Uri $uri

            # Submit the request to the Armor API
            $results = Submit-ArmorApiRequest -Uri $uri -Method $resources.Method -Body $body -Description $resources.Description

            # Expand the data in one of the response body values
            $results = Expand-ArmorApiResult -Results $results -Location $resources.Location

            # Filter the results
            $results = Select-ArmorApiResult -Results $results -Filter $resources.Filter

            if ( $results.Count -eq 0 ) {
                Write-Host -Object 'Armor item not found.'
            }
            else {
                $return = $results
            }

            # Pass the return value to the pipeline
            $return
        } # End of process

        end {
            Write-Verbose -Message ( 'Ending {0}.' -f $function )
        } # End of end
    } # End of function
