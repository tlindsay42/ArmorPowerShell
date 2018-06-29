function Rename-ArmorCompleteVM {
    <#
        .SYNOPSIS
        Renames Armor Complete virtual machines.

        .DESCRIPTION
        The specified virtual machine in the Armor Complete account in context will be
        renamed.

        .INPUTS
        PSCustomObject

        .NOTES
        - Troy Lindsay
        - Twitter: @troylindsay42
        - GitHub: tlindsay42

        .EXAMPLE
        Rename-ArmorCompleteVM -ID 1 -NewName TEST-VM
        Renames the VM with ID=1 to 'TEST-VM'.

        .EXAMPLE
        [PSCustomObject] @{ ID = 1; NewName = 'TEST-VM' } | Rename-ArmorCompleteVM
        Renames the VM with ID=1 to 'TEST-VM' via property names in the pipeline.

        .LINK
        https://tlindsay42.github.io/ArmorPowerShell/public/Rename-ArmorCompleteVM/

        .LINK
        https://github.com/tlindsay42/ArmorPowerShell/blob/master/Armor/Public/Rename-ArmorCompleteVM.ps1

        .LINK
        https://docs.armor.com/display/KBSS/Update+VM+Name

        .LINK
        https://developer.armor.com/#!/Infrastructure/Vm_UpdateVm

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
        rename.
        #>
        [Parameter(
            Mandatory = $true,
            HelpMessage = 'Please enter the ID of the Armor Complete virtual machine that you want to rename',
            Position = 0,
            ValueFromPipelineByPropertyName = $true
        )]
        [ValidateRange( 1, 65535 )]
        [UInt16]
        $ID,

        # Specifies the new name for the Armor Complete virtual machine.
        [Parameter(
            Mandatory = $true,
            HelpMessage = 'Please enter the new name for the Armor Complete virtual machine',
            Position = 1,
            ValueFromPipelineByPropertyName = $true
        )]
        [ValidateNotNullOrEmpty()]
        [Alias( 'Name' )]
        [String]
        $NewName,

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
                Uri         = $uri
                Method      = $resources.Method
                Body        = $body
                SuccessCode = $resources.SuccessCode
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
