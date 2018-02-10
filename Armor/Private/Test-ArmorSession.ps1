function Test-ArmorSession {
    <#
        .SYNOPSIS
        Armor API session test.

        .DESCRIPTION
        Test to see if a session has been established with the Armor API.
        If no token is found, this will throw an error and halt the script.
        Otherwise, the token is loaded into the script's $Header variable.

        .INPUTS
        None
            You cannot pipe objects to Test-ArmorSession.

        .NOTES
        Troy Lindsay
        Twitter: @troylindsay42
        GitHub: tlindsay42

        .EXAMPLE
        Test-ArmorSession


        Description
        -----------
        Validates that there is an Armor API connection token stored in '$Global:ArmorSession.Token'.

        .LINK
        https://github.com/tlindsay42/ArmorPowerShell

        .LINK
        https://docs.armor.com/display/KBSS/Armor+API+Guide

        .LINK
        https://developer.armor.com/
    #>

    [CmdletBinding()]
    [OutputType( [Void] )]
    param ()

    begin {
        $function = $MyInvocation.MyCommand.Name

        Write-Verbose -Message ( 'Beginning {0}.' -f $function )
    } # End of begin

    process {
        Write-Verbose -Message 'Verify that the session authorization exists.'
        if ( -not $Global:ArmorSession ) {
            throw 'Session not found.  Please log in again.'
        }
        elseif ( -not $Global:ArmorSession.AuthorizationExists() ) {
            throw 'Session authorization not found.  Please log in again.'
        }

        Write-Verbose -Message 'Verify that the session is active.'
        if ( $Global:ArmorSession.IsActive() ) {
            $minutesRemaining = $Global:ArmorSession.GetMinutesRemaining()

            Write-Verbose -Message ( '{0} minutes remaining until session expiration.' -f $minutesRemaining )

            if ( $minutesRemaining -lt 25 ) {
                Write-Verbose -Message 'Renewing session token.'
                Update-ArmorApiToken -Token $Global:ArmorSession.GetToken()
            }
        }
        else {
            $expirationTime = $Global:ArmorSession.SessionExpirationTime

            Disconnect-Armor -Confirm:$false

            throw ( 'Session expired at {0}.  Please log in again.' -f $expirationTime )
        }
    } # End of process

    end {
        Write-Verbose -Message ( 'Ending {0}.' -f $function )
    } # End of end
} # End of function
