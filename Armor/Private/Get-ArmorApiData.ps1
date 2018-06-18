function Get-ArmorApiData {
    <#
        .SYNOPSIS
        Retrieves data for making requests to the Armor API.

        .DESCRIPTION
        Retrieves the data necessary to construct an API request based on the specified
        cmdlet name.

        .INPUTS
        String

        PSCustomObject

        .NOTES
        - Troy Lindsay
        - Twitter: @troylindsay42
        - GitHub: tlindsay42

        .EXAMPLE
        Get-ArmorApiData -FunctionName 'Connect-Armor' -ApiVersion 'v1.0'
        Retrieves the data necessary to construct a request for `Connect-Armor` for
        Armor API version 1.0.

        .EXAMPLE
        Get-ArmorApiData -FunctionName 'Get-ArmorVM' -ApiVersions
        Retrieves the Armor API versions available for `Get-ArmorVM`.

        .EXAMPLE
        'Get-ArmorCompleteWorkload', 'Get-ArmorCompleteWorkloadTier' | Get-ArmorApiData -ApiVersion 'v1.0'
        Retrieves the data necessary to construct a request for
        `Get-ArmorCompleteWorkload` and `Get-ArmorCompleteWorkloadTier` for Armor API
        version 1.0.

        .EXAMPLE
        'Rename-ArmorCompleteVM', 'Rename-ArmorCompleteWorkload' | Get-ArmorApiData -ApiVersions
        Retrieves the Armor API versions available for `Rename-ArmorCompleteVM` and
        `Rename-ArmorCompleteWorkload`.

        .LINK
        https://tlindsay42.github.io/ArmorPowerShell/private/Get-ArmorApiData/

        .LINK
        https://github.com/tlindsay42/ArmorPowerShell/blob/master/Armor/Private/Get-ArmorApiData.ps1

        .LINK
        https://docs.armor.com/display/KBSS/Armor+API+Guide

        .LINK
        https://developer.armor.com/

        .COMPONENT
        Armor API

        .FUNCTIONALITY
        Armor API schema management
    #>

    [CmdletBinding( DefaultParameterSetName = 'ApiVersion' )]
    [OutputType( [PSCustomObject], ParameterSetName = 'ApiVersion' )]
    [OutputType( [String[]], ParameterSetName = 'ApiVersions' )]
    param (
        # Specifies the cmdlet name to lookup the API data for.
        [Parameter(
            Position = 0,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true
        )]
        [ValidateNotNullorEmpty()]
        [String]
        $FunctionName = 'Example',

        # Specifies the API version for this request.
        [Parameter(
            ParameterSetName = 'ApiVersion',
            Position = 1,
            ValueFromPipelineByPropertyName = $true
        )]
        [ValidateScript( { $_ -match '^(?:v\d+\.\d+|internal)$' } )]
        [String]
        $ApiVersion = $Global:ArmorSession.ApiVersion,

        <#
        Specifies that the available API versions for the specified function should be
        enumerated.
        #>
        [Parameter(
            ParameterSetName = 'ApiVersions',
            Position = 1,
            ValueFromPipelineByPropertyName = $true
        )]
        [Switch]
        $ApiVersions = $false
    )

    begin {
        $function = $MyInvocation.MyCommand.Name

        Write-Verbose -Message "Beginning: '${function}' with ParameterSetName '$( $PSCmdlet.ParameterSetName )' and Parameters: $( $PSBoundParameters | Out-String )"
    } # End of begin

    process {
        if ( $ApiVersions -eq $true ) {
            [String[]] $return = $null
        }
        else {
            [PSCustomObject] $return = $null
        }

        Write-Verbose -Message "Gather API Data for: '${FunctionName}'."

        $modulePath = Split-Path -Path $PSScriptRoot -Parent
        $filePath = Join-Path -Path $modulePath -ChildPath 'Etc'
        $filePath = Join-Path -Path $filePath -ChildPath 'ApiData.json'
        $api = Get-Content -Path $filePath |
            ConvertFrom-Json -ErrorAction 'Stop'

        if ( $api.$FunctionName -eq $null ) {
            throw "Invalid endpoint: '${FunctionName}'"
        }
        elseif ( $PSCmdlet.ParameterSetName -eq 'ApiVersion' -and $api.$FunctionName.$ApiVersion -eq $null ) {
            throw "Invalid endpoint version: '${ApiVersion}'"
        }
        elseif ( $PSCmdlet.ParameterSetName -eq 'ApiVersions' -and $ApiVersions -eq $true ) {
            $return = ( $api.$FunctionName | Get-Member -MemberType 'NoteProperty' ).Name |
                Sort-Object
        }
        else {
            $return = $api.$FunctionName.$ApiVersion
        }

        $return
    } # End of process

    end {
        Write-Verbose -Message "Ending: '${function}'."
    } # End of end
} # End of function
