function Submit-ArmorApiRequest {
    <#
        .SYNOPSIS
        This cmdlet sends data to an Armor API endpoint and then formats the
        response for further use.

        .DESCRIPTION
        { required: more detailed description of the function's purpose }

        .INPUTS
        None- you cannot pipe objects to this cmdlet.

        .NOTES
        Troy Lindsay
        Twitter: @troylindsay42
        GitHub: tlindsay42

        .EXAMPLE
        {required: show one or more examples using the function}

        .LINK
        http://armorpowershell.readthedocs.io/en/latest/index.html

        .LINK
        https://github.com/tlindsay42/ArmorPowerShell/blob/master/Armor/Private/Submit-ArmorApiRequest.ps1

        .LINK
        https://docs.armor.com/display/KBSS/Armor+API+Guide

        .LINK
        https://developer.armor.com/
    #>

    [CmdletBinding( SupportsShouldProcess = $true )]
    [OutputType( [PSCustomObject[]] )]
    [OutputType( [PSCustomObject] )]
    param (
        <#
        Specifies the Uniform Resource Identifier (URI) of the Armor API
        resource to which the web request is sent.
        #>
        [Parameter(
            Mandatory = $true,
            Position = 0
        )]
        [ValidateScript( { $_ -match '^https://.+/.+$' } )]
        [String]
        $Uri,

        <#
        Specifies the headers of the Armor API web request.
        #>
        [Parameter( Position = 1 )]
        [ValidateNotNull()]
        [Hashtable]
        $Headers = $Global:ArmorSession.Headers,

        <#
        Specifies the action/method used for the Armor API web request.
        #>
        [Parameter(
            Mandatory = $true,
            Position = 2
        )]
        [ValidateSet( 'Delete', 'Get', 'Patch', 'Post', 'Put' )]
        [String]
        $Method = 'Get',

        <#
        Specifies the body of the Armor API request.  Ignored if the request
        method is set to Get.
        #>
        [Parameter( Position = 3 )]
        [AllowEmptyString()]
        [String]
        $Body = '',

        <#
        Specifies the success code expected in the response.
        #>
        [Parameter(
            Mandatory = $true,
            Position = 4
        )]
        [ValidateSet( 200, 202 )]
        [UInt16]
        $SuccessCode,

        <#
        If this cmdlet is called with the -Confirm switch parameter
        set to true, this optional description will be displayed at the prompt.
        #>
        [Parameter( Position = 5 )]
        [ValidateNotNullorEmpty()]
        [String]
        $Description = ''
    )

    begin {
        $function = $MyInvocation.MyCommand.Name

        Write-Verbose -Message "Beginning: '${function}'."
    } # End of begin

    process {
        [PSCustomObject[]] $return = $null
        $request = $null

        if ( $PSCmdlet.ShouldProcess( $Uri, $Description ) ) {
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
        }

        $return
    } # End of process

    end {
        Write-Verbose -Message "Ending: '${function}'."
    } # End of end
} # End of function
