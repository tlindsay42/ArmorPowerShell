Remove-Module -Name "${env:CI_MODULE_NAME}*" -ErrorAction 'SilentlyContinue'
Import-Module -Name $env:CI_MODULE_MANIFEST_PATH -Force

$systemUnderTest = ( Split-Path -Leaf $MyInvocation.MyCommand.Path ) -replace '\.Tests\.', '.'
$filePath = Join-Path -Path $env:CI_MODULE_PUBLIC_PATH -ChildPath $systemUnderTest

. $filePath

$privateFunctionFiles = Get-ChildItem -Path $env:CI_MODULE_PRIVATE_PATH
foreach ( $privateFunctionFile in $privateFunctionFiles ) {
    . $privateFunctionFile.FullName
}

$Global:ArmorSession = [ArmorSession]::New()
$Global:ArmorSession.Accounts += [ArmorAccount] @{
    'ID'       = 1
    'Name'     = 'Armor Defense, Inc.'
    'Currency' = 'USD'
    'Status'   = 'Claimed'
    'Parent'   = -1
    'Products' = @()
}
$Global:ArmorSession.Accounts += [ArmorAccount] @{
    'ID'       = 2
    'Name'     = 'Old Armor QA Account, Ltd'
    'Currency' = 'GBP'
    'Status'   = 'Cancelled'
    'Parent'   = 1
    'Products' = @()
}

$function = $systemUnderTest.Split( '.' )[0]
$describe = $Global:PublicFunctionForm -f $function
Describe -Name $describe -Tag 'Function', 'Public', $function -Fixture {
    #region init
    $help = Get-Help -Name $function -Full
    #endregion

    $splat = @{
        'ExpectedFunctionName' = $function
        'FoundFunctionName'    = $help.Name
        }
    TestAdvancedFunctionName @splat

    TestAdvancedFunctionHelpMain -Help $help

    TestAdvancedFunctionHelpInputs -Help $help

        $value = 'ArmorAccount'
        $testName = $Global:FunctionHelpSpecificContentForm -f 'Outputs', $value
        It -Name $testName -Test {
            $help.ReturnValues.ReturnValue.Type.Name |
                Should -BeExactly $value
        } # End of It

        $value = $Global:FunctionHelpNotes
        $testName = $Global:FunctionHelpSpecificContentForm -f 'Notes', ( $value -replace '\n', ', ' )
        It -Name $testName -Test {
            $help.AlertSet.Alert.Text |
                Should -BeExactly $value
        } # End of It

        $testName = $Global:FunctionHelpExampleEntry
        It -Name $testName -Test {
            $help.Examples.Example.Remarks.Length |
                Should -BeGreaterThan 0
        } # End of It

        $testName = $Global:FunctionHelpLinkEntry
        It -Name $testName -Test {
            $help.RelatedLinks.NavigationLink.Uri.Count |
                Should -BeGreaterThan 3
        } # End of It

        foreach ( $uri in $help.RelatedLinks.NavigationLink.Uri ) {
            $testName = $Global:FunctionHelpLinkValidForm -f $uri
            It -Name $testName -Test {
                ( Invoke-WebRequest -Method 'Get' -Uri $uri ).StatusCode |
                    Should -Be 200
            } # End of It
        }
    } # End of Context

    Context -Name 'Parameters' -Fixture {
        $value = 1
        $testName = $Global:FunctionParameterCountForm -f $value
        It -Name $testName -TestCases $testCases -Test {
            @( $help.Parameters.Parameter ).Count |
                Should -Be $value
        } # End of It

        $testCases = @(
            @{ 'Name' = 'ID' }
        )
        $testName = $Global:FunctionParameterNameForm
        It -Name $testName -TestCases $testCases -Test {
            param ( [String] $Name )
            $Name |
                Should -BeIn $help.Parameters.Parameter.Name
        } # End of It
    } # End of Context

    Context -Name 'Execution' -Fixture {
        Mock -CommandName Test-ArmorSession -Verifiable -MockWith {}

        $testName = 'should fail to set the account context'
        It -Name $testName -Test {
            { Set-ArmorAccountContext -ID 3 } |
                Should -Throw
        } # End of It

        $value = 2
        $testName = "should set the account context"
        It -Name $testName -Test {
            ( Set-ArmorAccountContext -ID $value ).ID |
                Should -Be $value
        } # End of It

        $testName = $Global:ReturnTypeForm
        It -Name $testName -Test {
            Set-ArmorAccountContext -ID 1 |
                Should -BeOfType ( [ArmorAccount] )
        } # End of It

        Assert-VerifiableMock
        Assert-MockCalled -CommandName Test-ArmorSession -Times 2
    } # End of Context
} # End of Describe
