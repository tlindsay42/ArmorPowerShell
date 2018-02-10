function Remove-ArmorCompleteWorkload {
    <#
        .SYNOPSIS
        The Remove-ArmorCompleteWorkload function deletes the specified workload in your account.

        .DESCRIPTION
        { required: more detailed description of the function's purpose }

        .INPUTS
        { required: .NET Framework object types that can be piped in and a description of the input objects }

        .NOTES
        Troy Lindsay
        Twitter: @troylindsay42
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

    [CmdletBinding( SupportsShouldProcess = $true, ConfirmImpact = 'High' )]
    [OutputType( [PSCustomObject[]] )]
    param (
        <#
        Specifies the ID of the Armor Complete workload.
        #>
        [Parameter( Position = 0 )]
        [ValidateRange( 1, 65535 )]
        [UInt16] $ID = 0,

        <#
        Specifies the API version for this request.
        #>
        [Parameter( Position = 1 )]
        [ValidateSet( 'v1.0' )]
        [String] $ApiVersion = $Global:ArmorSession.ApiVersion
    )

    begin {
        $function = $MyInvocation.MyCommand.Name

        Write-Verbose -Message ( 'Beginning {0}.' -f $function )

        Test-ArmorSession
    } # End of begin

    process {
        [PSCustomObject[]] $return = $null

        $resources = Get-ArmorApiData -Endpoint $function -ApiVersion $ApiVersion

        if ( $PSCmdlet.ShouldProcess( $ID, $resources.Description ) ) {
            $uri = New-ArmorApiUriString -Endpoints $resources.Uri -IDs $ID

            $body = Format-ArmorApiJsonRequestBody -BodyKeys $resources.Body.Keys -Parameters ( Get-Command -Name $function ).Parameters.Values

            $results = Submit-ArmorApiRequest -Uri $uri -Method $resources.Method -Body $body -Description $resources.Description

            $return = $results
        }

        $return
    } # End of process

    end {
        Write-Verbose -Message ( 'Ending {0}.' -f $function )
    } # End of end
} # End of function
