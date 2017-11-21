function Disconnect-Armor {
    <#
        .SYNOPSIS
        Disconnects from Armor and destroys the session information.

        .DESCRIPTION
        { required: more detailed description of the function's purpose }

        .NOTES
        Troy Lindsay
        Twitter: @troylindsay42
        GitHub: tlindsay42

        .INPUTS
        None
            You cannot pipe objects to Disonnect-Armor.

        .OUTPUTS
        None

        .LINK
        https://github.com/tlindsay42/ArmorPowerShell

        .LINK
        https://docs.armor.com/display/KBSS/Armor+API+Guide

        .LINK
        https://developer.armor.com/

        .EXAMPLE
        Disconnect-Armor
    #>

    [CmdletBinding( SupportsShouldProcess = $true, ConfirmImpact = 'High' )]
    param ()

    begin {
        $function = $MyInvocation.MyCommand.Name

        Write-Verbose -Message ( 'Beginning {0}.' -f $function )
    } # End of begin

    process {
        if ( $PSCmdlet.ShouldProcess( 'Armor session', 'Disconnect' ) ) {
            Write-Verbose -Message 'Disconnecting from Armor.'

            Remove-Variable -Name ArmorSession -Scope Global
        }
    } # End of process

    end {
        Write-Verbose -Message ( 'Ending {0}.' -f $function )
    } # End of end
} # End of function
