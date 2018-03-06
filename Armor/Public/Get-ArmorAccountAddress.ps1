function Get-ArmorAccountAddress {
    <#
        .SYNOPSIS
        This cmdlet retrieves the address on file for Armor accounts.

        .DESCRIPTION
        This cmdlet retrieves the address on file for Armor accounts that your
        user account has access to.

        .INPUTS
        System.UInt16

        .NOTES
        Troy Lindsay
        Twitter: @troylindsay42
        GitHub: tlindsay42

        .EXAMPLE
        Get-ArmorAccountAddress

        AccountID    : 65536
        Name         : Example Parent Account
        AddressLine1 : 2360 Campbell Creek Blvd.
        AddressLine2 : Suite 525 
        City         : Richardson
        State        : TX
        PostalCode   : 75082
        Country      : US


        Description
        -----------
        Gets the address of the Armor account currently in context.

        .EXAMPLE
        Get-ArmorAccountAddress -ID 65537

        AccountID    : 65537
        Name         : Example Child Account
        AddressLine1 : 2360 Campbell Creek Blvd.
        AddressLine2 : Suite 525 
        City         : Richardson
        State        : TX
        PostalCode   : 75082
        Country      : US


        Description
        -----------
        Gets the address of Armor account ID 65537.

        .EXAMPLE
        65536 | Get-ArmorAccountAddress

        AccountID    : 65536
        Name         : Example Parent Account
        AddressLine1 : 2360 Campbell Creek Blvd.
        AddressLine2 : Suite 525 
        City         : Richardson
        State        : TX
        PostalCode   : 75082
        Country      : US


        Description
        -----------
        Gets the address of Armor account ID 65536.

        .LINK
        http://armorpowershell.readthedocs.io/en/latest/cmd_get.html#get-armoraccountaddress

        .LINK
        https://github.com/tlindsay42/ArmorPowerShell

        .LINK
        https://docs.armor.com/display/KBSS/Get+Account

        .LINK
        https://developer.armor.com/#!/Account_Management/Accounts_GetAccount
    #>

    [CmdletBinding()]
    [OutputType( [ArmorAccountAddress] )]
    param (
        <#
        Specifies the ID of the Armor account with the desired address details.
        #>
        [Parameter(
            Position = 0,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true
        )]
        [ValidateRange( 1, 65535 )]
        [UInt16]
        $ID = $Global:ArmorSession.GetAccountContextID(),

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

        $results = Submit-ArmorApiRequest -Uri $uri -Headers $headers -Method $resources.Method -Description $resources.Description

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
