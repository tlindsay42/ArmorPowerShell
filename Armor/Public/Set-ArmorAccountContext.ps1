function Set-ArmorAccountContext {
    <#
        .SYNOPSIS
        This cmdlet sets the Armor Anywhere or Armor Complete account context.

        .DESCRIPTION
        If your user account has access to more than one Armor Anywhere and/or
        Armor Complete accounts, this cmdlet allows you to update the context,
        so that all future requests reference the specified account.

        .INPUTS
        System.UInt16

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

    [CmdletBinding()]
    [OutputType( 'ArmorAccount' )]
    param (
        <#
        Specifies which Armor account should be used for the context of all
        subsequent requests.
        #>
        [Parameter(
            Mandatory = $true,
            Position = 0,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true
        )]
        [ValidateScript( { $_ -in ( Get-ArmorIdentity ).Accounts.ID } )]
        [UInt16]
        $ID
    )

    begin {
        $function = $MyInvocation.MyCommand.Name

        Write-Verbose -Message ( 'Beginning {0}.' -f $function )

        Test-ArmorSession
    } # End of begin

    process {
        [ArmorAccount] $return = $Global:ArmorSession.SetAccountContext( $ID )

        $return
    } # End of process

    end {
        Write-Verbose -Message ( 'Ending {0}.' -f $function )
    } # End of end
} # End of function
