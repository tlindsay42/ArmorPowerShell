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
        'ExpectedOutputTypeNames' = 'ArmorCompleteWorkloadTier'
        'Help'                    = $help
    }
    TestAdvancedFunctionHelpOutputs @splat

    $splat = @{
        'ExpectedParameterNames' = 'WorkloadID', 'ID', 'ApiVersion', 'WhatIf', 'Confirm'
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
            $invalidApiVersion = 'v0.0'
            $validApiVersion = 'v1.0'
            #endregion

            $testCases = @(
                @{
                    'WorkloadID' = $invalidID
                    'ID'         = $validID
                    'ApiVersion' = $validApiVersion
                },
                @{
                    'WorkloadID' = $validID
                    'ID'         = $invalidID
                    'ApiVersion' = $validApiVersion
                },
                @{
                    'WorkloadID' = $validID
                    'ID'         = $validID
                    'ApiVersion' = $invalidApiVersion
                }
            )
            $testName = 'should fail when set to: WorkloadID: <WorkloadID>, ID: <ID>, ApiVersion: <ApiVersion>'
            It -Name $testName -TestCases $testCases -Test {
                param ( [String] $WorkloadID, [String] $ID, [String] $ApiVersion )
                { Remove-ArmorCompleteWorkloadTier -WorkloadID $WorkloadID -ID $ID -ApiVersion $ApiVersion -Confirm:$false -ErrorAction 'Stop' } |
                    Should -Throw
            }

            Mock -CommandName Test-ArmorSession -Verifiable -MockWith {}
            Mock -CommandName Invoke-WebRequest -Verifiable -MockWith {
                @{
                    'StatusCode'        = 404
                    'StatusDescription' = 'Not Found'
                    'Content'           = ''
                }
            }

            $testCases = @(
                @{
                    'WorkloadID' = 2
                    'ID'         = $validID
                    'ApiVersion' = $validApiVersion
                }
            )
            $testName = 'should fail when set to: WorkloadID: <WorkloadID>, ID: <ID>, ApiVersion: <ApiVersion>'
            It -Name $testName -TestCases $testCases -Test {
                param ( [String] $WorkloadID, [String] $ID, [String] $ApiVersion )
                { Remove-ArmorCompleteWorkloadTier -WorkloadID $WorkloadID -ID $ID -ApiVersion $ApiVersion -Confirm:$false -ErrorAction 'Stop' } |
                    Should -Throw
            }
            Assert-VerifiableMock
            Assert-MockCalled -CommandName Test-ArmorSession -Times $testCases.Count
            Assert-MockCalled -CommandName Invoke-WebRequest -Times $testCases.Count

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
                    'ApiVersion' = $validApiVersion
                }
            )
            $testName = 'should not fail when set to: WorkloadID: <WorkloadID>, ID: <ID>, ApiVersion: <ApiVersion>'
            It -Name $testName -TestCases $testCases -Test {
                param ( [String] $WorkloadID, [String] $ID, [String] $ApiVersion )
                { Remove-ArmorCompleteWorkloadTier -WorkloadID $WorkloadID -ID $ID -ApiVersion $ApiVersion -Confirm:$false } |
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
                    'FoundReturnType'    = ( Remove-ArmorCompleteWorkloadTier -WorkloadID 1 -ID 1 -Confirm:$false -ErrorAction 'Stop' ).GetType().FullName
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
                    Should -BeIn ( Get-Help -Name 'Remove-ArmorCompleteWorkloadTier' -Full ).ReturnValues.ReturnValue.Type.Name
            }
        }
    }
}
