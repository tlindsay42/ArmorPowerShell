function Test-AdvancedFunctionName (
    [String] $ExpectedFunctionName,
    [String] $FoundFunctionName
) {
    Context -Name 'Function Name' -Fixture {
        $testName = "should be: '${ExpectedFunctionName}'"
        It -Name $testName -Test {
            $FoundFunctionName |
                Should -BeExactly $ExpectedFunctionName
        }
    }
}
