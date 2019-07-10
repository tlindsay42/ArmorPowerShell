function Hide-SensitiveData {
    <#
    .SYNOPSIS
        Redact sensitive property values.

    .DESCRIPTION
        Redact sensitive property values and then return objects to the pipeline.

    .INPUTS
        System.Object[]

    .INPUTS
        System.Object

    .NOTES
        - Troy Lindsay
        - Twitter: @troylindsay42
        - GitHub: tlindsay42

    .EXAMPLE
        Hide-SensitiveData -InputObject [PSCustomObject] @{ Credential = ( Get-Credential )) }
        Returns the input object with the value of the Credential key set to
        '[REDACTED]'.

    .EXAMPLE
        [PSCustomObject] @{ PlainText = 'do not display' } | Hide-SensitiveData -SensitiveProperties 'PlainText'
        Returns the object input via the pipeline with the value of the 'PlainText' key
        set to '[REDACTED]', because the SensitiveProperties parameter specified this
        key as sensitive.

    .EXAMPLE
        Hide-SensitiveData -InputObject [PSCustomObject] @{ Authorization = $authorization } -ForceVerbose
        Returns the input object with the value of the Authorization key intact.

    .EXAMPLE
        Hide-SensitiveData [PSCustomObject] @{ Authorization = $authorization }
        Uses a positional parameter Returns the hashtable with the Uri value set to '[REDACTED]'.

    .LINK
        https://tlindsay42.github.io/ArmorPowerShell/Private/Hide-SensitiveData/

    .LINK
        https://github.com/tlindsay42/ArmorPowerShell/blob/master/Armor/Private/Hide-SensitiveData.ps1

    .FUNCTIONALITY
        PowerShell Language
    #>
    [CmdletBinding(
        HelpUri = 'https://tlindsay42.github.io/ArmorPowerShell/Private/Hide-SensitiveData/'
    )]
    [OutputType( [Object[]] )]
    [OutputType( [Object] )]
    [OutputType( [Hashtable] )]
    param (
        # Specifies the objects to evaluate for sensitive property keys.
        [Parameter(
            Mandatory = $true,
            Position = 0,
            ValueFromPipeline = $true
        )]
        [AllowNull()]
        [Hashtable]
        $InputObject,

        # Specifies the properties that should be redacted.
        [Parameter( Position = 1 )]
        [ValidateNotNullOrEmpty()]
        [String[]]
        $SensitiveProperties = @(
            'Credential',
            'Authorization',
            'Token'
        ),

        <#
        Prevents sensitive property values from being redacted for troubleshooting
        purposes.

        *** WARNING ***
        This will expose your sensitive property values.
        #>
        [Parameter( Position = 2 )]
        [Switch]
        $ForceVerbose = $false
    )

    begin {
        $function = $MyInvocation.MyCommand.Name
        Write-Verbose -Message "Beginning: '${function}'."
    }

    process {
        Write-Verbose -Message (
            "Processing: '${function}' with ParameterSetName '$( $PSCmdlet.ParameterSetName )' and Parameters: " +
            ( $PSBoundParameters | Format-Table -AutoSize | Out-String )
        )

        if ( $ForceVerbose -eq $true ) {
            $InputObject
        }
        else {
            if (
                $InputObject -is [Hashtable] -or
                ( $InputObject.Keys.Count -gt 0 -and $InputObject.Values.Count -gt 0 )
            ) {
                $return = [Hashtable] $( $InputObject.PSObject.Copy() )
                foreach ( $sensitiveProperty in $SensitiveProperties ) {
                    if ( $InputObject.ContainsKey( $sensitiveProperty ) ) {
                        $return[$sensitiveProperty] = '[REDACTED]'
                    }
                }
                $return
            }
            else {
                $InputObject |
                    Select-Object -Property '*' -ExcludeProperty $SensitiveProperties
            }
        }
    }

    end {
        Write-Verbose -Message "Ending: '${function}'."
    }
}
