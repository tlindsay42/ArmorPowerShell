function Test-AdvancedFunctionHelpParameter ( [String[]] $ExpectedParameterNames, [PSObject] $Help ) {
    $contextName = $Global:FORM_FUNCTION_HELP -f 'Parameters'
    Context -Name $contextName -Fixture {
        #region init
        $expectedParameterCount = $ExpectedParameterNames.Count
        #endregion

        $testName = "should have: '${expectedParameterCount}' parameters"
        It -Name $testName -Test {
            $Help.Parameters |
                Where-Object -FilterScript { ( $_ | Get-Member -Name 'Parameter' -ErrorAction 'SilentlyContinue' | Measure-Object ).Count -gt 0 } |
                Select-Object -ExpandProperty 'Parameter'Parameter |
                Measure-Object |
                Select-Object -ExpandProperty 'Count' |
                Should -Be $expectedParameterCount
        }

        foreach ( $parameterName in $ExpectedParameterNames ) {
            $testName = "should have parameter: '${parameterName}'"
            It -Name $testName -Test {
                $parameterName |
                    Should -BeIn $Help.Parameters.Parameter.Name
            }

            if ( $parameterName -notin 'WhatIf', 'Confirm' ) {
                $testName = "should have a description set for parameter: '${parameterName}'"
                It -Name $testName -Test {
                    ( $Help.Parameters.Parameter | Where-Object -FilterScript { $_.Name -eq $parameterName } ).Description.Length |
                        Should -BeGreaterThan 0
                }
            }
        }
    }
}
