function Get-ArmorAccount {
    <#
        .SYNOPSIS
        This cmdlet retrieves Armor account details.

        .DESCRIPTION
        This cmdlet retrieves a list of Armor account memberships for the
        currently authenticated user.  Returns a set of accounts that
        correspond to the filter criteria provided by the cmdlet parameters.

        .INPUTS
        System.UInt16

        System.String

        .NOTES
        Troy Lindsay
        Twitter: @troylindsay42
        GitHub: tlindsay42

        .EXAMPLE
        Get-ArmorAccount

        ID       : 65536
        Name     : Example Parent Account
        Currency : USD
        Status   : Claimed
        Parent   : -1
        Products : {@{AA-CORE=System.Object[]; ARMOR-COMPLETE=System.Object[]}}

        ID       : 65537
        Name     : Example Child Account
        Currency : GBP
        Status   : Claimed
        Parent   : 65536
        Products : {@{AA-CORE=System.Object[]}}


        Description
        -----------
        Gets all Armor accounts assigned to the logged in user account.

        .EXAMPLE
        Get-ArmorAccount -Name *Child*

        ID       : 65537
        Name     : Example Child Account
        Currency : GBP
        Status   : Claimed
        Parent   : 65536
        Products : {@{AA-CORE=System.Object[]}}


        Description
        -----------
        Gets all Armor accounts assigned to the logged in user account with a
        name containing the word 'Child'.

        .EXAMPLE
        65536, 'Example Child Account' | Get-ArmorAccount

        ID       : 65536
        Name     : Example Parent Account
        Currency : USD
        Status   : Claimed
        Parent   : -1
        Products : {@{AA-CORE=System.Object[]; ARMOR-COMPLETE=System.Object[]}}

        ID       : 65537
        Name     : Example Child Account
        Currency : GBP
        Status   : Claimed
        Parent   : 65536
        Products : {@{AA-CORE=System.Object[]}}


        Description
        -----------
        Gets the Armor accounts assigned to the logged in user account with
        ID=65536 and Name='Example Child Account'.

        .LINK
        http://armorpowershell.readthedocs.io/en/latest/cmd_get.html#get-armoraccount

        .LINK
        https://github.com/tlindsay42/ArmorPowerShell

        .LINK
        https://docs.armor.com/display/KBSS/Get+Accounts

        .LINK
        https://developer.armor.com/#!/Account_Management/Accounts_GetAccounts
    #>

    [CmdletBinding( DefaultParameterSetName = 'ID' )]
    [OutputType( [ArmorAccount[]] )]
    param (
        <#
        Specifies the ID of the Armor account.
        #>
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
        Specifies the name of the Armor account.  Wildcard searches are permitted.
        #>
        [Parameter(
            ParameterSetName = 'Name',
            Position = 0,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true
        )]
        [AllowEmptyString()]
        [String]
        $Name = '',

        <#
        Specifies the API version for this request.
        #>
        [Parameter( Position = 1 )]
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
        [ArmorAccount[]] $return = $null

        $resources = Get-ArmorApiData -FunctionName $function -ApiVersion $ApiVersion

        $uri = New-ArmorApiUri -Endpoints $resources.Endpoints

        $keys = ( $resources.Query | Get-Member -MemberType 'NoteProperty' ).Name
        $parameters = ( Get-Command -Name $function ).Parameters.Values
        $uri = New-ArmorApiUriQuery -Keys $keys -Parameters $parameters -Uri $uri

        $results = Submit-ArmorApiRequest -Uri $uri -Method $resources.Method -Description $resources.Description

        $filters = ( $resources.Filter | Get-Member -MemberType 'NoteProperty' ).Name
        $results = Select-ArmorApiResult -Results $results -Filters $filters

        if ( $results.Count -eq 0 ) {
            Write-Host -Object 'Armor account not found.'
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
