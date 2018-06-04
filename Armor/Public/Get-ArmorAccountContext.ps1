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
        Get-ArmorAccountContext

        ID       : 65536
        Name     : Example Parent Account
        Currency : USD
        Status   : Claimed
        Parent   : -1
        Products :


        Description
        -----------
        Gets the Armor account currently in context.

        .LINK
        http://armorpowershell.readthedocs.io/en/latest/cmd_get.html#get-armoraccountcontext

        .LINK
        https://github.com/tlindsay42/ArmorPowerShell/blob/master/Armor/Public/Get-ArmorAccountContext.ps1

        .LINK
        https://docs.armor.com/display/KBSS/Log+into+Armor+API

        .LINK
        https://developer.armor.com/
    #>

    [CmdletBinding()]
    [OutputType( [ArmorAccount] )]
    param ()

    begin {
        $function = $MyInvocation.MyCommand.Name

        Write-Verbose -Message "Beginning: '${function}'."
    } # End of begin

    process {
        [ArmorAccount] $return = $Global:ArmorSession.GetAccountContext()

        $return
    } # End of process

    end {
        Write-Verbose -Message "Ending: '${function}'."
    } # End of end
} # End of function
