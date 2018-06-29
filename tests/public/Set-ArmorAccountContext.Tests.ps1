Import-Module -Name $Env:CI_MODULE_MANIFEST_PATH -Force

$systemUnderTest = ( Split-Path -Leaf $MyInvocation.MyCommand.Path ) -replace '\.Tests\.', '.'

$function = $systemUnderTest.Split( '.' )[0]
$describe = $Global:PublicFunctionForm -f $function
Describe -Name $describe -Tag 'Function', 'Public', $function -Fixture {
    #region init
    $help = Get-Help -Name $function -Full

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

    Context -Name $Global:Execution -Fixture {
        InModuleScope -ModuleName $Env:CI_MODULE_NAME -ScriptBlock {
            #region init
            $invalidID = 0
            #endregion

            $testCases = @(
                @{ 'ID' = $invalidID }
            )
            $testName = 'should fail when set to: ID: <ID>'
            It -Name $testName -TestCases $testCases -Test {
                param ( [String] $ID )
                { Set-ArmorAccountContext -ID $ID } |
                    Should -Throw
            }

            Mock -CommandName Test-ArmorSession -Verifiable -MockWith {}

            $testCases = @(
                @{ 'ID' = $Global:ArmorSession.Accounts[0].ID },
                @{ 'ID' = $Global:ArmorSession.Accounts[1].ID }
            )
            $testName = 'should not fail when set to: ID: <ID>'
            It -Name $testName -TestCases $testCases -Test {
                param ( [String] $ID )
                ( Set-ArmorAccountContext -ID $ID ).ID |
                    Should -Be $ID
            }
            Assert-VerifiableMock
            Assert-MockCalled -CommandName Test-ArmorSession -Times $testCases.Count
        }
    }

    Context -Name $Global:ReturnTypeContext -Fixture {
        InModuleScope -ModuleName $Env:CI_MODULE_NAME -ScriptBlock {
            Mock -CommandName Test-ArmorSession -Verifiable -MockWith {}

            $testCases = @(
                @{
                    'FoundReturnType'    = ( Set-ArmorAccountContext -ID 1 -ErrorAction 'Stop' ).GetType().FullName
                    'ExpectedReturnType' = 'ArmorAccount'
                }
            )
            $testName = $Global:ReturnTypeForm
            It -Name $testName -TestCases $testCases -Test {
                param ( [String] $FoundReturnType, [String] $ExpectedReturnType )
                $FoundReturnType |
                    Should -Be $ExpectedReturnType
            }
            Assert-VerifiableMock
            Assert-MockCalled -CommandName Test-ArmorSession -Times $testCases.Count

            $testName = "has an 'OutputType' entry for <FoundReturnType>"
            It -Name $testName -TestCases $testCases -Test {
                param ( [String] $FoundReturnType, [String] $ExpectedReturnType )
                $FoundReturnType |
                    Should -BeIn ( Get-Help -Name 'Set-ArmorAccountContext' -Full ).ReturnValues.ReturnValue.Type.Name
            }
        }
    }
}
