function Stop-ArmorCompleteVM {
    <#
        .SYNOPSIS
        { required: high level overview }

        .DESCRIPTION
        { required: more detailed description of the function's purpose }

        .NOTES
        Name Troy Lindsay
        Twitter: @troylindsay42
        GitHub: tlindsay42

        .INPUTS
        { required: .NET Framework object types that can be piped in and a description of the input objects }

        .OUTPUTS
        { required: .NET Framework object types that the cmdlet returns and a description of the returned objects }

        .LINK
        https://github.com/tlindsay42/ArmorPowerShell

        .LINK
        https://docs.armor.com/display/KBSS/Armor+API+Guide

        .LINK
        https://developer.armor.com/

        .EXAMPLE
        {required: show one or more examples using the function}
    #>

    [CmdletBinding( SupportsShouldProcess = $true, ConfirmImpact = 'High' )]
    param (
        <#
        Specifies the ID of the Armor Complete virtual machine that you want
        to stop.
        #>
        [Parameter( Position = 0 )]
        [ValidateRange( 1, 65535 )]
        [UInt16] $ID = 0,

        <#
        Specifies how you want to stop the Armor Complete virtual machine.
        #>
        [Parameter( Position = 1 )]
        [ValidateSet( 'Shutdown', 'Off', 'ForceOff' )]
        [String] $Type = 'Shutdown',

        <#
        Specifies the API version for this request.
        #>
        [Parameter( Position = 2 )]
        [ValidateSet( 'v1.0' )]
        [String] $ApiVersion = $Global:ArmorSession.ApiVersion
    )

    begin {
        $function = $MyInvocation.MyCommand.Name

        Write-Verbose -Message ( 'Beginning {0}.' -f $function )

        Test-ArmorSession
    } # End of begin

    process {
        $return = $null

        $resources = Get-ArmorApiData -Endpoint $function -ApiVersion $ApiVersion

        if ( $PSCmdlet.ShouldProcess( $ID, $resources.Description ) ) {
            $uri = New-ArmorApiUriString -Endpoints $resources.Uri.Where( { $_ -match ( '/{0}$' -f $Type ) } ) -IDs $ID

            $results = Submit-ArmorApiRequest -Uri $uri -Method $resources.Method -Description $resources.Description

            $results = Select-ArmorApiResult -Results $results -Filter $resources.Filter

            $return = $results
        }

        $return
    } # End of process

    end {
        Write-Verbose -Message ( 'Ending {0}.' -f $function )
    } # End of end
} # End of function
