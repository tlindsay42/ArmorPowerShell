function ConvertFrom-JsonXL {
    <#
        .SYNOPSIS
        Helper JSON function to resolve the ConvertFrom-Json maxJsonLength limitation, which defaults to 2MB.
        http://stackoverflow.com/questions/16854057/convertfrom-json-max-length/27125027

        .DESCRIPTION
        { required: more detailed description of the function's purpose }

        .INPUTS
        System.String

        .NOTES
        Troy Lindsay
        Twitter: troylindsay42
        GitHub: tlindsay42

        .EXAMPLE
        {required: show one or more examples using the function}

        .LINK
        https://github.com/tlindsay42/ArmorPowerShell

        .LINK
        https://docs.armor.com/display/KBSS/Armor+API+Guide

        .LINK
        https://developer.armor.com/
    #>

    [CmdletBinding()]
    [OutputType( [PSCustomObject[]] )]
    param (
        <#
        Specifies the JSON string payload.
        #>
        [Parameter( Position = 0, ValueFromPipeline = $true )]
        [String] $InputObject = ''
    )

    begin {
        $function = $MyInvocation.MyCommand.Name

        Write-Verbose -Message ( 'Beginning {0}.' -f $function )
    } # End of begin

    process {
        [PSCustomObject[]] $return = $null

        [void][System.Reflection.Assembly]::LoadWithPartialName( 'System.Web.Extensions' )
        
        $javaScriptSerializer = New-Object -TypeName System.Web.Script.Serialization.JavaScriptSerializer -Property @{ 'MaxJsonLength' = 64MB }

        $return = $javaScriptSerializer.DeserializeObject( $InputObject ) |
            Expand-JsonItem

        $return
    } # End of process

    end {
        Write-Verbose -Message ( 'Ending {0}.' -f $function )
    } # End of end
} # End of function
