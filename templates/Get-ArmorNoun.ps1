function Get-ArmorNoun {
    <#
        .SYNOPSIS
        { required: high level overview }

        .DESCRIPTION
        { required: more detailed description of the function's purpose }

        .INPUTS
        { required: .NET Framework object types that can be piped in and a description of the input objects }

        .NOTES
        - Name { optional }
        - Twitter: { optional }
        - GitHub: { optional }

        .EXAMPLE
        { required: show one or more examples using the function }

        .LINK
        https://tlindsay42.github.io/ArmorPowerShell/

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
        [ValidateSet( 'v1.0', 'internal' )]
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

        Write-Verbose -Message "Beginning: '${function}' with ParameterSetName '$( $PSCmdlet.ParameterSetName )' and Parameters: $( $PSBoundParameters | Out-String )"

        # Check to ensure that a session to the Armor session is valid.
        Test-ArmorSession
    }

    process {
        [PSCustomObject[]] $return = $null

        <#
        Retrieve the endpoints, method, body, query, location, filter, and
        expected HTTP response success code for the function.
        #>
        $resources = Get-ArmorApiData -FunctionName $function -ApiVersion $ApiVersion

        # Build the URI
        $uri = New-ArmorApiUri -Endpoints $resources.Endpoints -IDs $ID

        # Get the collection of parameter values
        $parameterValues = ( Get-Command -Name $function ).Parameters.Values

        # Append a filter to the URI
        $keys = ( $resources.Query | Get-Member -MemberType 'NoteProperty' ).Name
        $parameters = ( Get-Command -Name $function ).Parameters.Values
        $uri = New-ArmorApiUriQuery -Keys $keys -Parameters $parameters -Uri $uri

        # Submit the request to the Armor API
        $splat = @{
            'Uri'         = $uri
            'Method'      = $resources.Method
            'SuccessCode' = $resources.SuccessCode
        }
        $results = Submit-ArmorApiRequest @splat

        # Filter the results
        $filters = $resources.Filter |
            Get-Member -MemberType 'NoteProperty'
        $results = Select-ArmorApiResult -Results $results -Filters $filters

        if ( $results.Count -eq 0 ) {
            if ( $PSCmdlet.ParameterSetName -eq 'ID' ) {
                Write-Error -Message "Armor object not found: ID: '${ID}'."
            }
            elseif ( $PSCmdlet.ParameterSetName -eq 'Name' ) {
                Write-Error -Message "Armor object not found: Name: '${Name}'."
            }
        }
        else {
            $return = $results
        }

        # Pass the return value to the pipeline
        $return
    }

    end {
        Write-Verbose -Message "Ending: '${function}'."
    }
}
