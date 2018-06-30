function Select-ArmorApiResult {
    <#
        .SYNOPSIS
        Criteria-based object filtering.

        .DESCRIPTION
        Filters objects returned from an Armor API endpoint for result object
        property values matching parameter values.

        Wildcard filtering is supported via the use of the `-like` operator.

        .INPUTS
        System.Management.Automation.PSObject[]

        .INPUTS
        System.Management.Automation.PSObject

        .NOTES
        - Troy Lindsay
        - Twitter: @troylindsay42
        - GitHub: tlindsay42

        .EXAMPLE
        $results = Submit-ArmorApiRequest -Uri 'https://api.armor.com/vms'; $filters = $resources.Filter | Get-Member -MemberType 'NoteProperty'; $results = Select-ArmorApiResult -Results $results -Filters $filters
        Sets $results to the VMs matching the parameters defined in the calling cmdlet:
        `Get-ArmorVM`, such as 'Name'='TEST-VM'.

        There are no available use cases for the bi-level filter yet, but one example
        is to define a filter key in ApiData.json such as `"SKU": "Product.SKU"`,
        and then define a $SKU parameter for `Get-ArmorVM`, so that you could then
        filter for VMs by SKU via the `Get-ArmorVM` cmdlet.

        .LINK
        https://tlindsay42.github.io/ArmorPowerShell/private/Select-ArmorApiResult/

        .LINK
        https://github.com/tlindsay42/ArmorPowerShell/blob/master/Armor/Private/Select-ArmorApiResult.ps1

        .LINK
        https://docs.armor.com/display/KBSS/Armor+API+Guide

        .LINK
        https://developer.armor.com/

        .COMPONENT
        Armor API

        .FUNCTIONALITY
        Armor API client-side response filtering
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

        If a '.' is included in the key name, the filter key name will be split so that
        the first part of the filter key will be applied to a root-level property in
        the result object, and the second part will be applied to a child property
        within the parent property.
        #>
        [Parameter( Position = 1 )]
        [AllowEmptyCollection()]
        [PSCustomObject[]]
        $Filters = @()
    )

    begin {
        $function = $MyInvocation.MyCommand.Name

        Write-Verbose -Message "Beginning: '${function}' with ParameterSetName '$( $PSCmdlet.ParameterSetName )' and Parameters: $( $PSBoundParameters | Out-String )"
    }

    process {
        [PSCustomObject[]] $return = $null

        if ( ( $Results | Measure-Object ).Count -eq 0 -or ( $Filters | Measure-Object ).Count -eq 0 ) {
            $return = $Results
        }
        else {
            $filteredResults = $Results.Clone()
            $filteredResultsCount = ( $filteredResults | Measure-Object ).Count

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

                    $filterListCount = ( $filterList | Measure-Object ).Count

                    Write-Verbose -Message "Filter depth: '${filterListCount}'"
                    switch ( $filterListCount ) {
                        1 {
                            Write-Verbose -Message "Results count pre-filter: '${filteredResultsCount}'"
                            $filteredResults = $filteredResults |
                                Where-Object -FilterScript { $_  | Get-Member -Name $filterValueName -ErrorAction 'SilentlyContinue' } |
                                Where-Object -FilterScript { $_.$filterValueName -like $filterValue }
                            $filteredResultsCount = ( $filteredResults | Measure-Object ).Count
                            Write-Verbose -Message "Results count post-filter: '${filteredResultsCount}'"
                        }

                        2 {
                            $parentFilter = $filterList[0]
                            $childFilter = $filterList[1]

                            if ( $parentFilter -eq '' -or $childFilter -eq '' ) {
                                throw "Invalid Armor API filter configuration: '${filterValue}'"
                            }

                            Write-Verbose -Message "Results count pre-filter: '${filteredResultsCount}'"

                            $filteredResults = $filteredResults |
                                Where-Object -FilterScript { $_ | Get-Member -Name $parentFilter -ErrorAction 'SilentlyContinue' } |
                                Where-Object -FilterScript { $_.$parentFilter | Get-Member -Name $childFilter -ErrorAction 'SilentlyContinue' } |
                                Where-Object -FilterScript { $_.$parentFilter.$childFilter -like $filterValue }
                            $filteredResultsCount = ( $filteredResults | Measure-Object ).Count
                            Write-Verbose -Message "Results count post-filter: '${filteredResultsCount}'"
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
    }

    end {
        Write-Verbose -Message "Ending: '${function}'."
    }
}
