function Disconnect-Armor {
    <#
        .SYNOPSIS
        Disconnects from Armor and destroys the session information.

        .DESCRIPTION
        Disconnects from the Armor API and destroys the $Global:ArmorSession
        session variable.

        .INPUTS
        None- you cannot pipe objects to this cmdlet.

        .NOTES
        Troy Lindsay
        Twitter: @troylindsay42
        GitHub: tlindsay42

        .EXAMPLE
        Disconnect-Armor

        .LINK
        https://github.com/tlindsay42/ArmorPowerShell

        .LINK
        https://docs.armor.com/display/KBSS/Armor+API+Guide

        .LINK
        https://developer.armor.com/
    #>

    [CmdletBinding( SupportsShouldProcess = $true, ConfirmImpact = 'High' )]
    [OutputType( [Void] )]
    param ()

    begin {
        $function = $MyInvocation.MyCommand.Name

        Write-Verbose -Message ( 'Beginning {0}.' -f $function )
    } # End of begin

    process {
        if ( $PSCmdlet.ShouldProcess( 'Armor session', 'Disconnect' ) ) {
            Write-Verbose -Message 'Disconnecting from Armor.'

            $Global:ArmorSession = $null
            Remove-Variable -Name 'ArmorSession' -Scope 'Global'
        }
    } # End of process

    end {
        Write-Verbose -Message ( 'Ending {0}.' -f $function )
    } # End of end
} # End of function
