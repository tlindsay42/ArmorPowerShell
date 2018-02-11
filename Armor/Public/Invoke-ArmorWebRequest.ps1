function Invoke-ArmorWebRequest {
    <#
        .SYNOPSIS
        This cmdlet submits web requests to the Armor API.

        .DESCRIPTION
        This cmdlet sends custom HTTPS requests to the Armor API.  It can
        be used for calling API endpoints that are not yet covered by the
        cmdlets in this module.

        .INPUTS
        System.String

        .NOTES
        Troy Lindsay
        Twitter: @troylindsay42
        GitHub: @tlindsay42

        .EXAMPLE
        {required: show one or more examples using the function}

        .LINK
        http://armorpowershell.readthedocs.io/en/latest/cmd_invoke.html#invoke-armorwebrequest

        .LINK
        https://github.com/tlindsay42/ArmorPowerShell

        .LINK
        https://docs.armor.com/display/KBSS/Armor+API+Guide

        .LINK
        https://developer.armor.com/
    #>

    [CmdletBinding()]
    [OutputType( [PSCustomObject[]] )]
    param (
        <#
        Specifies the Armor API endpoint.
        #>
        [Parameter(
            Mandatory = $true,
            HelpMessage = 'Please enter the Armor API endpoint',
            Position = 0
        )]
        [ValidateScript( { $_ -match '^/.+$' } )]
        [String]
        $Endpoint,

        <#
        Specifies the headers of the Armor API web request.
        #>
        [Parameter( Position = 1 )]
        [ValidateNotNull()]
        [Hashtable]
        $Headers = $Global:ArmorSession.Headers,

        <#
        Specifies the method used for the Armor API web request.  The permitted
        values are:
        - Delete
        - Get
        - Patch
        - Post
        - Put
        #>
        [Parameter( Position = 2 )]
        [ValidateSet( 'Delete', 'Get', 'Patch', 'Post', 'Put' )]
        [String]
        $Method = 'Get',

        <#
        Specifies the body of the Armor API web request.  This parameter is
        ignored for Get requests.
        #>
        [Parameter(
            Position = 3,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true
        )]
        [String]
        $Body = '',

        <#
        Specifies the value of the HTTP response code that indicates success
        for this Armor API web request.
        #>
        [Parameter( Position = 4 )]
        [ValidateSet( 200 )]
        [UInt16]
        $SuccessCode = 200,

        <#
        If the PowerShell $ConfirmPreference value is elevated for this Armor
        API web request by setting the -Confirm parameter to $true, this
        specifies the text to display at the user prompt.
        #>
        [Parameter( Position = 5 )]
        [ValidateNotNullorEmpty()]
        [String]
        $Description = 'Test Armor API request'
    )

    begin {
        $function = $MyInvocation.MyCommand.Name

        Write-Verbose -Message ( 'Beginning {0}.' -f $function )

        Test-ArmorSession
    } # End of begin

    process {
        [PSCustomObject[]] $return = $null

        $jsonBody = $Body |
            ConvertTo-Json -ErrorAction 'Stop'

        $uri = New-ArmorApiUriString -Endpoints $Endpoint

        $results = Submit-ArmorApiRequest -Uri $uri -Method $Method -Body $jsonBody -SuccessCode $SuccessCode -Description $Description

        $return = $results

        $return
    } # End of process

    end {
        Write-Verbose -Message ( 'Ending {0}.' -f $function )
    } # End of end
} # End of function
