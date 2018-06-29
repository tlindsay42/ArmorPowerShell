function Invoke-ArmorWebRequest {
    <#
        .SYNOPSIS
        Sends custom requests to Armor API endpoints.

        .DESCRIPTION
        This cmdlet sends custom HTTPS requests to the Armor API.  It can be used for
        calling API endpoints that are not yet covered by the cmdlets in this module.

        .INPUTS
        String

        PSCustomObject

        .NOTES
        - Troy Lindsay
        - Twitter: @troylindsay42
        - GitHub: tlindsay42

        .EXAMPLE
        Invoke-ArmorWebRequest -Endpoint '/me'
        Retrieves the current user's identity details.

        .EXAMPLE
        Invoke-ArmorWebRequest -Endpoint '/vms' -Headers $Global:ArmorSession.Headers
        Retrieves VM details using the session headers.

        .LINK
        https://tlindsay42.github.io/ArmorPowerShell/public/Invoke-ArmorWebRequest/

        .LINK
        https://github.com/tlindsay42/ArmorPowerShell/blob/master/Armor/Public/Invoke-ArmorWebRequest.ps1

        .LINK
        https://docs.armor.com/display/KBSS/Armor+API+Guide

        .LINK
        https://developer.armor.com/

        .COMPONENT
        Armor API

        .FUNCTIONALITY
        Armor API requests
    #>

    [CmdletBinding( SupportsShouldProcess = $true, ConfirmImpact = 'Medium' )]
    [OutputType( [PSCustomObject[]] )]
    [OutputType( [PSCustomObject] )]
    param (
        # Specifies the Armor API endpoint.
        [Parameter(
            Mandatory = $true,
            HelpMessage = 'Please enter the Armor API endpoint',
            Position = 0
        )]
        [ValidateScript( { $_ -match '^/.+$' } )]
        [String]
        $Endpoint,

        # Specifies the headers of the Armor API web request.
        [Parameter( Position = 1 )]
        [ValidateNotNull()]
        [Hashtable]
        $Headers = $Global:ArmorSession.Headers,

        <#
        Specifies the method used for the Armor API web request.  The permitted values
        are:
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
        Specifies the body of the Armor API web request.  This parameter is ignored for
        Get requests.
        #>
        [Parameter(
            Position = 3,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true
        )]
        [AllowEmptyString()]
        [String]
        $Body = '',

        <#
        Specifies the value of the HTTP response code that indicates success for this
        Armor API web request.
        #>
        [Parameter( Position = 4 )]
        [ValidateSet( 200, 202 )]
        [UInt16]
        $SuccessCode = 200,

        <#
        If the PowerShell $ConfirmPreference value is elevated for this Armor API web
        request by setting the -Confirm parameter to $true, this specifies the text to
        display at the user prompt.
        #>
        [Parameter( Position = 5 )]
        [ValidateNotNullorEmpty()]
        [String]
        $Description = 'Test Armor API request'
    )

    begin {
        $function = $MyInvocation.MyCommand.Name

        Write-Verbose -Message "Beginning: '${function}' with ParameterSetName '$( $PSCmdlet.ParameterSetName )' and Parameters: $( $PSBoundParameters | Out-String )"

        Test-ArmorSession
    }

    process {
        [PSCustomObject[]] $return = $null

        $jsonBody = $Body |
            ConvertTo-Json -ErrorAction 'Stop'

        $uri = New-ArmorApiUri -Endpoints $Endpoint

        if ( $PSCmdlet.ShouldProcess( $uri, $Description ) ) {
            $splat = @{
                'Uri'         = $uri
                'Method'      = $Method
                'Body'        = $jsonBody
                'SuccessCode' = $SuccessCode
            }
            $results = Submit-ArmorApiRequest @splat

            $return = $results
        }

        $return
    }

    end {
        Write-Verbose -Message "Ending: '${function}'."
    }
}
