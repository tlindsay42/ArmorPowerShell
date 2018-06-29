function Restart-ArmorCompleteVM {
    <#
        .SYNOPSIS
        Reboots Armor Complete virtual machines gracefully.

        .DESCRIPTION
        The specified virtual machine will be gracefully rebooted in the Armor Complete
        account in context.  VMware Tools or open-vm-tools must be installed and
        running for this request to succeed.

        See also: Reset-ArmorCompleteVM

        .INPUTS
        UInt16

        PSCustomObject

        .NOTES
        - Troy Lindsay
        - Twitter: @troylindsay42
        - GitHub: tlindsay42

        .EXAMPLE
        Retart-ArmorCompleteVM -ID 1
        Gracefully reboot on the specified Armor Complete VM.

        .EXAMPLE
        1 | Retart-ArmorCompleteVM
        Reboot the Armor Complete VM with ID=1 specified via pipeline value.

        .EXAMPLE
        Get-ArmorVM -ID 1 | Retart-ArmorCompleteVM
        Reboot the Armor Complete VM with ID=1 via property name in the pipeline.

        .LINK
        https://tlindsay42.github.io/ArmorPowerShell/public/Restart-ArmorCompleteVM/

        .LINK
        https://github.com/tlindsay42/ArmorPowerShell/blob/master/Armor/Public/Restart-ArmorCompleteVM.ps1

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
        <#
        Specifies the ID of the Armor Complete virtual machine that you want to
        gracefully reboot.
        #>
        [Parameter(
            Mandatory = $true,
            HelpMessage = 'Please enter the ID of the Armor Complete virtual machine that you want to gracefully reboot',
            Position = 0,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true
        )]
        [ValidateRange( 1, 65535 )]
        [UInt16]
        $ID,

        # Specifies the API version for this request.
        [Parameter( Position = 1 )]
        [ValidateSet( 'v1.0', 'internal' )]
        [String]
        $ApiVersion = $Global:ArmorSession.ApiVersion
    )

    begin {
        $function = $MyInvocation.MyCommand.Name

        Write-Verbose -Message "Beginning: '${function}' with ParameterSetName '$( $PSCmdlet.ParameterSetName )' and Parameters: $( $PSBoundParameters | Out-String )"

        Test-ArmorSession
    }

    process {
        [ArmorVM[]] $return = $null

        $resources = Get-ArmorApiData -FunctionName $function -ApiVersion $ApiVersion

        if ( $PSCmdlet.ShouldProcess( $ID, $resources.Description ) ) {
            $uri = New-ArmorApiUri -Endpoints $resources.Endpoints -IDs $ID

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
    }

    end {
        Write-Verbose -Message "Ending: '${function}'."
    }
}
