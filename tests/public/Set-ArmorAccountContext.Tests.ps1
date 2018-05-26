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

    $splat = @{
        'ExpectedOutputTypeNames' = 'ArmorAccount'
        'Help'                    = $help
    }
    TestAdvancedFunctionHelpOutputs @splat

    $splat = @{
        'ExpectedParameterNames' = 'ID'
        'Help'                   = $help
    }
    TestAdvancedFunctionHelpParameters @splat

    $splat = @{
        'ExpectedNotes' = $Global:FunctionHelpNotes
        'Help'          = $help
        }
    TestAdvancedFunctionHelpNotes @splat

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
