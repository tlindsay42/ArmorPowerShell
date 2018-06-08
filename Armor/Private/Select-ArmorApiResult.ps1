function Select-ArmorApiResult {
    <#
        .SYNOPSIS
        Filters objects that has been returned from an endpoint for specific objects
        simportant to the user.

        .DESCRIPTION
        { required: more detailed description of the function's purpose }

        .INPUTS
        PSObject[]

        PSCustomObject

        .NOTES
        - Troy Lindsay
        - Twitter: @troylindsay42
        - GitHub: tlindsay42

        .EXAMPLE
        {required: show one or more examples using the function}

        .LINK
        https://armorpowershell.readthedocs.io/en/latest/index.html

        .LINK
        https://github.com/tlindsay42/ArmorPowerShell/blob/master/Armor/Private/Select-ArmorApiResult.ps1

        .LINK
        https://docs.armor.com/display/KBSS/Armor+API+Guide

        .LINK
        https://developer.armor.com/
    #>

    [CmdletBinding()]
    [OutputType( [PSCustomObject[]] )]
    [OutputType( [PSCustomObject] )]
    param (
        # Specifies the formatted API response contents.
        [Parameter(
            Position = 0,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true
        )]
        [AllowEmptyCollection()]
        [PSCustomObject[]]
        $Results = @(),

        <#
        Specifies the list of parameters that the user can use to filter response data.
        Each key is the parameter name without the "$" and each value corresponds to
        the response data's key.
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
                $filterValueName = $filter.Definition.Split( '=' )[-1]
                $filterValue = ( Get-Variable -Name $filter.Name -ErrorAction 'SilentlyContinue' ).Value.ToString()

                if ( $filterValue.Length -gt 0 ) {
                    Write-Verbose -Message "Filter match = ${filterValueName}=${filterValue}"

                    if ( $filterValueName -match '\.' ) {
                        $filterList = $filterValueName.Split( '.' )
                    }
                    else {
                        $filterList = @( $filterValueName )
                    }

                    Write-Verbose -Message ( 'Filter depth: ' + $filterList.Count )
                    switch ( $filterList.Count ) {
                        1 {
                            Write-Verbose -Message ( 'Results count pre-filter: ' + $filteredResults.Count )
                            $filteredResults = $filteredResults.Where( { $_.$filterValueName -like $filterValue } )
                            Write-Verbose -Message ( 'Results count post-filter: ' + $filteredResults.Count )
                        }

                        2 {
                            $parentFilter = $filterList[0]
                            $childFilter = $filterList[1]

                            if ( $parentFilter -eq '' -or $childFilter -eq '' ) {
                                throw "Invalid Armor API filter configuration: '${filterValue}'"
                            }

                            Write-Verbose -Message ( 'Results count pre-filter: ' + $filteredResults.Count )
                            $filteredResults = $filteredResults.Where( { $_.$parentFilter.$childFilter -like $filterValue } )
                            Write-Verbose -Message ( 'Results count post-filter: ' + $filteredResults.Count )
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
