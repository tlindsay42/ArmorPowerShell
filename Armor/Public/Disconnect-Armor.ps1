function Disconnect-Armor {
    <#
        .SYNOPSIS
        Disconnects from Armor and destroys the session information.

        .DESCRIPTION
        Disconnects from the Armor API and destroys the $Global:ArmorSession session
        variable.

        .INPUTS
        None
            You cannot pipe input to this cmdlet.

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
        Write-Verbose -Message "Beginning: '${function}'."
    }

    process {
        Write-Verbose -Message (
            "Processing: '${function}' with ParameterSetName '$( $PSCmdlet.ParameterSetName )' and Parameters: " +
            ( $PSBoundParameters | Hide-SensitiveData | Format-Table -AutoSize | Out-String )
        )

        if ( $PSCmdlet.ShouldProcess( 'Armor session', 'Disconnect' ) ) {
            Write-Verbose -Message 'Disconnecting from Armor.'
            Set-Variable -Scope 'Global' -Name 'ArmorSession' -Value $null -Force
            Remove-Variable -Scope 'Global' -Name 'ArmorSession' -Force
        }
    }

    end {
        Write-Verbose -Message "Ending: '${function}'."
    }
}
