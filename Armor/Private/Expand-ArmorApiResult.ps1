function Expand-ArmorApiResult {
    <#
        .SYNOPSIS
        Removes any parent variables surrounding response data.

        .DESCRIPTION
        Removes any parent variables surrounding response data, such as encapsulating
        results in a "data" key.

        .INPUTS
        System.Management.Automation.PSObject[]

        .INPUTS
        System.Management.Automation.PSObject

        .NOTES
        - Troy Lindsay
        - Twitter: @troylindsay42
        - GitHub: tlindsay42

        .EXAMPLE
        Expand-ArmorApiResult -Results [PSCustomObject] @{ Data = [PSCustomObject] @{ Important = 'Info' } } -Location 'Data'
        Returns the value of the 'Data' property.

        .EXAMPLE
        [PSCustomObject] @{ Data = [PSCustomObject] @{ Important = 'Info' } } | Expand-ArmorApiResult -Location 'Data'
        Returns the value of the 'Data' property.

        .LINK
        https://tlindsay42.github.io/ArmorPowerShell/private/Expand-ArmorApiResult/

        .LINK
        https://github.com/tlindsay42/ArmorPowerShell/blob/master/Armor/Private/Expand-ArmorApiResult.ps1

        .LINK
        https://docs.armor.com/display/KBSS/Armor+API+Guide

        .LINK
        https://developer.armor.com/

        .COMPONENT
        Armor API

        .FUNCTIONALITY
        Armor API response body property expansion
    #>

    [CmdletBinding()]
    [OutputType( [PSCustomObject[]] )]
    [OutputType( [PSCustomObject] )]
    param (
        # Specifies the unformatted API response content.
        [Parameter(
            Position = 0,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true
        )]
        [AllowEmptyCollection()]
        [ValidateNotNull()]
        [PSCustomObject[]]
        $Results = @(),

        <#
        Specifies the key/value pair that contains the name of the key holding the
        response content's data.
        #>
        [Parameter( Position = 1 )]
        [ValidateNotNullOrEmpty()]
        [String]
        $Location
    )

    begin {
        $function = $MyInvocation.MyCommand.Name

        Write-Verbose -Message "Beginning: '${function}' with ParameterSetName '$( $PSCmdlet.ParameterSetName )' and Parameters: $( $PSBoundParameters | Out-String )"
    }

    process {
        [PSCustomObject[]] $return = @()

        foreach ( $result in $Results ) {
            if ( $Location -and $result.$Location -ne $null ) {
                <#
                The $Location check assumes that not all endpoints will require
                finding (and removing) a parent key if one does exist, this
                extracts the value so that the $result data is consistent
                across API versions.
                #>
                $return += $result.$Location
            }
        }

        $return
    }

    end {
        Write-Verbose -Message "Ending: '${function}'."
    }
}
