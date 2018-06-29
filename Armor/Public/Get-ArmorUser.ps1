function Get-ArmorUser {
    <#
        .SYNOPSIS
        Retrieves Armor user account details.

        .DESCRIPTION
        Retrieves details about the user accounts in the Armor Anywhere or Armor
        Complete account in context.  Returns a set of user accounts that correspond to
        the filter criteria provided by the cmdlet parameters.

        .INPUTS
        UInt16

        String

        PSCustomObject

        .NOTES
        - Troy Lindsay
        - Twitter: @troylindsay42
        - GitHub: tlindsay42

        .EXAMPLE
        Get-ArmorUser
        Retrieves the details for all user accounts in the Armor account that currently
        has context.

        .EXAMPLE
        Get-ArmorUser -ID 1
        Retrieves the details for all user accounts in the Armor account that currently
        has context.

        .LINK
        https://tlindsay42.github.io/ArmorPowerShell/public/Get-ArmorUser/

        .LINK
        https://github.com/tlindsay42/ArmorPowerShell/blob/master/Armor/Public/Get-ArmorUser.ps1

        .LINK
        https://docs.armor.com/display/KBSS/Get+Users

        .LINK
        https://docs.armor.com/display/KBSS/Get+User

        .LINK
        https://developer.armor.com/#!/Account_Management/Users_GetUsers

        .LINK
        https://developer.armor.com/#!/Account_Management/Users_GetUser

        .COMPONENT
        Armor API

        .FUNCTIONALITY
        Armor account management
    #>

    [CmdletBinding( DefaultParameterSetName = 'ID' )]
    [OutputType( [ArmorUser[]] )]
    [OutputType( [ArmorUser] )]
    param (
        # Specifies the ID of the Armor user account.
        [Parameter(
            ParameterSetName = 'ID',
            Position = 0,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true
        )]
        [ValidateRange( 1, 65535 )]
        [UInt16]
        $ID = 0,

        # Specifies the username of the Armor user account.
        [Parameter(
            ParameterSetName = 'UserName',
            Position = 0,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true
        )]
        [ValidateNotNullOrEmpty()]
        [SupportsWildcards()]
        [String]
        $UserName = '',

        # Specifies the first name of the Armor user account.
        [Parameter(
            ParameterSetName = 'Name',
            ValueFromPipelineByPropertyName = $true
        )]
        [ValidateNotNullOrEmpty()]
        [SupportsWildcards()]
        [String]
        $FirstName = '',

        # Specifies the last name of the Armor user account.
        [Parameter(
            ParameterSetName = 'Name',
            ValueFromPipelineByPropertyName = $true
        )]
        [ValidateNotNullOrEmpty()]
        [SupportsWildcards()]
        [String]
        $LastName = '',

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
        [ArmorUser[]] $return = $null

        $resources = Get-ArmorApiData -FunctionName $function -ApiVersion $ApiVersion

        if ( $PSCmdlet.ParameterSetName -eq 'ID' -and $ID -gt 0 ) {
            $uri = New-ArmorApiUri -Endpoints $resources.Endpoints -IDs $ID
        }
        else {
            $uri = New-ArmorApiUri -Endpoints $resources.Endpoints
        }

        $keys = ( $resources.Query | Get-Member -MemberType 'NoteProperty' ).Name
        $parameters = ( Get-Command -Name $function ).Parameters.Values
        $uri = New-ArmorApiUriQuery -Keys $keys -Parameters $parameters -Uri $uri

        $splat = @{
            'Uri'         = $uri
            'Method'      = $resources.Method
            'SuccessCode' = $resources.SuccessCode
        }
        $results = Submit-ArmorApiRequest @splat

        $filters = $resources.Filter |
            Get-Member -MemberType 'NoteProperty'
        $results = Select-ArmorApiResult -Results $results -Filters $filters

        if ( $results.Count -eq 0 ) {
            if ( $PSCmdlet.ParameterSetName -eq 'UserName' ) {
                Write-Error -Message "Armor user not found: UserName: '${UserName}'."
            }
            elseif ( $PSCmdlet.ParameterSetName -eq 'Name' ) {
                Write-Error -Message "Armor user not found: FirstName: '${FirstName}', LastName: '${LastName}'."
            }
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
