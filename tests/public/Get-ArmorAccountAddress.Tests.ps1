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
        'ExpectedOutputTypeNames' = 'ArmorAccountAddress'
        'Help'                    = $help
    }
    TestAdvancedFunctionHelpOutputs @splat

    $splat = @{
        'ExpectedParameterNames' = 'ID', 'ApiVersion'
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
                    'ID'         = $invalidID
                    'ApiVersion' = $validApiVersion
                },
                @{
                    'ID'         = $validID
                    'ApiVersion' = $invalidApiVersion
                }
            )
            $testName = 'should fail when set to: ID: <ID>, ApiVersion: <ApiVersion>'
            It -Name $testName -TestCases $testCases -Test {
                param ( [String] $ID, [String] $ApiVersion )
                { Get-ArmorAccountAddress -ID $ID -ApiVersion $ApiVersion } |
                    Should -Throw
            }

            Mock -CommandName Test-ArmorSession -Verifiable -MockWith {}
            Mock -CommandName Invoke-WebRequest -Verifiable -MockWith {
                @{
                    'StatusCode'        = 200
                    'StatusDescription' = 'OK'
                    'Content'           = $Global:JsonResponseBody.Address1
                }
            }

            $testCases = @(
                @{
                    'ID'         = $validID
                    'ApiVersion' = $validApiVersion
                }
            )
            $testName = 'should not fail when set to: ID: <ID>, ApiVersion: <ApiVersion>'
            It -Name $testName -TestCases $testCases -Test {
                param ( [String] $ID, [String] $ApiVersion )
                { Get-ArmorAccountAddress -ID $ID -ApiVersion $ApiVersion } |
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
                    'Content'           = $Global:JsonResponseBody.Address1
                }
            }

            $testCases = @(
                @{
                    'FoundReturnType'    = ( Get-ArmorAccountAddress -ID 1 -ErrorAction 'Stop' ).GetType().FullName
                    'ExpectedReturnType' = 'ArmorAccountAddress'
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

            }
        }
    }
}
