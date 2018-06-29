function Disconnect-Armor {
    <#
        .SYNOPSIS
        Disconnects from Armor and destroys the session information.

        .DESCRIPTION
        Disconnects from the Armor API and destroys the $Global:ArmorSession session
        variable.

        .INPUTS
        None- this function does not accept pipeline inputs.

        .NOTES
        - Troy Lindsay
        - Twitter: @troylindsay42
        - GitHub: tlindsay42

        .EXAMPLE
        Disconnect-Armor
        Disconnects from the Armor API and destroys the $Global:ArmorSession session
        variable.

        .LINK
        https://tlindsay42.github.io/ArmorPowerShell/public/Disconnect-Armor/

        .LINK
        https://github.com/tlindsay42/ArmorPowerShell/blob/master/Armor/Public/Disconnect-Armor.ps1

        .LINK
        https://docs.armor.com/display/KBSS/Armor+API+Guide

        .LINK
        https://developer.armor.com/

        .COMPONENT
        Armor API

        .FUNCTIONALITY
        Armor session management
    #>

    [CmdletBinding( SupportsShouldProcess = $true, ConfirmImpact = 'High' )]
    [OutputType( [Void] )]
    param ()

    begin {
        $function = $MyInvocation.MyCommand.Name

        Write-Verbose -Message "Beginning: '${function}' with ParameterSetName '$( $PSCmdlet.ParameterSetName )' and Parameters: $( $PSBoundParameters | Out-String )"
    }

    process {
        if ( $PSCmdlet.ShouldProcess( 'Armor session', 'Disconnect' ) ) {
            Write-Verbose -Message 'Disconnecting from Armor.'

            $Global:ArmorSession = $null
            Remove-Variable -Name 'ArmorSession' -Scope 'Global'
        }
    }

    end {
        Write-Verbose -Message "Ending: '${function}'."
    }
}
