function Stop-ArmorCompleteVM {
    <#
        .SYNOPSIS
        Stops Armor Complete virtual machines.

        .DESCRIPTION
        The specified virtual machine in the Armor Complete account in context will be
        powered down.

        .INPUTS
        UInt16

        PSCustomObject

        .NOTES
        - Troy Lindsay
        - Twitter: @troylindsay42
        - GitHub: tlindsay42

        .EXAMPLE
        Stop-ArmorCompleteVM -ID 1 -Type Shutdown
        If confirmed, gracefully shutdown the specified Armor Complete VM.

        .EXAMPLE
        2 | Stop-ArmorCompleteVM -Type Poweroff -Confirm:$false
        Power off the Armor Complete VM with ID=2 via pipeline value without prompting
        for confirmation.

        .EXAMPLE
        Get-ArmorVM -ID 3 | Stop-ArmorCompleteVM -Type ForceOff -Confirm:$false
        Break the state of the Armor Complete VM with ID=3 via parameter name in the
        pipeline without prompting for confirmation, so that the VM appears to be
        powered off in the Armor Management Portal (AMP), but is still powered on in
        the Armor Complete cloud.

        .LINK
        https://tlindsay42.github.io/ArmorPowerShell/public/Stop-ArmorCompleteVM/

        .LINK
        https://github.com/tlindsay42/ArmorPowerShell/blob/master/Armor/Public/Stop-ArmorCompleteVM.ps1

        .LINK
        https://docs.armor.com/display/KBSS/Perform+VM+Power+Actions

        .LINK
        https://developer.armor.com/#!/Infrastructure/Vm_PowerActionVm

        .COMPONENT
        Armor Complete

        .FUNCTIONALITY
        Armor Complete infrastructure management
    #>

    [CmdletBinding( SupportsShouldProcess = $true, ConfirmImpact = 'High' )]
    [OutputType( [ArmorVM[]] )]
    [OutputType( [ArmorVM] )]
    param (
        # Specifies the ID of the Armor Complete virtual machine that you want to stop.
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

        - Shutdown
          - Initiates a graceful shutdown of the operating system.
          - VMware Tools or open-vm-tools must be installed, running, and in a good
            state for this request to succeed.
          - This is the recommend way to stop your VMs.
        - Poweroff
          - Initiates a hard shutdown of the VM- effectively disconnecting the virtual
            power cord from the VM.
          - This shutdown method has the potential to cause data corruption.
          - This should only be used when necessary.
        - ForceOff
          - Breaks the state of the environment by marking the VM as powered off in
            the Armor Management Portal (AMP), but leaves the VM running in the Armor
            Complete cloud.
          - This should not be used unless recommended by a Senior Armor Support team
            member.
        #>
        [Parameter( Position = 1 )]
        [ValidateSet( 'Shutdown', 'Poweroff', 'ForceOff' )]
        [String]
        $Type = 'Shutdown',

        # Specifies the API version for this request.
        [Parameter( Position = 2 )]
        [ValidateSet( 'v1.0', 'internal' )]
        [String]
        $ApiVersion = $Global:ArmorSession.ApiVersion
    )

    begin {
        $function = $MyInvocation.MyCommand.Name

        Write-Verbose -Message "Beginning: '${function}' with ParameterSetName '$( $PSCmdlet.ParameterSetName )' and Parameters: $( $PSBoundParameters | Out-String )"

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
                $description = ( $resources.Description -f 'Break the state of' ) +
                ' so that the Armor Management Portal (AMP) will indicate that the VM is powered off, but the VM ' +
                'will still be running in the Armor Complete cloud.'
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
