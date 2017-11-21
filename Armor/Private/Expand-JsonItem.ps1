function Expand-JsonItem {
    <#
        .SYNOPSIS
        { required: high level overview }

        .DESCRIPTION
        { required: more detailed description of the function's purpose }

        .NOTES
        Troy Lindsay
        Twitter: @troylindsay42
        GitHub: tlindsay42

        .PARAMETER InputObject
        { required: description of the specified input parameter's purpose }

        .INPUTS
        System.Management.Automation.PSObject

        .OUTPUTS
        System.String

        .LINK
        https://github.com/tlindsay42/ArmorPowerShell

        .LINK
        https://docs.armor.com/display/KBSS/Armor+API+Guide

        .LINK
        https://developer.armor.com/

        .EXAMPLE
        {required: show one or more examples using the function}
    #>

    [CmdletBinding()]
    param (
        [Parameter( Position = 0, ValueFromPipeline = $true )]
        $InputObject = $null
    )

    begin {
        #$function = $MyInvocation.MyCommand.Name

        #Write-Verbose -Message ( 'Beginning {0}.' -f $function )
    } # End of begin

    process {
        $return = $null

        switch -Regex ( $InputObject.PSObject.TypeNames ) {
            'Array' {
                $return = @()

                $InputObject.foreach( 
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

        return $return
    } # End of process

    end {
        #Write-Verbose -Message ( 'Ending {0}.' -f $function )
    } # End of end
} # End of function
