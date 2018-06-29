function Rename-ArmorCompleteWorkloadTier {
    <#
        .SYNOPSIS
        Renames Armor Complete workload tiers.

        .DESCRIPTION
        The specified workload tier in the Armor Complete account in context will be
        renamed.

        .INPUTS
        PSCustomObject

        .NOTES
        - Troy Lindsay
        - Twitter: @troylindsay42
        - GitHub: tlindsay42

        .EXAMPLE
        Rename-ArmorCompleteWorkloadTier -ID 1 -NewName TEST-TIER
        Renames the workload tier with ID=1 to 'TEST-TIER'.

        .EXAMPLE
        [PSCustomObject] @{ 'ID' = 1; 'NewName' = 'TEST-TIER' } | Rename-ArmorCompleteWorkloadTier
        Renames the workload tier with ID=1 to 'TEST-WORKLOAD' via property names in the
        pipeline.

        .LINK
        https://tlindsay42.github.io/ArmorPowerShell/public/Rename-ArmorCompleteWorkloadTier/

        .LINK
        https://github.com/tlindsay42/ArmorPowerShell/blob/master/Armor/Public/Rename-ArmorCompleteWorkloadTier.ps1

        .LINK
        https://docs.armor.com/display/KBSS/Update+Tier

        .LINK
        https://developer.armor.com/#!/Infrastructure/

        .COMPONENT
        Armor Complete

        .FUNCTIONALITY
        Armor Complete infrastructure management
    #>

    [CmdletBinding( SupportsShouldProcess = $true, ConfirmImpact = 'High' )]
    [OutputType( [ArmorCompleteWorkloadTier[]] )]
    [OutputType( [ArmorCompleteWorkloadTier] )]
    param (
        # Specifies the ID of the Armor Complete workload that contains the tier that you want to rename.
        [Parameter(
            Mandatory = $true,
            HelpMessage = 'Please enter the ID of the Armor Complete workload that contains the tier that you want to rename',
            Position = 0,
            ValueFromPipelineByPropertyName = $true
        )]
        [ValidateRange( 1, 65535 )]
        [UInt16]
        $WorkloadID,

        # Specifies the ID of the workload tier to rename.
        [Parameter(
            Mandatory = $true,
            HelpMessage = 'Please enter the ID of the Armor Complete workload tier to rename',
            ParameterSetName = 'ID',
            Position = 1,
            ValueFromPipelineByPropertyName = $true
        )]
        [ValidateRange( 1, 65535 )]
        [UInt16]
        $ID,

        # Specifies the new name of the Armor Complete workload tier.
        [Parameter(
            Mandatory = $true,
            HelpMessage = 'Please enter the new name for the Armor Complete workload tier',
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
        [ArmorCompleteWorkloadTier[]] $return = $null

        $resources = Get-ArmorApiData -FunctionName $function -ApiVersion $ApiVersion

        if ( $PSCmdlet.ShouldProcess( $ID, $resources.Description ) ) {
            $uri = New-ArmorApiUri -Endpoints $resources.Endpoints -IDs $WorkloadID, $ID

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

            $results = Expand-ArmorApiResult -Results $results -Location $resources.Location

            $filters = $resources.Filter |
                Get-Member -MemberType 'NoteProperty'
            $results = Select-ArmorApiResult -Results $results -Filter $filters

            $return = $results
        }

        $return
    }

    end {
        Write-Verbose -Message "Ending: '${function}'."
    }
}
