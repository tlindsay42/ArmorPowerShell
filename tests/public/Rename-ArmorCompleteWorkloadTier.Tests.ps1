Import-Module -Name $Env:CI_MODULE_MANIFEST_PATH -Force

$systemUnderTest = ( Split-Path -Leaf $MyInvocation.MyCommand.Path ) -replace '\.Tests\.', '.'

$function = $systemUnderTest.Split( '.' )[0]
$describe = $Global:PublicFunctionForm -f $function
Describe -Name $describe -Tag 'Function', 'Public', $function -Fixture {
    #region init
    $help = Get-Help -Name $function -Full

    $Global:ArmorSession = [ArmorSession]::New( 'api.armor.com', 443, 'v1.0' )
    #endregion

    $splat = @{
        'ExpectedFunctionName' = $function
        'FoundFunctionName'    = $help.Name
    }
    TestAdvancedFunctionName @splat

    TestAdvancedFunctionHelpMain -Help $help

    TestAdvancedFunctionHelpInputs -Help $help

    $splat = @{
        'ExpectedOutputTypeNames' = 'ArmorCompleteWorkloadTier', 'ArmorCompleteWorkloadTier[]'
        'Help'                    = $help
    }
    TestAdvancedFunctionHelpOutputs @splat

    $splat = @{
        'ExpectedParameterNames' = 'WorkloadID', 'ID', 'NewName', 'ApiVersion', 'WhatIf', 'Confirm'
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
            $validID = 1
            $invalidNewName = ''
            $validNewName = 'FakeName'
            $invalidApiVersion = 'v0.0'
            $validApiVersion = 'v1.0'
            #endregion

            $testCases = @(
                @{
                    'WorkloadID' = $invalidID
                    'ID'         = $validID
                    'NewName'    = $validNewName
                    'ApiVersion' = $validApiVersion
                },
                @{
                    'WorkloadID' = $validID
                    'ID'         = $invalidID
                    'NewName'    = $validNewName
                    'ApiVersion' = $validApiVersion
                },
                @{
                    'WorkloadID' = $validID
                    'ID'         = $validID
                    'NewName'    = $invalidNewName
                    'ApiVersion' = $validApiVersion
                },
                @{
                    'WorkloadID' = $validID
                    'ID'         = $validID
                    'NewName'    = $validNewName
                    'ApiVersion' = $invalidApiVersion
                }
            )
            $testName = 'should fail when set to: ID: <ID>, NewName: <NewName>, ApiVersion: <ApiVersion>'
            It -Name $testName -TestCases $testCases -Test {
                param ( [String] $WorkloadID, [String] $ID, [String] $NewName, [String] $ApiVersion )
                { Rename-ArmorCompleteWorkloadTier -WorkloadID $WorkloadID -ID $ID -NewName $NewName -ApiVersion $ApiVersion -Confirm:$false } |
                    Should -Throw
            }

            Mock -CommandName Test-ArmorSession -Verifiable -MockWith {}
            Mock -CommandName Invoke-WebRequest -Verifiable -MockWith {
                @{
                    'StatusCode'        = 200
                    'StatusDescription' = 'OK'
                    'Content'           = $Global:JsonResponseBody.Workloads1Tiers1VMs1
                }
            }

            $testCases = @(
                @{
                    'WorkloadID' = $validID
                    'ID'         = $validID
                    'NewName'    = $validNewName
                    'ApiVersion' = $validApiVersion
                }
            )
            $testName = 'should not fail when set to: ID: <ID>, NewName: <NewName>, ApiVersion: <ApiVersion>'
            It -Name $testName -TestCases $testCases -Test {
                param ( [String] $WorkloadID, [String] $ID, [String] $NewName, [String] $ApiVersion )
                { Rename-ArmorCompleteWorkloadTier -WorkloadID $WorkloadID -ID $ID -NewName $NewName -ApiVersion $ApiVersion -Confirm:$false } |
                    Should -Not -Throw
            }
            Assert-VerifiableMock
            Assert-MockCalled -CommandName Test-ArmorSession -Times $testCases.Count
            Assert-MockCalled -CommandName Invoke-WebRequest -Times $testCases.Count
        }
    }

    Context -Name $Global:ReturnTypeContext -Fixture {
        InModuleScope -ModuleName $Env:CI_MODULE_NAME -ScriptBlock {
            Mock -CommandName Test-ArmorSession -Verifiable -MockWith {}
            Mock -CommandName Invoke-WebRequest -Verifiable -MockWith {
                @{
                    'StatusCode'        = 200
                    'StatusDescription' = 'OK'
                    'Content'           = $Global:JsonResponseBody.Workloads1Tiers1VMs1
                }
            }

            $testCases = @(
                @{
                    'FoundReturnType'    = ( Rename-ArmorCompleteWorkloadTier -WorkloadID 1 -ID 1 -NewName 'FakeName' -Confirm:$false -ErrorAction 'Stop' ).GetType().FullName
                    'ExpectedReturnType' = 'ArmorCompleteWorkloadTier'
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
            Assert-MockCalled -CommandName Invoke-WebRequest -Times $testCases.Count

            $testName = "has an 'OutputType' entry for <FoundReturnType>"
            It -Name $testName -TestCases $testCases -Test {
                param ( [String] $FoundReturnType, [String] $ExpectedReturnType )
                $FoundReturnType |
                    Should -BeIn ( Get-Help -Name 'Rename-ArmorCompleteWorkloadTier' -Full ).ReturnValues.ReturnValue.Type.Name
            }
        }
    }
}
