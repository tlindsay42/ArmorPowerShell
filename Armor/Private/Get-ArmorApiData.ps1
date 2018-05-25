function Get-ArmorApiData {
    <#
        .SYNOPSIS
        This cmdlet retrieves data for making requests to the Armor API.

        .DESCRIPTION
        This cmdlet gets all of the data necessary to construct an API request
        based on the specified cmdlet name.

        .INPUTS
        String

        PSCustomObject

        .NOTES
        Troy Lindsay
        Twitter: @troylindsay42
        GitHub: tlindsay42

        .EXAMPLE
        Get-ArmorApiData -FunctionName 'Connect-Armor' -ApiVersion 'v1.0'

        Name        Value
        ----        -----
        SuccessCode 200
        Query       {}
        Description Create a new login session
        Body        {Password, Username}
        Location
        Method      Post
        Filter      {}
        URI         {/auth/authorize}


        Description
        -----------
        This command gets all of the data necessary to construct an API request
        for the Connect-Armor cmdlet.

        .LINK
        http://armorpowershell.readthedocs.io/en/latest/index.html

        .LINK
        https://github.com/tlindsay42/ArmorPowerShell

        .LINK
        https://docs.armor.com/display/KBSS/Armor+API+Guide

        .LINK
        https://developer.armor.com/
    #>

    [CmdletBinding( DefaultParameterSetName = 'ApiVersion' )]
    [OutputType( [PSCustomObject], ParameterSetName = 'ApiVersion' )]
    [OutputType( [String[]], ParameterSetName = 'ApiVersions' )]
    param (
        <#
        Specifies the cmdlet name to lookup the API data for.
        #>
        [Parameter(
            Position = 0,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true
        )]
        [ValidateNotNullorEmpty()]
        [String]
        $FunctionName = 'Example',

        <#
        Specifies the API version for this request.
        #>
        [Parameter(
            ParameterSetName = 'ApiVersion',
            Position = 1,
            ValueFromPipelineByPropertyName = $true
        )]
        [ValidateScript( { $_ -match '^v\d+\.\d+$' } )]
        [String]
        $ApiVersion = $Global:ArmorSession.ApiVersion,

        <#
        Specifies that the available API versions for the specified function
        should be enumerated.
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

        Write-Verbose -Message "Beginning: '${function}'."
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
        elseif ( $api.$FunctionName.$ApiVersion -eq $null -and $ApiVersions -eq $false ) {
            throw "Invalid endpoint version: '${ApiVersion}'"
        }
        elseif ( $ApiVersions -eq $true ) {
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
