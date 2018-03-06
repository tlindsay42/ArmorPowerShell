function Rename-ArmorCompleteVM {
    <#
        .SYNOPSIS
        This cmdlet renames Armor Complete virtual machines.

        .DESCRIPTION
        The specified virtual machine in the Armor Complete account in context
        will be renamed.

        .INPUTS
        System.UInt16

        System.String

        .NOTES
        Troy Lindsay
        Twitter: @troylindsay42
        GitHub: tlindsay42

        .EXAMPLE
        {required: show one or more examples using the function}

        .LINK
        http://armorpowershell.readthedocs.io/en/latest/cmd_rename.html#rename-armorcompletevm

        .LINK
        https://github.com/tlindsay42/ArmorPowerShell

        .LINK
        https://docs.armor.com/display/KBSS/Update+VM+Name

        .LINK
        https://developer.armor.com/#!/Infrastructure/Vm_UpdateVm
    #>

    [CmdletBinding( SupportsShouldProcess = $true, ConfirmImpact = 'High' )]
    [OutputType( [PSCustomObject[]] )]
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

        <#
        Specifies the new name for the Armor Complete virtual machine.
        #>
        [Parameter(
            Mandatory = $true,
            HelpMessage = 'Please enter the new name for the Armor Complete virtual machine',
            Position = 1,
            ValueFromPipelineByPropertyName = $true
        )]
        [ValidateNotNullOrEmpty()]
        [String]
        $Name,

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
        [PSCustomObject[]] $return = $null

        $resources = Get-ArmorApiData -Endpoint $function -ApiVersion $ApiVersion

        if ( $PSCmdlet.ShouldProcess( $ID, $resources.Description ) ) {
            $uri = New-ArmorApiUriString -Endpoints $resources.Uri -IDs $ID

            $keys = ( $resources.Body | Get-Member -MemberType 'NoteProperty' ).Name
            $parameters = ( Get-Command -Name $function ).Parameters.Values
            $body = Format-ArmorApiRequestBody -Keys $keys -Parameters $parameters

            $results = Submit-ArmorApiRequest -Uri $uri -Method $resources.Method -Body $body -Description $resources.Description
            
            $return = $results
        }

        $return
    } # End of process

    end {
        Write-Verbose -Message "Ending: '${function}'."
    } # End of end
} # End of function
