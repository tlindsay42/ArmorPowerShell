function Get-ArmorAccount {
    <#
        .SYNOPSIS
        Retrieves Armor account details.

        .DESCRIPTION
        Retrieves a list of Armor account memberships for the currently authenticated
        user.  Returns a set of accounts that correspond to the filter criteria
        provided by the cmdlet parameters.

        .INPUTS
        UInt16

        String

        PSCustomObject

        .NOTES
        - Troy Lindsay
        - Twitter: @troylindsay42
        - GitHub: tlindsay42

        .EXAMPLE
        Get-ArmorAccount
        Gets all Armor accounts assigned to the logged in user account.

        .EXAMPLE
        Get-ArmorAccount -Name *Child*
        Gets all Armor accounts assigned to the logged in user account with a name
        containing the word 'Child'.

        .EXAMPLE
        1, 'Example Child Account' | Get-ArmorAccount
        Gets the Armor accounts assigned to the logged in user account with ID=1 and
        Name='Example Child Account' via pipeline values.

        .EXAMPLE
        [PSCustomObject] @{ 'ID' = 1 } | Get-ArmorAccount
        Gets the Armor account assigned to the logged in user account with ID=1 via
        property name in the pipeline.

        .EXAMPLE
        [PSCustomObject] @{ 'Name' = 'My Secure Account' } | Get-ArmorAccount
        Gets the Armor account assigned to the logged in user account with
        Name='My Secure Account' via property name in the pipeline.

        .LINK
        https://tlindsay42.github.io/ArmorPowerShell/public/Get-ArmorAccount/

        .LINK
        https://github.com/tlindsay42/ArmorPowerShell/blob/master/Armor/Public/Get-ArmorAccount.ps1

        .LINK
        https://docs.armor.com/display/KBSS/Get+Accounts

        .LINK
        https://developer.armor.com/#!/Account_Management/Accounts_GetAccounts

        .COMPONENT
        Armor API

        .FUNCTIONALITY
        Armor account management
    #>

    [CmdletBinding( DefaultParameterSetName = 'ID' )]
    [OutputType( [ArmorAccount] )]
    [OutputType( [ArmorAccount[]] )]
    param (
        # Specifies the ID of the Armor account.
        [Parameter(
            ParameterSetName = 'ID',
            Position = 0,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true
        )]
        [ValidateRange( 1, 65535 )]
        [UInt16]
        $ID = 0,

        # Specifies the name of the Armor account.
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
        [ValidateSet( 'v1.0' )]
        [String]
        $ApiVersion = $Global:ArmorSession.ApiVersion
    )

    begin {
        $function = $MyInvocation.MyCommand.Name

        Write-Verbose -Message "Beginning: '${function}' with ParameterSetName '$( $PSCmdlet.ParameterSetName )' and Parameters: $( $PSBoundParameters | Out-String )"

        Test-ArmorSession
    } # End of begin

    process {
        [ArmorAccount[]] $return = $null

        $resources = Get-ArmorApiData -FunctionName $function -ApiVersion $ApiVersion

        $uri = New-ArmorApiUri -Endpoints $resources.Endpoints

        $keys = ( $resources.Query | Get-Member -MemberType 'NoteProperty' ).Name
        $parameters = ( Get-Command -Name $function ).Parameters.Values
        $uri = New-ArmorApiUriQuery -Keys $keys -Parameters $parameters -Uri $uri

        $splat = @{
            'Uri'         = $uri
            'Method'      = $resources.Method
            'SuccessCode' = $resources.SuccessCode
        }
        $results = Submit-ArmorApiRequest @splat

        if ( $PSCmdlet.ParameterSetName -ne 'ID' -or $ID -gt 0 ) {
            $filters = $resources.Filter |
                Get-Member -MemberType 'NoteProperty'

            if ( $PSCmdlet.ParameterSetName -ne 'ID' ) {
                $filters = $filters.Where( { $_.Name -ne 'ID' } )
            }

            $results = Select-ArmorApiResult -Results $results -Filters $filters
        }

        if ( $results.Count -eq 0 ) {
            if ( $PSCmdlet.ParameterSetName -eq 'ID' ) {
                Write-Error -Message "Armor account not found: ID: '${ID}'."
            }
            elseif ( $PSCmdlet.ParameterSetName -eq 'Name' ) {
                Write-Error -Message "Armor account not found: Name: '${Name}'."
            }
        }
        else {
            $return = $results
        }

        $return
    } # End of process

    end {
        Write-Verbose -Message "Ending: '${function}'."
    } # End of end
} # End of function
