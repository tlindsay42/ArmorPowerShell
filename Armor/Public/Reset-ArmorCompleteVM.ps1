function Reset-ArmorCompleteVM {
    <#
        .SYNOPSIS
        This cmdlet powers off & on virtual machines.

        .DESCRIPTION
        The specified virtual machine in the Armor Complete account in context
        will be hard reset- effectively disconnecting the virtual power cord
        from the VM, plugging it back in, and then powering it back on.  This
        reboot method has the potential to cause data corruption and should
        only be used when necessary.

        See also: Restart-ArmorCompleteVM

        .INPUTS
        System.UInt16

        .NOTES
        Troy Lindsay
        Twitter: @troylindsay42
        GitHub: tlindsay42

        .EXAMPLE
        {required: show one or more examples using the function}

        .LINK
        http://armorpowershell.readthedocs.io/en/latest/cmd_reset.html#reset-armorcompletevm

        .LINK
        https://github.com/tlindsay42/ArmorPowerShell

        .LINK
        https://docs.armor.com/display/KBSS/Perform+VM+Power+Actions

        .LINK
        https://developer.armor.com/#!/Infrastructure/Vm_PowerActionVm
    #>

    [CmdletBinding( SupportsShouldProcess = $true, ConfirmImpact = 'High' )]
    [OutputType( [PSCustomObject[]] )]
    param (
        <#
        Specifies the ID of the Armor Complete virtual machine that you want to
        power off & on.
        #>
        [Parameter(
            Mandatory = $true,
            HelpMessage = 'Please enter the ID of the Armor Complete virtual machine that you want to power off & on',
            Position = 0,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true
        )]
        [ValidateRange( 1, 65535 )]
        [UInt16]
        $ID,

        <#
        Specifies the API version for this request.
        #>
        [Parameter( Position = 1 )]
        [ValidateSet( 'v1.0' )]
        [String]
        $ApiVersion = $Global:ArmorSession.ApiVersion
    )

    begin {
        $function = $MyInvocation.MyCommand.Name

        Write-Verbose -Message "Beginning: '${function}'."

        Test-ArmorSession
    } # End of begin

    process {
        [PSCustomObject[]] $return = $null

        $resources = Get-ArmorApiData -FunctionName $function -ApiVersion $ApiVersion

        if ( $PSCmdlet.ShouldProcess( $ID, $resources.Description ) ) {
            $uri = New-ArmorApiUriString -Endpoints $resources.Uri -IDs $ID

            $results = Submit-ArmorApiRequest -Uri $uri -Method $resources.Method -Description $resources.Description

            $return = $results
        }

        $return
    } # End of process

    end {
        Write-Verbose -Message "Ending: '${function}'."
    } # End of end
} # End of function
