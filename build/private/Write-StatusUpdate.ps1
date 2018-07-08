function Write-StatusUpdate {
    param (
        <#
        Specifies message to write to the console.
        If this is an AppVeyor build, the message will also be posted to the Message log.
        #>
        [Parameter(
            Mandatory = $true,
            Position = 0,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true
        )]
        [ValidateNotNullOrEmpty()]
        [String]
        $Message,

        # Specifies the text color in the console for the message content.
        [Parameter(
            Position = 1,
            ValueFromPipelineByPropertyName = $true
        )]
        [ValidateSet( 'DarkCyan', 'DarkGray', 'DarkMagenta', 'DarkYellow', 'Gray', 'Magenta', 'White', 'Yellow' )]
        [String]
        $MessageColor = 'White',

        # Specifies the text color in the console for the details.
        [Parameter(
            Position = 2,
            ValueFromPipelineByPropertyName = $true
        )]
        [ValidateSet( 'DarkCyan', 'DarkGray', 'DarkMagenta', 'DarkYellow', 'Gray', 'Magenta', 'White', 'Yellow' )]
        [String]
        $DetailsColor = 'DarkGray',

        # Specifies if this is an informational message, a warning, or an error.
        [Parameter(
            Position = 3,
            ValueFromPipelineByPropertyName = $true
        )]
        [ValidateSet( 'Information', 'Warning', 'Error' )]
        [String]
        $Category = 'Information',

        # Specifies the details for the message
        [Parameter(
            Position = 4,
            ValueFromPipelineByPropertyName = $true
        )]
        [AllowNull()]
        [AllowEmptyString()]
        [String]
        $Details = ''
    )

    switch ( $Category ) {
        'Information' {
            Write-Host -Object $Message -ForegroundColor $MessageColor

            if ( $Details.Length -gt 0 ) {
                Write-Host -Object $Details -ForegroundColor $DetailsColor
            }
            else {
                Write-Host
            }
        }

        'Warning' {
            Write-Warning -Message ( $Message + $Details )
        }

        'Error' {
            Write-Error -Message ( $Message + $Details )
        }
    }

    if ( $Env:APPVEYOR -eq $true -and $Env:APPVEYOR_API_URL -match 'http://localhost:\d{1,5}/' -and $TestMode -eq $false ) {
        # Post the status update to the AppVeyor job message queue
        $splat = @{
            Uri         = $Env:APPVEYOR_API_URL + 'api/build/messages'
            Method      = 'Post'
            Headers     = @{
                'Content-Type' = 'application/json'
            }
            Body        = @{
                message  = $Message
                category = $Category
                details  = $Details
            } |
                ConvertTo-Json
            ErrorAction = 'Continue'
        }
        Invoke-WebRequest @splat
    }
}
