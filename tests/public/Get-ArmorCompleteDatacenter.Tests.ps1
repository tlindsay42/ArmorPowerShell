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
        'ExpectedOutputTypeNames' = 'ArmorCompleteDatacenter[]'
        'Help'                    = $help
    }
    TestAdvancedFunctionHelpOutputs @splat

    $splat = @{
        'ExpectedParameterNames' = 'ID', 'Name', 'Location', 'ApiVersion'
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
            $validName = 'US Central'
            $invalidLocation = ''
            $validLocation = 'DFW01'
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
                { Get-ArmorCompleteDatacenter -ID $ID -ApiVersion $ApiVersion } |
                    Should -Throw
            } # End of It

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
                { Get-ArmorCompleteDatacenter -Name $Name -ApiVersion $ApiVersion } |
                    Should -Throw
            } # End of It

            $testCases = @(
                @{
                    'Location'   = $invalidLocation
                    'ApiVersion' = $validApiVersion
                },
                @{
                    'Location'   = $validLocation
                    'ApiVersion' = $invalidApiVersion
                }
            )
            $testName = 'should fail when set to: Location: <Location>, ApiVersion: <ApiVersion>'
            It -Name $testName -TestCases $testCases -Test {
                param ( [String] $Name, [String] $ApiVersion )
                { Get-ArmorCompleteDatacenter -Name $Name -ApiVersion $ApiVersion } |
                    Should -Throw
            } # End of It

            Mock -CommandName Test-ArmorSession -Verifiable -MockWith {}
            Mock -CommandName Invoke-WebRequest -Verifiable -MockWith {
                @{
                    'StatusCode'        = 200
                    'StatusDescription' = 'OK'
                    'Content'           = $Global:JsonResponseBody.Datacenters5
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
                { Get-ArmorCompleteDatacenter -ID $ID -ApiVersion $ApiVersion } |
                    Should -Not -Throw
            } # End of It
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
                { Get-ArmorCompleteDatacenter -Name $Name -ApiVersion $ApiVersion } |
                    Should -Not -Throw
            } # End of It
            Assert-VerifiableMock
            Assert-MockCalled -CommandName Test-ArmorSession -Times $testCases.Count
            Assert-MockCalled -CommandName Invoke-WebRequest -Times $testCases.Count

            $testCases = @(
                @{
                    'Location'   = $validLocation
                    'ApiVersion' = $validApiVersion
                }
            )
            $testName = 'should not fail when set to: Location: <Location>, ApiVersion: <ApiVersion>'
            It -Name $testName -TestCases $testCases -Test {
                param ( [String] $Location, [String] $ApiVersion )
                { Get-ArmorCompleteDatacenter -Location $Location -ApiVersion $ApiVersion } |
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
                    'Content'           = $Global:JsonResponseBody.Datacenters5
                }
            }

            $testCases = @(
                @{
                    'FoundReturnType'    = ( Get-ArmorCompleteDatacenter -ID 5 -ErrorAction 'Stop' ).GetType().FullName
                    'ExpectedReturnType' = 'ArmorCompleteDatacenter'
                },
                @{
                    'FoundReturnType'    = ( Get-ArmorCompleteDatacenter -Name 'AS East' -ErrorAction 'Stop' ).GetType().FullName
                    'ExpectedReturnType' = 'ArmorCompleteDatacenter'
                },
                @{
                    'FoundReturnType'    = ( Get-ArmorCompleteDatacenter -Location 'AMS01' -ErrorAction 'Stop' ).GetType().FullName
                    'ExpectedReturnType' = 'ArmorCompleteDatacenter'
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
            #         Should -BeIn ( Get-Help -Name 'Get-ArmorCompleteDatacenter' -Full ).ReturnValues.ReturnValue.Type.Name
            # } # End of It
        } # End of InModuleScope
    } # End of Context
} # End of Describe
