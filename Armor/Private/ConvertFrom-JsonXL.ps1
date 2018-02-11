function ConvertFrom-JsonXL {
    <#
        .SYNOPSIS
        This cmdlet converts large JSON formatted strings to a custom objects.

        .DESCRIPTION
        This cmdlet resolves the ConvertFrom-Json maxJsonLength limitation,
        which defaults to 2MB.

        .INPUTS
        System.String

        .NOTES
        Troy Lindsay
        Twitter: troylindsay42
        GitHub: tlindsay42

        .EXAMPLE
        {required: show one or more examples using the function}

        .LINK
        http://stackoverflow.com/questions/16854057/convertfrom-json-max-length/27125027

        .LINK
        http://armorpowershell.readthedocs.io/en/latest/index.html

        .LINK
        https://github.com/tlindsay42/ArmorPowerShell

        .LINK
        https://docs.armor.com/display/KBSS/Armor+API+Guide

        .LINK
        https://developer.armor.com/
    #>

    [CmdletBinding()]
    [OutputType( [PSCustomObject] )]
    param (
        <#
        Specifies the JSON string payload.
        #>
        [Parameter(
            Position = 0,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true
        )]
        [AllowEmptyString()]
        [String]
        $InputObject = ''
    )

    begin {
        $function = $MyInvocation.MyCommand.Name

        Write-Verbose -Message ( 'Beginning {0}.' -f $function )
    } # End of begin

    process {
        [PSCustomObject] $return = $null

        [void][System.Reflection.Assembly]::LoadWithPartialName( 'System.Web.Extensions' )

        $javaScriptSerializer = New-Object -TypeName 'System.Web.Script.Serialization.JavaScriptSerializer' -Property @{ 'MaxJsonLength' = 64MB }

        $return = $javaScriptSerializer.DeserializeObject( $InputObject ) |
            Expand-JsonItem

        $return
    } # End of process

    end {
        Write-Verbose -Message ( 'Ending {0}.' -f $function )
    } # End of end
} # End of function
