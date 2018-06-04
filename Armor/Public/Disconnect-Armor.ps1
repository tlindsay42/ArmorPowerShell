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
        Performing the operation "Disconnect" on target "Armor session".
        [Y] Yes  [A] Yes to All  [N] No  [L] No to All  [S] Suspend  [?] Help (default is "Y"): Y

        C:\>( Get-Variable -Scope Global ).Where( { $_.Name -eq 'ArmorSession' } ).Count
        0


        Description
        -----------
        Disconnects from the Armor API, destroys the $Global:ArmorSession, and
        then proves that the global scope ArmorSession variable no longer exists.

        .LINK
        http://armorpowershell.readthedocs.io/en/latest/cmd_disconnect.html#disconnect-armor

        .LINK
        https://github.com/tlindsay42/ArmorPowerShell/blob/master/Armor/Public/Disconnect-Armor.ps1

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

        Write-Verbose -Message "Beginning: '${function}'."
    } # End of begin

    process {
        if ( $PSCmdlet.ShouldProcess( 'Armor session', 'Disconnect' ) ) {
            Write-Verbose -Message 'Disconnecting from Armor.'

            $Global:ArmorSession = $null
            Remove-Variable -Name 'ArmorSession' -Scope 'Global'
        }
    } # End of process

    end {
        Write-Verbose -Message "Ending: '${function}'."
    } # End of end
} # End of function
