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
        'ExpectedOutputTypeNames' = 'ArmorVM', 'ArmorVM[]'
        'Help'                    = $help
    }
    TestAdvancedFunctionHelpOutputs @splat

    $splat = @{
        'ExpectedParameterNames' = 'ID', 'CoreInstanceID', 'Name', 'ApiVersion'
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
            $invalidCoreInstanceID = 'a3443a81-d773-4daf-abd-abde1362291f'
            $validCoreInstanceID = '019f4c39-2be2-4738-8e0a-3349a8fd8769'
            $invalidName = ''
            $validName = 'VM1'
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
                { Get-ArmorVM -ID $ID -ApiVersion $ApiVersion } |
                    Should -Throw
            }

            $testCases = @(
                @{
                    'CoreInstanceID' = $invalidCoreInstanceID
                    'ApiVersion'     = $validApiVersion
                },
                @{
                    'CoreInstanceID' = $validCoreInstanceID
                    'ApiVersion'     = $invalidApiVersion
                }
            )
            $testName = 'should fail when set to: CoreInstanceID: <CoreInstanceID>, ApiVersion: <ApiVersion>'
            It -Name $testName -TestCases $testCases -Test {
                param ( [String] $CoreInstanceID, [String] $ApiVersion )
                { Get-ArmorVM -CoreInstanceID $CoreInstanceID -ApiVersion $ApiVersion } |
                    Should -Throw
            }

            $testCases = @(
                @{
                    'Name'       = $invalidName
                    'ApiVersion' = $validApiVersion
                },
                @{
                    'Name'       = $validName
                    'ApiVersion' = $invalidApiVersion
                }
            )
            $testName = 'should fail when set to: Name: <Name>, ApiVersion: <ApiVersion>'
            It -Name $testName -TestCases $testCases -Test {
                param ( [String] $Name, [String] $ApiVersion )
                { Get-ArmorVM -Name $Name -ApiVersion $ApiVersion -ErrorAction 'Stop' } |
                    Should -Throw
            }

            Mock -CommandName Test-ArmorSession -Verifiable -MockWith {}
            Mock -CommandName Invoke-WebRequest -Verifiable -MockWith {
                @{
                    'StatusCode'        = 200
                    'StatusDescription' = 'OK'
                    'Content'           = $Global:JsonResponseBody.VMs1
                }
            }

            $testCases = @(
                @{
                    'Name'       = 'Garbage'
                    'ApiVersion' = $validApiVersion
                }
            )
            $testName = 'should fail when set to: Name: <Name>, ApiVersion: <ApiVersion>'
            It -Name $testName -TestCases $testCases -Test {
                param ( [String] $Name, [String] $ApiVersion )
                { Get-ArmorVM -Name $Name -ApiVersion $ApiVersion -ErrorAction 'Stop' } |
                    Should -Throw
            }
            Assert-VerifiableMock
            Assert-MockCalled -CommandName Test-ArmorSession -Times $testCases.Count
            Assert-MockCalled -CommandName Invoke-WebRequest -Times $testCases.Count

            $testCases = @(
                @{
                    'ID'         = $validID
                    'ApiVersion' = $validApiVersion
                }
            )
            $testName = 'should not fail when set to: ID: <ID>, ApiVersion: <ApiVersion>'
            It -Name $testName -TestCases $testCases -Test {
                param ( [String] $ID, [String] $ApiVersion )
                { Get-ArmorVM -ID $ID -ApiVersion $ApiVersion } |
                    Should -Not -Throw
            }
            Assert-VerifiableMock
            Assert-MockCalled -CommandName Test-ArmorSession -Times $testCases.Count
            Assert-MockCalled -CommandName Invoke-WebRequest -Times $testCases.Count

            $testCases = @(
                @{
                    'CoreInstanceID' = $validCoreInstanceID
                    'ApiVersion'     = $validApiVersion
                }
            )
            $testName = 'should not fail when set to: CoreInstanceID: <CoreInstanceID>, ApiVersion: <ApiVersion>'
            It -Name $testName -TestCases $testCases -Test {
                param ( [String] $CoreInstanceID, [String] $ApiVersion )
                { Get-ArmorVM -CoreInstanceID $CoreInstanceID -ApiVersion $ApiVersion } |
                    Should -Not -Throw
            }
            Assert-VerifiableMock
            Assert-MockCalled -CommandName Test-ArmorSession -Times $testCases.Count
            Assert-MockCalled -CommandName Invoke-WebRequest -Times $testCases.Count

            $testCases = @(
                @{
                    'Name'       = $validName
                    'ApiVersion' = $validApiVersion
                }
            )
            $testName = 'should not fail when set to: Name: <Name>, ApiVersion: <ApiVersion>'
            It -Name $testName -TestCases $testCases -Test {
                param ( [String] $Name, [String] $ApiVersion )
                { Get-ArmorVM -Name $Name -ApiVersion $ApiVersion } |
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
                    'Content'           = $Global:JsonResponseBody.VMs1
                }
            }

            $testCases = @(
                @{
                    'FoundReturnType'    = ( Get-ArmorVM -ID 1 -ErrorAction 'Stop' ).GetType().FullName
                    'ExpectedReturnType' = 'ArmorVM'
                },
                @{
                    'FoundReturnType'    = ( Get-ArmorVM -CoreInstanceID '2a4dd463-ea7c-4369-be47-75a69c2c5519' -ErrorAction 'Stop' ).GetType().FullName
                    'ExpectedReturnType' = 'ArmorVM'
                },
                @{
                    'FoundReturnType'    = ( Get-ArmorVM -Name 'VM1' -ErrorAction 'Stop' ).GetType().FullName
                    'ExpectedReturnType' = 'ArmorVM'
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
                    Should -BeIn ( Get-Help -Name 'Get-ArmorVM' -Full ).ReturnValues.ReturnValue.Type.Name
            }
        }
    }
}
