function New-ArmorCompleteVM {
    <#
        .SYNOPSIS
        Creates new Armor Complete VMs.

        .DESCRIPTION
        Orders and provisions new Armor Complete virtual machines of the specified SKU.

        .INPUTS
        System.String

        .INPUTS
        System.Management.Automation.PSObject

        .NOTES
        - Troy Lindsay
        - Twitter: @troylindsay42
        - GitHub: tlindsay42

        .EXAMPLE
        New-ArmorCompleteVM -Name 'web' -Location 'DFW01' -WorkloadName 'portal' -TierName 'presentation' -Secret $mySecurePassword -SKU 'A1-121' -Quantity 3

        .EXAMPLE
        New-ArmorCompleteVM -Name 'app' -Location 'DFW01' -WorkloadID 1 -TierID 1 -Secret $mySecurePassword -SKU 'A1-131' -Quantity 2

        .LINK
        https://tlindsay42.github.io/ArmorPowerShell/public/New-ArmorCompleteVM/

        .LINK
        https://github.com/tlindsay42/ArmorPowerShell/blob/master/Armor/Public/New-ArmorCompleteVM.ps1

        .LINK
        https://docs.armor.com/display/KBSS/Create+New+Virtual+Machine

        .LINK
        https://developer.armor.com/#!/Infrastructure/Orders_PostVmOrderAsync

        .COMPONENT
        Armor Complete

        .FUNCTIONALITY
        Armor Complete infrastructure management
    #>

    [CmdletBinding(
        SupportsShouldProcess = $true,
        ConfirmImpact = 'High',
        DefaultParameterSetName = 'ExistingWorkloadAndTier'
    )]
    [OutputType( [ArmorCompleteVmOrder[]] )]
    [OutputType( [ArmorCompleteVmOrder] )]
    param (
        # Specifies the name for the new virtual machine.
        [Parameter(
            Mandatory = $true,
            Position = 0,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true
        )]
        [ValidateNotNullOrEmpty()]
        [String]
        $Name,

        # Specifies the location code for the Armor Complete datacenter.
        [Parameter(
            Mandatory = $true,
            Position = 1,
            ValueFromPipelineByPropertyName = $true
        )]
        [ValidateSet( 'AMS01', 'DFW01', 'LHR01', 'PHX01', 'SIN01' )]
        [String]
        $Location,

        # Specifies the ID of the existing Armor Complete workload.
        [Parameter(
            ParameterSetName = 'ExistingWorkloadAndTier',
            Mandatory = $true,
            Position = 2,
            ValueFromPipelineByPropertyName = $true
        )]
        [ValidateRange( 1, 65535 )]
        [ValidateScript( { Get-ArmorCompleteWorkload -ID $_ -ErrorAction 'Stop' } )]
        [Alias( 'AppID' )]
        [UInt16]
        $WorkloadID,

        # Specifies the name for a new Armor Complete workload.
        [Parameter(
            ParameterSetName = 'NewWorkloadAndTier',
            Mandatory = $true,
            Position = 2,
            ValueFromPipelineByPropertyName = $true
        )]
        [ValidateNotNullOrEmpty()]
        [Alias( 'AppName' )]
        [String]
        $WorkloadName,

        # Specifies the ID of the existing workload tier.
        [Parameter(
            ParameterSetName = 'ExistingWorkloadAndTier',
            Mandatory = $true,
            Position = 3,
            ValueFromPipelineByPropertyName = $true
        )]
        [ValidateRange( 1, 65535 )]
        [UInt16]
        $TierID,

        # Specifies the names of the workload tiers.
        [Parameter(
            ParameterSetName = 'NewWorkloadAndTier',
            Mandatory = $true,
            Position = 3,
            ValueFromPipelineByPropertyName = $true
        )]
        [ValidateNotNullOrEmpty()]
        [String]
        $TierName,

        # Specifies the virtual disks that should be added to the new VM.
        [Parameter(
            Position = 4,
            ValueFromPipelineByPropertyName = $true
        )]
        [AllowEmptyCollection()]
        [ValidateCount( 0, 60 )]
        [Alias( 'Storage' )]
        [ArmorDisk[]]
        $VirtualDisks = @(),

        # Specifies the password for the new VM.
        [Parameter(
            Mandatory = $true,
            Position = 5,
            ValueFromPipelineByPropertyName = $true
        )]
        [ValidateLength( 16, 128 )]
        [String]
        $Secret,

        <#
        Specifies the stock keeping unit (SKU) product identification code that
        includes the CPU & memory specifications.
        #>
        [Parameter(
            Mandatory = $true,
            Position = 6,
            ValueFromPipelineByPropertyName = $true
        )]
        [ValidateNotNullOrEmpty()]
        [String]
        $SKU,

        # Specifies the quantity of VMs to order of this specification.
        [Parameter(
            Position = 7,
            ValueFromPipelineByPropertyName = $true
        )]
        [ValidateRange( 1, 20 )]
        [UInt16]
        $Quantity = 1,

        # Specifies the API version for this request.
        [Parameter( Position = 8 )]
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
        [ArmorCompleteVmOrder[]] $return = $null

        if ( $PSCmdlet.ParameterSetName -eq 'ExistingWorkloadAndTier' ) {
            # The GET /apps/{id}/tiers/{id} endpoint does not return objects that contain no VMs. ( #122 )
            if ( ( Get-ArmorCompleteWorkload -ID $WorkloadID ).Tiers.Where( { $_.ID -eq $TierID } ).Count -ne 1 ) {
                Write-Error -Message "Cannot validate argument on parameter 'TierID': '${TierID}'" -ErrorAction 'Stop'
            }
        }

        $resources = Get-ArmorApiData -FunctionName $function -ApiVersion $ApiVersion

        $uri = New-ArmorApiUri -Endpoints $resources.Endpoints

        $plural = if ( $Quantity -gt 1 ) { 's' }
        $description = $resources.description -f $Quantity, $plural

        if ( $PSCmdlet.ShouldProcess( $SKU, $description ) ) {
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

            $filters = $resources.Filter |
                Get-Member -MemberType 'NoteProperty'
            $results = Select-ArmorApiResult -Results $results -Filter $filters

            $return = $results
        }

        # Pass the return value to the pipeline
        $return
    }

    end {
        Write-Verbose -Message "Ending: '${function}'."
    }
}
