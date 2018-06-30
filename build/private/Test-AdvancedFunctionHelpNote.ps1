function Test-AdvancedFunctionHelpNote ( [String] $ExpectedNotes, [PSObject] $Help ) {
    $contextName = $Global:FORM_FUNCTION_HELP -f 'Notes'
    Context -Name $contextName -Fixture {
        $inlineNotes = $ExpectedNotes -replace '\n', ', '
        $testName = "should have set: 'Notes' to: '${inlineNotes}'"
        It -Name $testName -Test {
            $Help.AlertSet.Alert.Text |
                Should -BeExactly $ExpectedNotes
        }
    }
}
