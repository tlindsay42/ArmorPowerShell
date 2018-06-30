function Get-ArmorAccountAddress {
    <#
        .SYNOPSIS
        Retrieves the mailing address on file for Armor accounts.

        .DESCRIPTION
        This cmdlet retrieves the mailing address on file for Armor accounts that your
        user account has access to.

        .INPUTS
        System.UInt16

        .INPUTS
        System.Management.Automation.PSObject

        .NOTES
        - Troy Lindsay
        - Twitter: @troylindsay42
        - GitHub: tlindsay42

        .EXAMPLE
        Get-ArmorAccountAddress
        Retrieves the mailing address of the Armor account currently in context.

        .EXAMPLE
        Get-ArmorAccountAddress -ID 1
        Retrieves the mailing address of the Armor account with ID 1.

        .EXAMPLE
        1, 2 | Get-ArmorAccountAddress
        Retrieves the mailing address of the Armor accounts with ID=1 and ID=2 via
        pipeline values.

        .EXAMPLE
        [PSCustomObject] @{ ID = 1 } | Get-ArmorAccountAddress
        Retrieves the mailing address of the Armor account with ID=1 and ID=2 via
        property names in the pipeline.

        .LINK
        https://tlindsay42.github.io/ArmorPowerShell/public/Get-ArmorAccountAddress/

        .LINK
        https://github.com/tlindsay42/ArmorPowerShell/blob/master/Armor/Public/Get-ArmorAccountAddress.ps1

        .LINK
        https://docs.armor.com/display/KBSS/Get+Account

        .LINK
        https://developer.armor.com/#!/Account_Management/Accounts_GetAccount

        .COMPONENT
        Armor API

        .FUNCTIONALITY
        Armor account management
    #>

    [CmdletBinding()]
    [OutputType( [ArmorAccountAddress] )]
    param (
        # Specifies the ID of the Armor account with the desired address details.
        [Parameter(
            Position = 0,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true
        )]
        [ValidateRange( 1, 65535 )]
        [UInt16]
        $ID = $Global:ArmorSession.GetAccountContextID(),

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
        [ArmorAccountAddress] $return = $null
        $headers = $Global:ArmorSession.Headers.Clone()
        $headers.( $Global:ArmorSession.AccountContextHeader ) = $ID

        $resources = Get-ArmorApiData -FunctionName $function -ApiVersion $ApiVersion

        $uri = New-ArmorApiUri -Endpoints $resources.Endpoints -IDs $ID

        if ( $ID -gt 0 ) {
            Write-Verbose 'Implementing workaround for specific account query bug.'
        }

        $keys = ( $resources.Query | Get-Member -MemberType 'NoteProperty' ).Name
        $parameters = ( Get-Command -Name $function ).Parameters.Values
        $uri = New-ArmorApiUriQuery -Keys $keys -Parameters $parameters -Uri $uri

        $splat = @{
            Uri         = $uri
            Headers     = $headers
            Method      = $resources.Method
            SuccessCode = $resources.SuccessCode
        }
        $results = Submit-ArmorApiRequest @splat

        $return = $results

        $return
    }

    end {
        Write-Verbose -Message "Ending: '${function}'."
    }
}
