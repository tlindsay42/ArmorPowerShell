function Remove-ArmorCompleteVM {
    <#
        .SYNOPSIS
        Deletes Armor Complete VMs.

        .DESCRIPTION
        The specified VM in the Armor Complete account in context will be deleted.

        .INPUTS
        UInt16

        PSCustomObject

        .NOTES
        - Troy Lindsay
        - Twitter: @troylindsay42
        - GitHub: tlindsay42

        .EXAMPLE
        Remove-ArmorCompleteVM -ID 1
        If confirmed and empty of child objects, deletes VM with ID=1.

        .EXAMPLE
        1 | Remove-ArmorCompleteVM
        If confirmed and empty of child objects, deletes VM with ID=1 identified
        via pipeline value.

        .EXAMPLE
        [PSCustomObject] @{ 'ID' = 1 | Remove-ArmorCompleteVM
        If confirmed and empty of child objects, deletes workload with ID=1 identified
        via property name in the pipeline.

        .LINK
        https://tlindsay42.github.io/ArmorPowerShell/public/Remove-ArmorCompleteVM/

        .LINK
        https://github.com/tlindsay42/ArmorPowerShell/blob/master/Armor/Public/Remove-ArmorCompleteVM.ps1

        .LINK
        https://docs.armor.com/display/KBSS/Delete+VM

        .LINK
        https://developer.armor.com/#!/Infrastructure/Vm_DeleteVm

        .COMPONENT
        Armor Complete

        .FUNCTIONALITY
        Armor Complete infrastructure management
    #>

    [CmdletBinding( SupportsShouldProcess = $true, ConfirmImpact = 'High' )]
    [OutputType( [ArmorVM[]] )]
    [OutputType( [ArmorVM] )]
    param (
        # Specifies the ID of the Armor Complete workload.
        [Parameter(
            Mandatory = $true,
            Position = 0,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true
        )]
        [ValidateRange( 1, 65535 )]
        [Alias( 'VmID' )]
        [UInt16]
        $ID,

        <#
        Confirms that the user is aware of the current state of the Armor Complete VM.
        #>
        [Parameter(
            Position = 1,
            ValueFromPipelineByPropertyName = $true
        )]
        [ValidateNotNull()]
        [Switch]
        $IsActive = $false,

        <#
        Specifies whether the VM should be deleted now or at the end of the billing
        cycle.
        #>
        [Parameter(
            Position = 2,
            ValueFromPipelineByPropertyName = $true
        )]
        [ValidateNotNull()]
        [Switch]
        $DeleteNow = $false,

        <#
        Specifies the Armor account ID to use for all subsequent requests.  The
        permitted range is 1-65535.
        #>
        [Parameter( Position = 3 )]
        [ValidateScript( { $_ -in $Global:ArmorSession.Accounts.ID } )]
        [ValidateRange( 1, 65535 )]
        [UInt16]
        $AccountID = $Global:ArmorSession.GetAccountContext().ID,

        <#
        Specifies the username of the Armor user account.  The only accepted value is
        the current logged in username for meeting the requirements for the v1.0 API
        request body.
        #>
        [Parameter( Position = 4 )]
        [ValidateScript( { $_ -eq $Global:ArmorSession.User.UserName } )]
        [Alias( 'UserEmail' )]
        [SupportsWildcards()]
        [String]
        $UserName = $Global:ArmorSession.User.UserName,

        # Specifies the API version for this request.
        [Parameter( Position = 5 )]
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
