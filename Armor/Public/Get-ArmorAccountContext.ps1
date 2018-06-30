function Get-ArmorAccountContext {
    <#
        .SYNOPSIS
        Retrieves the Armor Anywhere or Armor Complete account currently in context.

        .DESCRIPTION
        If your user account has access to more than one Armor Anywhere and/or Armor
        Complete accounts, this cmdlet allows you to get the current context, which all
        future requests will reference.

        .INPUTS
        None
            You cannot pipe input to this cmdlet.

        .NOTES
        - Troy Lindsay
        - Twitter: @troylindsay42
        - GitHub: tlindsay42

        .EXAMPLE
        Get-ArmorAccountContext
        Retrieves the Armor account currently in context.

        .LINK
        https://tlindsay42.github.io/ArmorPowerShell/public/Get-ArmorAccountContext/

        .LINK
        https://github.com/tlindsay42/ArmorPowerShell/blob/master/Armor/Public/Get-ArmorAccountContext.ps1

        .LINK
        https://docs.armor.com/display/KBSS/Log+into+Armor+API

        .LINK
        https://developer.armor.com/

        .COMPONENT
        Armor API

        .FUNCTIONALITY
        Armor session management
    #>

    [CmdletBinding()]
    [OutputType( [ArmorAccount] )]
    param ()

    begin {
        $function = $MyInvocation.MyCommand.Name

        Write-Verbose -Message "Beginning: '${function}' with ParameterSetName '$( $PSCmdlet.ParameterSetName )' and Parameters: $( $PSBoundParameters | Out-String )"
    }

    process {
        [ArmorAccount] $return = $Global:ArmorSession.GetAccountContext()

        $return
    }

    end {
        Write-Verbose -Message "Ending: '${function}'."
    }
}
