function Select-ArmorApiResult {
    <#
        .SYNOPSIS
        This cmdlet is used to filter data that has been returned from an
        endpoint for specific objects important to the user.

        .DESCRIPTION
        { required: more detailed description of the function's purpose }

        .INPUTS
        System.Management.Automation.PSCustomObject[]

        .NOTES
        Troy Lindsay
        Twitter: @troylindsay42
        GitHub: tlindsay42

        .EXAMPLE
        {required: show one or more examples using the function}

        .LINK
        http://armorpowershell.readthedocs.io/en/latest/index.html

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
        Specifies the formatted API response contents.
        #>
        [Parameter(
            Position = 0,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true
        )]
        [AllowEmptyCollection()]
        [PSCustomObject[]]
        $Results = @(),

        <#
        Specifies the list of parameters that the user can use to filter
        response data.  Each key is the parameter name without the "$" and each
        value corresponds to the response data's key.
        #>
        [Parameter( Position = 1 )]
        [AllowEmptyCollection()]
        [PSCustomObject[]]
        $Filters = @()
    )

    begin {
        $function = $MyInvocation.MyCommand.Name

        Write-Verbose -Message "Beginning: '${function}'."
    } # End of begin

    process {
        [PSCustomObject[]] $return = $null

        if ( $Results.Count -eq 0 -or $Filters.Count -eq 0 ) {
            $return = $Results
        }
        else {
            $filteredResults = $Results.Clone()

            Write-Verbose -Message 'Filter the results.'

            foreach ( $filter in $Filters ) {
                $filterValue = ( Get-Variable -Name $filter -ErrorAction 'SilentlyContinue' ).Value

                if ( $filterValue -ne '' ) {
                    Write-Verbose -Message "Filter match = ${filter}=${filterValue}"

                    $filterList = $filterValue.ToString().Split( '.' )

                    switch ( $filterList.Count ) {
                        1 {
                            $filteredResults = $filteredResults.Where( { $_.$filter -like $filterValue } )
                        }
                        
                        2 {
                            $parentFilter = $filterList[0]
                            $childFilter = $filterList[1]

                            if ( $parentFilter -eq '' -or $childFilter -eq '' ) {
                                throw "Invalid Armor API filter configuration: '${filterValue}'"
                            }

                            $filteredResults = $filteredResults.Where( { $_.$parentFilter.$childFilter -like $filterValue } )
                        }

                        default {
                            throw "Unsupported Armor API filter configuration: '${filterValue}'"
                        }
                    }
                }
            }

            $return = $filteredResults
        }

        $return
    } # End of process

    end {
        Write-Verbose -Message "Ending: '${function}'."
    } # End of end
} # End of function
