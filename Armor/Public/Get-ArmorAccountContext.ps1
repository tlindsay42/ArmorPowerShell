function Get-ArmorAccountContext {
    <#
        .SYNOPSIS
        This cmdlet gets the Armor Anywhere or Armor Complete account context.

        .DESCRIPTION
        If your user account has access to more than one Armor Anywhere and/or
        Armor Complete accounts, this cmdlet allows you to get the current
        context, which all future requests will reference.

        .INPUTS
        None- you cannot pipe objects to this cmdlet.

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
    param ()

    begin {
        $function = $MyInvocation.MyCommand.Name

        Write-Verbose -Message ( 'Beginning {0}.' -f $function )
    } # End of begin

    process {
        [ArmorAccount] $return = $Global:ArmorSession.GetAccountContext()

        $return
    } # End of process

    end {
        Write-Verbose -Message ( 'Ending {0}.' -f $function )
    } # End of end
} # End of function
