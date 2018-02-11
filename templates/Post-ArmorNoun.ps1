function Post-ArmorNoun {
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

    [CmdletBinding( SupportsShouldProcess = $true, ConfirmImpact = 'High' )]
    [OutputType( [PSCustomObject[]] )]
    param (
        <#
        { required: description of the specified input parameter's purpose }
        #>
        [Parameter(
            Mandatory = $true,
            HelpMessage = 'Please enter the Name of the Armor item that you want to update',
            ParameterSetName = 'Name',
            Position = 0,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true
        )]
        [ValidateRange( 1, 65535 )]
        [String]
        $Name,

        <#
        { required: description of the specified input parameter's purpose }
        #>
        [String] $Param2,
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

        # Check to ensure that a session to the Armor cluster exists and load the needed header data for authentication
        Test-ArmorSession
    } # End of begin

    process {
        [PSCustomObject[]] $return = $null

        # Retrieve all of the URI, method, body, query, location, filter, and success details for the API endpoint
        $resources = Get-ArmorApiData -Endpoint $function -ApiVersion $ApiVersion

        # Prompt the user before proceeding
        if ( $PSCmdlet.ShouldProcess( $ID, $resources.Description ) ) {
            # Build the URI
            $uri = New-ArmorApiUriString -Endpoints $resources.Uri -IDs $IDs

            # Get the collection of parameter values
            $parameterValues = ( Get-Command -Name $function ).Parameters.Values

            # Build the request body
            $body = Format-ArmorApiJsonRequestBody -BodyKeys $resources.Body.Keys -Parameters $parameterValues

            # Submit the request to the Armor API
            $results = Submit-ArmorApiRequest -Uri $uri -Method $resources.Method -Body $body -Description $resources.Description
        }

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
