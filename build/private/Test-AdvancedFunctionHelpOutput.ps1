function Test-AdvancedFunctionHelpOutput ( [String[]] $ExpectedOutputTypeNames, [PSObject] $Help ) {
    $contextName = $Global:FORM_FUNCTION_HELP -f 'Outputs'
    Context -Name $contextName -Fixture {
        #region init
        $outputTypes = $Help.ReturnValues.ReturnValue |
            ForEach-Object -Process { $_.Type.Name }
        $expectedOutputTypeCount = $ExpectedOutputTypeNames.Count
        #endregion

        $testName = "should have at least one entry"
        It -Name $testName -Test {
            ( $outputTypes | Measure-Object ).Count |
                Should -BeGreaterThan 0
        }

        $testName = "should have: '${expectedOutputTypeCount}' output types"
        It -Name $testName -Test {
            ( $outputTypes | Measure-Object ).Count |
                Should -Be $expectedOutputTypeCount
        }

        foreach ( $outputType in $outputTypes ) {
            $testName = "should have an: 'Outputs' entry for type: '${outputType}'"
            It -Name $testName -Test {
                $outputType |
                    Should -BeIn $ExpectedOutputTypeNames
            }
        }

        foreach ( $outputType in $ExpectedOutputTypeNames ) {
            $testName = "should have an: 'OutputType' entry for type: '${outputType}'"
            It -Name $testName -Test {
                $outputType |
                    Should -BeIn $outputTypes
            }
        }
    }
}
