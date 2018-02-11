function Stop-ArmorCompleteVM {
    <#
        .SYNOPSIS
        This cmdlet powers off Armor Complete virtual machines.

        .DESCRIPTION
        The specified virtual machine in the Armor Complete account in context
        will be powered off.

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

    [CmdletBinding( SupportsShouldProcess = $true, ConfirmImpact = 'High' )]
    [OutputType( [PSCustomObject[]] )]
    param (
        <#
        Specifies the ID of the Armor Complete virtual machine that you want
        to stop.
        #>
        [Parameter( Position = 0 )]
        [ValidateRange( 1, 65535 )]
        [UInt16] $ID = 0,

        <#
        Specifies how you want to stop the Armor Complete virtual machine.

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
        #>
        [Parameter( Position = 1 )]
        [ValidateSet( 'Shutdown', 'Off', 'ForceOff' )]
        [String] $Type = 'Shutdown',

        <#
        Specifies the API version for this request.
        #>
        [Parameter( Position = 2 )]
        [ValidateSet( 'v1.0' )]
        [String] $ApiVersion = $Global:ArmorSession.ApiVersion
    )

    begin {
        $function = $MyInvocation.MyCommand.Name

        Write-Verbose -Message ( 'Beginning {0}.' -f $function )

        Test-ArmorSession
    } # End of begin

    process {
        [PSCustomObject[]] $return = $null

        $resources = Get-ArmorApiData -Endpoint $function -ApiVersion $ApiVersion

        if ( $PSCmdlet.ShouldProcess( $ID, $resources.Description ) ) {
            $uri = New-ArmorApiUriString -Endpoints $resources.Uri.Where( { $_ -match ( '/{0}$' -f $Type ) } ) -IDs $ID

            $results = Submit-ArmorApiRequest -Uri $uri -Method $resources.Method -Description $resources.Description

            $results = Select-ArmorApiResult -Results $results -Filter $resources.Filter

            $return = $results
        }

        $return
    } # End of process

    end {
        Write-Verbose -Message ( 'Ending {0}.' -f $function )
    } # End of end
} # End of function
