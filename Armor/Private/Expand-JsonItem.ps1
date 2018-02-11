function Expand-JsonItem {
    <#
        .SYNOPSIS
        { required: high level overview }

        .DESCRIPTION
        { required: more detailed description of the function's purpose }

        .INPUTS
        System.Management.Automation.PSObject

        .NOTES
        Troy Lindsay
        Twitter: @troylindsay42
        GitHub: tlindsay42

        .EXAMPLE
        {required: show one or more examples using the function}

        .LINK
        https://github.com/tlindsay42/ArmorPowerShell

        .LINK
        https://docs.armor.com/display/KBSS/Armor+API+Guide

        .LINK
        https://developer.armor.com/
    #>

    [CmdletBinding()]
    [OutputType( [String] )]
    param (
        <#
        Specifies the deserialized JSON objects to parse recursively.
        #>
        [Parameter(
            Position = 0,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true
        )]
        [AllowNull()]
        [PSObject]
        $InputObject = $null
    )

    begin {
        #$function = $MyInvocation.MyCommand.Name

        #Write-Verbose -Message ( 'Beginning {0}.' -f $function )
    } # End of begin

    process {
        [String] $return = $null

        switch -Regex ( $InputObject.PSObject.TypeNames ) {
            'Array' {
                $return = @()

                $InputObject.ForEach( 
                    {
                        # Recurse
                        $return += $_ |
                            Expand-JsonItem
                    }
                )

                break
            }

            'Dictionary' {
                $return = New-Object -TypeName PSCustomObject

                foreach ( $jsonItemKey in ( [HashTable]$InputObject ).Keys ) {
                    if ( $InputObject[$jsonItemKey] ) {
                        # Recurse
                        $parsedItem = $InputObject.$jsonItemKey |
                            Expand-JsonItem
                    }
                    else {
                        $parsedItem = $null
                    }

                    $return |
                        Add-Member -MemberType NoteProperty -Name $jsonItemKey -Value $parsedItem
                }

                break
            }

            Default {
                $return = $InputObject
            }
        }

        $return
    } # End of process

    end {
        #Write-Verbose -Message ( 'Ending {0}.' -f $function )
    } # End of end
} # End of function
