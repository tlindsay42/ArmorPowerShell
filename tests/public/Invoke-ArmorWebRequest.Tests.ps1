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
        'ExpectedOutputTypeNames' = 'System.Management.Automation.PSObject', 'System.Management.Automation.PSObject[]'
        'Help'                    = $help
    }
    TestAdvancedFunctionHelpOutputs @splat

    $splat = @{
        'ExpectedParameterNames' = 'Endpoint', 'Headers', 'Method', 'Body', 'SuccessCode', 'Description', 'WhatIf', 'Confirm'
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
            $invalidEndpoint = '/badEndpoint'
            $validEndpoint = '/apps'
            $invalidHeaders = @{}
            $validHeaders = @{
                'Accept'            = 'application/json'
                'Authorization'     = 'FH-AUTH d4641394719f4513a80f25de11a85138'
                'Content-Type'      = 'application/json'
                'X-Account-Context' = '1'
            }
            $invalidMethod = 'Download'
            $validMethod = 'Get'
            $invalidSuccessCode = 404
            $validSuccessCode = 200
            $invalidDescription = ''
            $validDescription = 'Description'
            #endregion

            $testCases = @(
                @{
                    'Endpoint'    = $validEndpoint
                    'Headers'     = $invalidHeaders
                    'Method'      = $validMethod
                    'SuccessCode' = $validSuccessCode
                    'Description' = $validDescription
                },
                @{
                    'Endpoint'    = $validEndpoint
                    'Headers'     = $validHeaders
                    'Method'      = $invalidMethod
                    'SuccessCode' = $validSuccessCode
                    'Description' = $validDescription
                },
                @{
                    'Endpoint'    = $validEndpoint
                    'Headers'     = $validHeaders
                    'Method'      = $validMethod
                    'SuccessCode' = $invalidSuccessCode
                    'Description' = $validDescription
                },
                @{
                    'Endpoint'    = $validEndpoint
                    'Headers'     = $validHeaders
                    'Method'      = $validMethod
                    'SuccessCode' = $validSuccessCode
                    'Description' = $invalidDescription
                }
            )
            $testName = 'should fail when set to: Endpoint: <Endpoint>, Headers: <Headers>, Method: <Method>, SuccessCode: <SuccessCode>, Description: <Description>'
            It -Name $testName -TestCases $testCases -Test {
                param ( [String] $Endpoint, [Hashtable] $Headers, [String] $Method, [UInt16] $SuccessCode, [String] $Description )
                { Invoke-ArmorWebRequest -Endpoint $Endpoint -Headers $Headers -Method $Method -Body '' -SuccessCode $SuccessCode -Description $Description } |
                    Should -Throw
            }

            Mock -CommandName Test-ArmorSession -Verifiable -MockWith {}
            Mock -CommandName Invoke-WebRequest -Verifiable -MockWith {
                @{
                    'StatusCode'        = 404
                    'StatusDescription' = 'Not Found'
                    'Content'           = ''
                }
            } -ParameterFilter { $Endpoint -match $invalidEndpoint }

            $testCases = @(
                @{
                    'Endpoint'    = $invalidEndpoint
                    'Headers'     = $validHeaders
                    'Method'      = $validMethod
                    'SuccessCode' = $validSuccessCode
                    'Description' = $validDescription
                }
            )
            $testName = 'should fail when set to: Endpoint: <Endpoint>, Headers: <Headers>, Method: <Method>, SuccessCode: <SuccessCode>, Description: <Description>'
            It -Name $testName -TestCases $testCases -Test {
                param ( [String] $Endpoint, [Hashtable] $Headers, [String] $Method, [UInt16] $SuccessCode, [String] $Description )
                { Invoke-ArmorWebRequest -Endpoint $Endpoint -Headers $Headers -Method $Method -Body '' -SuccessCode $SuccessCode -Description $Description } |
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
            } -ParameterFilter { $Endpoint -match $validEndpoint }

            $testCases = @(
                @{
                    'Endpoint'    = $validEndpoint
                    'Headers'     = $validHeaders
                    'Method'      = $validMethod
                    'SuccessCode' = $validSuccessCode
                    'Description' = $validDescription
                }
            )
            $testName = 'should not fail when set to: Endpoint: <Endpoint>, Headers: <Headers>, Method: <Method>, SuccessCode: <SuccessCode>, Description: <Description>'
            It -Name $testName -TestCases $testCases -Test {
                param ( [String] $Endpoint, [Hashtable] $Headers, [String] $Method, [UInt16] $SuccessCode, [String] $Description )
                { Invoke-ArmorWebRequest -Endpoint $Endpoint -Headers $Headers -Method $Method -Body '' -SuccessCode $SuccessCode -Description $Description } |
                    Should -Not -Throw
            }
            Assert-VerifiableMock
            Assert-MockCalled -CommandName Test-ArmorSession -Times $testCases.Count
            Assert-MockCalled -CommandName Invoke-WebRequest -Times $testCases.Count
        }
    }

    Context -Name $Global:ReturnTypeContext -Fixture {
        InModuleScope -ModuleName $Env:CI_MODULE_NAME -ScriptBlock {
            #region init
            $validHeaders = @{
                'Accept'            = 'application/json'
                'Authorization'     = 'FH-AUTH d4641394719f4513a80f25de11a85138'
                'Content-Type'      = 'application/json'
                'X-Account-Context' = '1'
            }
            #endregion

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
                    'FoundReturnType'    = ( Invoke-ArmorWebRequest -Endpoint '/apps' -Headers $validHeaders -ErrorAction 'Stop' ).GetType().FullName
                    'ExpectedReturnType' = 'System.Management.Automation.PSCustomObject'
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

            # $testName = "has an 'OutputType' entry for <FoundReturnType>"
            # It -Name $testName -TestCases $testCases -Test {
            #     param ( [String] $FoundReturnType, [String] $ExpectedReturnType )
            #     $FoundReturnType |
            #         Should -BeIn ( Get-Help -Name 'Invoke-ArmorWebRequest' -Full ).ReturnValues.ReturnValue.Type.Name
            # }
        }
    }
}
