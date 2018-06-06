function Stop-ArmorCompleteVM {
    <#
        .SYNOPSIS
        Stops Armor Complete virtual machines.

        .DESCRIPTION
        The specified virtual machine in the Armor Complete account in context
        will be powered off.

        Types:

        - Shutdown initiates a graceful shutdown of the operating system.
          VMware Tools or open-vm-tools must be installed and running for this
          request to succeed.  This the recommend way to stop your VMs.

        - Off initiates a hard shutdown of the VM- effectively disconnecting
          the virtual power cord from the VM.  This shutdown method has the
          potential to cause data corruption and should only be used when
          necessary.

        - ForceOff should not be used.  It breaks the state of the environment
          by marking the VM as powered off in the Armor Management Portal (AMP)
          and vCloud Director, but leaves the VM running in vSphere.

        .INPUTS
        UInt16

        PSCustomObject

        .NOTES
        Troy Lindsay
        Twitter: @troylindsay42
        GitHub: tlindsay42

        .EXAMPLE
        ( Stop-ArmorCompleteVM -ID 1 -Type Shutdown -Confirm:$false ).Name

        TEST-VM

        .EXAMPLE
        ( Get-ArmorVM -ID 1 | Stop-ArmorCompleteVM -Type Poweroff ).Name

        Confirm
        Are you sure you want to perform this action?
        Performing the operation "Power off the specified virtual machine in your account" on target "1".
        [Y] Yes  [A] Yes to All  [N] No  [L] No to All  [S] Suspend  [?] Help (default is "Y"): y

        TEST-VM

        .LINK
        http://armorpowershell.readthedocs.io/en/latest/cmd_stop.html#stop-armorcompletevm

        .LINK
        https://github.com/tlindsay42/ArmorPowerShell/blob/master/Armor/Public/Stop-ArmorCompleteVM.ps1

        .LINK
        https://docs.armor.com/display/KBSS/Perform+VM+Power+Actions

        .LINK
        https://developer.armor.com/#!/Infrastructure/Vm_PowerActionVm
    #>

    [CmdletBinding( SupportsShouldProcess = $true, ConfirmImpact = 'High' )]
    [OutputType( [ArmorVM[]] )]
    [OutputType( [ArmorVM] )]
    param (
        <#
        Specifies the ID of the Armor Complete virtual machine that you want
        to stop.
        #>
        [Parameter(
            Mandatory = $true,
            HelpMessage = 'Please enter the ID of the Armor Complete virtual machine that you want to stop',
            Position = 0,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true
        )]
        [ValidateRange( 1, 65535 )]
        [UInt16]
        $ID,

        <#
        Specifies how you want to stop the Armor Complete virtual machine.

        Types:

        - Shutdown initiates a graceful shutdown of the operating system.
          VMware Tools or open-vm-tools must be installed and running for this
          request to succeed.  This the recommend way to stop your VMs.

        - Poweroff initiates a hard shutdown of the VM- effectively
          disconnecting the virtual power cord from the VM.  This shutdown
          method has the potential to cause data corruption and should only be
          used when necessary.

        - ForceOff should not be used.  It breaks the state of the environment
          by marking the VM as powered off in the Armor Management Portal (AMP)
          and vCloud Director, but leaves the VM running in vSphere.
        #>
        [Parameter( Position = 1 )]
        [ValidateSet( 'Shutdown', 'Poweroff', 'ForceOff' )]
        [String]
        $Type = 'Shutdown',

        <#
        Specifies the API version for this request.
        #>
        [Parameter( Position = 2 )]
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
        [ArmorVM[]] $return = $null
        $description = ''
        $stopType = $Type

        $resources = Get-ArmorApiData -FunctionName $function -ApiVersion $ApiVersion

        switch ( $Type ) {
            'Shutdown' {
                $description = $resources.Description -f 'Gracefully shutdown'
            }

            'Poweroff' {
                $description = $resources.Description -f 'Power off'
                $stopType = 'Off'
            }

            'ForceOff' {
                $description = $resources.Description -f 'Force poweroff'
            }
        }

        if ( $PSCmdlet.ShouldProcess( $ID, $description ) ) {
            $uri = New-ArmorApiUri -Endpoints $resources.Endpoints.Where( { $_ -match "/${stopType}$" } ) -IDs $ID

            $keys = ( $resources.Body | Get-Member -MemberType 'NoteProperty' ).Name
            $parameters = ( Get-Command -Name $function ).Parameters.Values
            $body = Format-ArmorApiRequestBody -Keys $keys -Parameters $parameters

            $splat = @{
                'Uri'         = $uri
                'Method'      = $resources.Method
                'Body'        = $body
                'SuccessCode' = $resources.SuccessCode
                'Description' = $resources.Description
            }
            $results = Submit-ArmorApiRequest @splat

            $return = $results
        }

        $return
    } # End of process

    end {
        Write-Verbose -Message "Ending: '${function}'."
    } # End of end
} # End of function
