Import-Module -Name $CI_MODULE_MANIFEST_PATH -Force

$systemUnderTest = ( Split-Path -Leaf $MyInvocation.MyCommand.Path ) -replace '\.Tests\.', '.'

$function = $systemUnderTest.Split( '.' )[0]
$describe = $Global:FORM_FUNCTION_PUBLIC -f $function
Describe -Name $describe -Tag 'Function', 'Public', $function -Fixture {
    #region init
    $help = Get-Help -Name $function -Full

    $Global:ArmorSession = [ArmorSession]::New( 'api.armor.com', 443, 'v1.0' )
    #endregion

    $splat = @{
        ExpectedFunctionName = $function
        FoundFunctionName    = $help.Name
    }
    Test-AdvancedFunctionName @splat

    Test-AdvancedFunctionHelpMain -Help $help

    Test-AdvancedFunctionHelpInput -Help $help

    $splat = @{
        ExpectedOutputTypeNames = 'ArmorCompleteWorkload', 'ArmorCompleteWorkload[]'
        Help                    = $help
    }
    Test-AdvancedFunctionHelpOutput @splat

    $splat = @{
        ExpectedParameterNames = 'ID', 'NewName', 'ApiVersion', 'WhatIf', 'Confirm'
        Help                   = $help
    }
    Test-AdvancedFunctionHelpParameter @splat

    $splat = @{
        ExpectedNotes = $Global:FORM_FUNCTION_HELP_NOTES
        Help          = $help
    }
    Test-AdvancedFunctionHelpNote @splat

    Context -Name $Global:EXECUTION -Fixture {
        InModuleScope -ModuleName $Global:CI_MODULE_NAME -ScriptBlock {
            #region init
            $invalidID = 0
            $validID = 1
            $invalidNewName = ''
            $validNewName = 'FakeName'
            $invalidApiVersion = 'v0.0'
            $validApiVersion = 'v1.0'
            #endregion

            $testCases = @(
                @{
                    ID         = $invalidID
                    NewName    = $validNewName
                    ApiVersion = $validApiVersion
                },
                @{
                    ID         = $validID
                    NewName    = $invalidNewName
                    ApiVersion = $validApiVersion
                },
                @{
                    ID         = $validID
                    NewName    = $validNewName
                    ApiVersion = $invalidApiVersion
                }
            )
            $testName = 'should fail when set to: ID: <ID>, NewName: <NewName>, ApiVersion: <ApiVersion>'
            It -Name $testName -TestCases $testCases -Test {
                param ( [String] $ID, [String] $NewName, [String] $ApiVersion )
                { Rename-ArmorCompleteWorkload -ID $ID -NewName $NewName -ApiVersion $ApiVersion -Confirm:$false } |
                    Should -Throw
            }

            Mock -CommandName Test-ArmorSession -Verifiable -MockWith {}
            Mock -CommandName Invoke-WebRequest -Verifiable -MockWith {
                @{
                    StatusCode        = 200
                    StatusDescription = 'OK'
                    Content           = $Global:JSON_RESPONSE_BODY.Workloads1Tiers1VMs1
                }
            }

            $testCases = @(
                @{
                    ID         = $validID
                    NewName    = $validNewName
                    ApiVersion = $validApiVersion
                }
            )
            $testName = 'should not fail when set to: ID: <ID>, NewName: <NewName>, ApiVersion: <ApiVersion>'
            It -Name $testName -TestCases $testCases -Test {
                param ( [String] $ID, [String] $NewName, [String] $ApiVersion )
                { Rename-ArmorCompleteWorkload -ID $ID -NewName $NewName -ApiVersion $ApiVersion -Confirm:$false } |
                    Should -Not -Throw
            }
            Assert-VerifiableMock
            Assert-MockCalled -CommandName Test-ArmorSession -Times $testCases.Count
            Assert-MockCalled -CommandName Invoke-WebRequest -Times $testCases.Count
        }
    }

    Context -Name $Global:RETURN_TYPE_CONTEXT -Fixture {
        InModuleScope -ModuleName $Global:CI_MODULE_NAME -ScriptBlock {
            Mock -CommandName Test-ArmorSession -Verifiable -MockWith {}
            Mock -CommandName Invoke-WebRequest -Verifiable -MockWith {
                @{
                    StatusCode        = 200
                    StatusDescription = 'OK'
                    Content           = $Global:JSON_RESPONSE_BODY.Workloads1Tiers1VMs1
                }
            }

            $testCases = @(
                @{
                    FoundReturnType    = ( Rename-ArmorCompleteWorkload -ID 1 -NewName 'FakeName' -Confirm:$false -ErrorAction 'Stop' ).GetType().FullName
                    ExpectedReturnType = 'ArmorCompleteWorkload'
                }
            )
            $testName = $Global:FORM_RETURN_TYPE
            It -Name $testName -TestCases $testCases -Test {
                param ( [String] $FoundReturnType, [String] $ExpectedReturnType )
                $FoundReturnType |
                    Should -Be $ExpectedReturnType
            }
            Assert-VerifiableMock
            Assert-MockCalled -CommandName Test-ArmorSession -Times $testCases.Count
            Assert-MockCalled -CommandName Invoke-WebRequest -Times $testCases.Count

            $testName = "has an 'OutputType' entry for <FoundReturnType>"
            It -Name $testName -TestCases $testCases -Test {
                param ( [String] $FoundReturnType, [String] $ExpectedReturnType )
                $FoundReturnType |
                    Should -BeIn ( Get-Help -Name 'Rename-ArmorCompleteWorkload' -Full ).ReturnValues.ReturnValue.Type.Name
            }
        }
    }
}
