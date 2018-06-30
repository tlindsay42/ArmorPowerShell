function Submit-ArmorApiRequest {
    <#
        .SYNOPSIS
        Sends data to an Armor API endpoint and then formats the response for further
        use.

        .DESCRIPTION
        Sends HTTPS requests to a web page or web service via Invoke-WebRequest. If the
        expected HTTP response code is received, the response content is converted from
        JSON and passed to the pipeline; otherwise, the HTTP response code description
        is thrown as a terminating error.

        .INPUTS
        None
            You cannot pipe input to this cmdlet.

        .NOTES
        - Troy Lindsay
        - Twitter: @troylindsay42
        - GitHub: tlindsay42

        .EXAMPLE
        Submit-ArmorApiRequest -Uri https://api.armor.com/me -Method Get -SuccessCode 200
        Submits a GET request to the Armor Identity API endpoint during a valid
        session, converts the JSON response body to an object, passes the object to the
        pipeline, and then outputs the object.

        .EXAMPLE
        Submit-ArmorApiRequest -Uri https://api.armor.com:443/vms/1 -Headers $Global:ArmorSession.Headers -Method Post -SuccessCode 200 -Body '{"name":"app1","id":1}'
        Submits a GET request to the Armor Identity API endpoint during a valid
        session, converts the JSON response body to an object, passes the object to the
        pipeline, and then outputs the object.

        .LINK
        https://tlindsay42.github.io/ArmorPowerShell/private/Submit-ArmorApiRequest/

        .LINK
        https://github.com/tlindsay42/ArmorPowerShell/blob/master/Armor/Private/Submit-ArmorApiRequest.ps1

        .LINK
        https://docs.armor.com/display/KBSS/Armor+API+Guide

        .LINK
        https://developer.armor.com/

        .COMPONENT
        Armor API

        .FUNCTIONALITY
        Armor API request transmission
    #>

    [CmdletBinding()]
    [OutputType( [PSCustomObject[]] )]
    [OutputType( [PSCustomObject] )]
    param (
        <#
        Specifies the Uniform Resource Identifier (URI) of the Armor API resource to
        which the web request is sent.
        #>
        [Parameter(
            Mandatory = $true,
            Position = 0
        )]
        [ValidateScript( { $_ -match '^https://.+/.+$' } )]
        [String]
        $Uri,

        # Specifies the headers of the Armor API web request.
        [Parameter( Position = 1 )]
        [ValidateNotNull()]
        [Hashtable]
        $Headers = $Global:ArmorSession.Headers,

        # Specifies the action/method used for the Armor API web request.
        [Parameter(
            Mandatory = $true,
            Position = 2
        )]
        [ValidateSet( 'Delete', 'Get', 'Patch', 'Post', 'Put' )]
        [String]
        $Method = 'Get',

        <#
        Specifies the body of the Armor API request.  Ignored if the request method is
        set to Get.
        #>
        [Parameter( Position = 3 )]
        [AllowEmptyString()]
        [String]
        $Body = '',

        # Specifies the success code expected in the response.
        [Parameter(
            Mandatory = $true,
            Position = 4
        )]
        [ValidateSet( 200, 202 )]
        [UInt16]
        $SuccessCode
    )

    begin {
        $function = $MyInvocation.MyCommand.Name

        Write-Verbose -Message "Beginning: '${function}' with ParameterSetName '$( $PSCmdlet.ParameterSetName )' and Parameters: $( $PSBoundParameters | Out-String )"
    }

    process {
        [PSCustomObject[]] $return = $null
        $request = $null

        Write-Verbose -Message "Submitting the request: $( $Method.ToUpper() ) ${Uri}"

        if ( $Method -eq 'Get' ) {
            $getHeaders = $Headers.Clone()
            $getHeaders.Remove( 'Content-Type' )

            $request = Invoke-WebRequest -Uri $Uri -Headers $getHeaders -Method $Method
        }
        else {
            $request = Invoke-WebRequest -Uri $Uri -Headers $Headers -Method $Method -Body $Body
        }

        if ( $request.StatusCode -eq $SuccessCode ) {
            $return = $request.Content |
                ConvertFrom-Json
        }
        else {
            throw $request.StatusDescription
        }

        $return
    }

    end {
        Write-Verbose -Message "Ending: '${function}'."
    }
}
