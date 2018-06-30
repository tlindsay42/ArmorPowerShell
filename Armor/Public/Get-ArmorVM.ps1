function Get-ArmorVM {
    <#
        .SYNOPSIS
        Retrieves Armor Complete and Armor Anywhere virtual machine details.

        .DESCRIPTION
        Retrieves details about the virtual machines in the Armor Anywhere or Armor
        Complete account in context.  Returns a set of virtual machines that correspond
        to the filter criteria provided by the cmdlet parameters.

        .INPUTS
        System.UInt16

        .INPUTS
        System.Guid
        
        .INPUTS
        System.String
        
        .INPUTS
        System.Management.Automation.PSObject

        .NOTES
        - Troy Lindsay
        - Twitter: @troylindsay42
        - GitHub: tlindsay42

        .EXAMPLE
        Get-ArmorVM
        Retrieves the details for all VMs in the Armor account that currently has
        context.

        .EXAMPLE
        Get-ArmorVM -ID 1
        Retrieves the details for the VM with ID=1.

        .EXAMPLE
        Get-ArmorVM -Name 'web1'
        Retrieves the details for the VM with Name='web1'.

        .EXAMPLE
        Get-ArmorVM -Name db*
        Retrieves all VMs in the Armor account that currently has context that have a
        name that starts with 'db'.

        .EXAMPLE
        1 | Get-ArmorVM
        Retrieves the details for the VM with ID=1 via pipeline value.

        .EXAMPLE
        '*secure*' | Get-ArmorVM
        Retrieves all VMs containing the word 'secure' in the name via pipeline value.

        .EXAMPLE
        [PSCustomObject] @{ ID = 1 } | Get-ArmorVM
        Retrieves the details for the VM with ID=1 via property name in the pipeline.

        .EXAMPLE
        [PSCustomObject] @{ Name = 'app1' } | Get-ArmorVM
        Retrieves the details for the VM with Name='app1' via property name in the
        pipeline.

        .LINK
        https://tlindsay42.github.io/ArmorPowerShell/public/Get-ArmorVM/

        .LINK
        https://github.com/tlindsay42/ArmorPowerShell/blob/master/Armor/Public/Get-ArmorVM.ps1

        .LINK
        https://docs.armor.com/display/KBSS/Get+VMs

        .LINK
        https://docs.armor.com/display/KBSS/Get+VM+Detail

        .LINK
        https://developer.armor.com/#!/Infrastructure/Vm_GetVmList

        .LINK
        https://developer.armor.com/#!/Infrastructure/Vm_GetVmDetail

        .COMPONENT
        Armor Complete & Armor Anywhere

        .FUNCTIONALITY
        Armor Complete & Armor Anywhere infrastructure management
    #>

    [CmdletBinding( DefaultParameterSetName = 'ID' )]
    [Alias( 'Get-ArmorCompleteVM' )]
    [OutputType( [ArmorVM[]] )]
    [OutputType( [ArmorVM] )]
    param (
        # Specifies the IDs of the virtual machines that you want to retrieve.
        [Parameter(
            ParameterSetName = 'ID',
            Position = 0,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true
        )]
        [ValidateRange( 1, 65535 )]
        [UInt16]
        $ID = 0,

        <#
        Specifies the Armor Anywhere Core Agent instance IDs of the virtual machines
        that you want to retrieve.
        #>
        [Parameter(
            ParameterSetName = 'CoreInstanceID',
            Position = 0,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true
        )]
        [ValidateScript( { $_ -ne '00000000-0000-0000-0000-000000000000' } )]
        [Guid]
        $CoreInstanceID,

        # Specifies the names of the virtual machines that you want to retrieve.
        [Parameter(
            ParameterSetName = 'Name',
            Position = 0,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true
        )]
        [AllowEmptyString()]
        [SupportsWildcards()]
        [String]
        $Name = '',

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

        if ( $PSCmdlet.ParameterSetName -eq 'ID' -and $ID -gt 0 ) {
            $uri = New-ArmorApiUri -Endpoints $resources.Endpoints[1] -IDs $ID
        }
        elseif ( $PSCmdlet.ParameterSetName -eq 'CoreInstanceID' ) {
            $uri = New-ArmorApiUri -Endpoints $resources.Endpoints[2] -IDs $CoreInstanceID
        }
        else {
            $uri = New-ArmorApiUri -Endpoints $resources.Endpoints
        }

        $keys = ( $resources.Query | Get-Member -MemberType 'NoteProperty' ).Name
        $parameters = ( Get-Command -Name $function ).Parameters.Values
        $uri = New-ArmorApiUriQuery -Keys $keys -Parameters $parameters -Uri $uri

        $splat = @{
            Uri         = $uri
            Method      = $resources.Method
            SuccessCode = $resources.SuccessCode
        }
        $results = Submit-ArmorApiRequest @splat

        $filters = $resources.Filter |
            Get-Member -MemberType 'NoteProperty'
        $results = Select-ArmorApiResult -Results $results -Filters $filters

        if ( $results.Count -eq 0 -and $PSCmdlet.ParameterSetName -eq 'Name' ) {
            Write-Error -Message "Armor VM not found: Name: '${Name}'."
        }
        else {
            $return = $results
        }

        $return
    }

    end {
        Write-Verbose -Message "Ending: '${function}'."
    }
}
