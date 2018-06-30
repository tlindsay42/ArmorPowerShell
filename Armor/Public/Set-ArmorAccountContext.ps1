function Set-ArmorAccountContext {
    <#
        .SYNOPSIS
        Sets the Armor Anywhere or Armor Complete account context.

        .DESCRIPTION
        If your user account has access to more than one Armor Anywhere and/or Armor
        Complete accounts, this cmdlet allows you to update the context, so that all
        future requests reference the specified account.

        .INPUTS
        System.UInt16

        .INPUTS
        System.Management.Automation.PSObject

        .NOTES
        - Troy Lindsay
        - Twitter: @troylindsay42
        - GitHub: tlindsay42

        .EXAMPLE
        Set-ArmorAccountContext -ID 1
        Set the account context to the specified account ID so that all subsequent
        commands reference that account.

        .EXAMPLE
        2 | Set-ArmorAccountContext
        Set the account context to 2 via the value in the pipeline.

        .EXAMPLE
        Get-ArmorAccount -ID 3 | Set-ArmorAccountContext
        Set the account context to 3 via the ID property name in the pipeline.

        .LINK
        https://tlindsay42.github.io/ArmorPowerShell/public/Set-ArmorAccountContext/

        .LINK
        https://github.com/tlindsay42/ArmorPowerShell/blob/master/Armor/Public/Set-ArmorAccountContext.ps1

        .LINK
        https://docs.armor.com/display/KBSS/Log+into+Armor+API

        .LINK
        https://developer.armor.com/

        .COMPONENT
        Armor Complete

        .FUNCTIONALITY
        Armor Complete infrastructure management
    #>

    [CmdletBinding()]
    [OutputType( [ArmorAccount] )]
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
        [ValidateScript( { $_ -in $Global:ArmorSession.Accounts.ID } )]
        [UInt16]
        $ID
    )

    begin {
        $function = $MyInvocation.MyCommand.Name

        Write-Verbose -Message "Beginning: '${function}' with ParameterSetName '$( $PSCmdlet.ParameterSetName )' and Parameters: $( $PSBoundParameters | Out-String )"

        Test-ArmorSession
    }

    process {
        $Global:ArmorSession.SetAccountContext( $ID )
    }

    end {
        Write-Verbose -Message "Ending: '${function}'."
    }
}
