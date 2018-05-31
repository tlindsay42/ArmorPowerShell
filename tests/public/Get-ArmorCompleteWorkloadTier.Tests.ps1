Import-Module -Name $env:CI_MODULE_MANIFEST_PATH -Force

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
        'ExpectedOutputTypeNames' = 'System.Management.Automation.PSObject[]'
        'Help'                    = $help
    }
    TestAdvancedFunctionHelpOutputs @splat

    $splat = @{
        'ExpectedParameterNames' = 'WorkloadID', 'ID', 'Name', 'ApiVersion'
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
            $invalidName = ''
            $validName = 'TR1'
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
                { Get-ArmorCompleteWorkloadTier -WorkloadID $WorkloadID -ID $ID -ApiVersion $ApiVersion } |
                    Should -Throw
            } # End of It

            $testCases = @(
                @{
                    'WorkloadID' = $invalidID
                    'Name'       = $validName
                    'ApiVersion' = $validApiVersion
                },
                @{
                    'WorkloadID' = $validID
                    'Name'       = $invalidName
                    'ApiVersion' = $validApiVersion
                },
                @{
                    'WorkloadID' = $validID
                    'Name'       = $validName
                    'ApiVersion' = $invalidApiVersion
                }
            )
            $testName = 'should fail when set to: WorkloadID: <WorkloadID>, Name: <Name>, ApiVersion: <ApiVersion>'
            It -Name $testName -TestCases $testCases -Test {
                param ( [String] $WorkloadID, [String] $Name, [String] $ApiVersion )
                { Get-ArmorCompleteWorkloadTier -WorkloadID $WorkloadID -Name $Name -ApiVersion $ApiVersion } |
                    Should -Throw
            } # End of It

            Mock -CommandName Test-ArmorSession -Verifiable -MockWith {}
            Mock -CommandName Invoke-WebRequest -Verifiable -MockWith {
                @{
                    'StatusCode'        = 200
                    'StatusDescription' = 'OK'
                    'Content'           = $Global:JsonResponseBody.Tiers1VMs1
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
                { Get-ArmorCompleteWorkloadTier -WorkloadID $WorkloadID -ID $ID -ApiVersion $ApiVersion } |
                    Should -Not -Throw
            } # End of It
            Assert-VerifiableMock
            Assert-MockCalled -CommandName Test-ArmorSession -Times $testCases.Count
            Assert-MockCalled -CommandName Invoke-WebRequest -Times $testCases.Count

            $testCases = @(
                @{
                    'WorkloadID' = $validID
                    'Name'       = $validName
                    'ApiVersion' = $validApiVersion
                },
                @{
                    'WorkloadID' = $validID
                    'Name'       = 'Garbage'
                    'ApiVersion' = $validApiVersion
                }
            )
            $testName = 'should not fail when set to: WorkloadID: <WorkloadID>, Name: <Name>, ApiVersion: <ApiVersion>'
            It -Name $testName -TestCases $testCases -Test {
                param ( [String] $WorkloadID, [String] $Name, [String] $ApiVersion )
                { Get-ArmorCompleteWorkloadTier -WorkloadID $WorkloadID -Name $Name -ApiVersion $ApiVersion } |
                    Should -Not -Throw
            } # End of It
            Assert-VerifiableMock
            Assert-MockCalled -CommandName Test-ArmorSession -Times $testCases.Count
            Assert-MockCalled -CommandName Invoke-WebRequest -Times $testCases.Count
        } # End of InModuleScope
    } # End of Context

    Context -Name $Global:ReturnTypeContext -Fixture {
        InModuleScope -ModuleName $Env:CI_MODULE_NAME -ScriptBlock {
            Mock -CommandName Test-ArmorSession -Verifiable -MockWith {}
            Mock -CommandName Invoke-WebRequest -Verifiable -MockWith {
                @{
                    'StatusCode'        = 200
                    'StatusDescription' = 'OK'
                    'Content'           = $Global:JsonResponseBody.Tiers1VMs1
                }
            }

            $testCases = @(
                @{
                    'FoundReturnType'    = ( Get-ArmorCompleteWorkloadTier -WorkloadID 1 -ID 1 -ErrorAction 'Stop' ).GetType().FullName
                    'ExpectedReturnType' = 'System.Management.Automation.PSCustomObject'
                },
                @{
                    'FoundReturnType'    = ( Get-ArmorCompleteWorkloadTier -WorkloadID 1 -Name 'TR1' -ErrorAction 'Stop' ).GetType().FullName
                    'ExpectedReturnType' = 'System.Management.Automation.PSCustomObject'
                }
            )
            $testName = $Global:ReturnTypeForm
            It -Name $testName -TestCases $testCases -Test {
                param ( [String] $FoundReturnType, [String] $ExpectedReturnType )
                $FoundReturnType |
                    Should -Be $ExpectedReturnType
            } # End of It
            Assert-VerifiableMock
            Assert-MockCalled -CommandName Test-ArmorSession -Times $testCases.Count
            Assert-MockCalled -CommandName Invoke-WebRequest -Times $testCases.Count

            # $testName = "has an 'OutputType' entry for <FoundReturnType>"
            # It -Name $testName -TestCases $testCases -Test {
            #     param ( [String] $FoundReturnType, [String] $ExpectedReturnType )
            #     $FoundReturnType |
            #         Should -BeIn ( Get-Help -Name 'Get-ArmorCompleteWorkloadTier' -Full ).ReturnValues.ReturnValue.Type.Name
            # } # End of It
        } # End of InModuleScope
    } # End of Context
} # End of Describe
