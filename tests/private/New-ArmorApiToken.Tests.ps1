Import-Module -Name $CI_MODULE_MANIFEST_PATH -Force

$systemUnderTest = ( Split-Path -Leaf $MyInvocation.MyCommand.Path ) -replace '\.Tests\.', '.'
$filePath = Join-Path -Path $CI_MODULE_PRIVATE_PATH -ChildPath $systemUnderTest

. $filePath

$function = $systemUnderTest.Split( '.' )[0]
$describe = $Global:FORM_FUNCTION_PRIVATE -f $function
Describe -Name $describe -Tag 'Function', 'Private', $function -Fixture {
    #region init
    $help = Get-Help -Name $function -Full
    #endregion

    $splat = @{
        ExpectedFunctionName = $function
        FoundFunctionName    = $help.Name
    }
    Test-AdvancedFunctionName @splat

    Test-AdvancedFunctionHelpMain -Help $help

    Test-AdvancedFunctionHelpInput -Help $help

    $splat = @{
        ExpectedOutputTypeNames = 'System.Management.Automation.PSObject'
        Help                    = $help
    }
    Test-AdvancedFunctionHelpOutput @splat

    $splat = @{
        ExpectedParameterNames = 'Code', 'GrantType', 'ApiVersion'
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
            $invalidCode = 'bad_code'
            $validCode = '+8oaKtcO9kuVbjUXlfnlHCY3HmXXCidHjzOBGwr+iTo='
            $invalidGrantType = 'auth_code'
            $validGrantType = 'authorization_code'
            $invalidApiVersion = 'v0.0'
            $validApiVersion = 'v1.0'

            $Global:ArmorSession = [ArmorSession]::New()
            #endregion

            $testCases = @(
                @{
                    Code       = $invalidCode
                    GrantType  = $validGrantType
                    ApiVersion = $validApiVersion
                },
                @{
                    Code       = $validCode
                    GrantType  = $invalidGrantType
                    ApiVersion = $validApiVersion
                },
                @{
                    Code       = $validCode
                    GrantType  = $validGrantType
                    ApiVersion = $invalidApiVersion
                }
            )
            $testName = 'should fail when set to: Code: <Code>, GrantType: <GrantType>, ApiVersion: <ApiVersion> (named)'
            It -Name $testName -TestCases $testCases -Test {
                param ( [String] $Code, [String] $GrantType, [String] $ApiVersion )
                { New-ArmorApiToken -Code $Code -GrantType $GrantType -ApiVersion $ApiVersion } |
                    Should -Throw
            }

            $testName = $testName -replace '\(named\)', '(positional)'
            It -Name $testName -TestCases $testCases -Test {
                param ( [String] $Code, [String] $GrantType, [String] $ApiVersion )
                { New-ArmorApiToken $Code $GrantType $ApiVersion } |
                    Should -Throw
            }

            Mock -CommandName Invoke-WebRequest -Verifiable -MockWith {
                @{
                    StatusCode = 200
                    Content    = $Global:JSON_RESPONSE_BODY.Token1
                }
            } -ParameterFilter {
                $Uri -match ( Get-ArmorApiData -FunctionName 'New-ArmorApiToken' -ApiVersion 'v1.0' ).Endpoints
            }

            $testCases = @(
                @{
                    Code       = $validCode
                    GrantType  = $validGrantType
                    ApiVersion = $validApiVersion
                }
            )
            $testName = 'should not fail when set to: Code: <Code>, GrantType: <GrantType>, ApiVersion: <ApiVersion> (named)'
            It -Name $testName -TestCases $testCases -Test {
                param ( [String] $Code, [String] $GrantType, [String] $ApiVersion )
                { New-ArmorApiToken -Code $Code -GrantType $GrantType -ApiVersion $ApiVersion } |
                    Should -Not -Throw
            }
            Assert-VerifiableMock
            Assert-MockCalled -CommandName Invoke-WebRequest -Times $testCases.Count

            $testName = $testName -replace '\(named\)', '(positional)'
            It -Name $testName -TestCases $testCases -Test {
                param ( [String] $Code, [String] $GrantType, [String] $ApiVersion )
                { New-ArmorApiToken $Code $GrantType $ApiVersion } |
                    Should -Not -Throw
            }
            Assert-VerifiableMock
            Assert-MockCalled -CommandName Invoke-WebRequest -Times $testCases.Count
        }
    }

    Context -Name $Global:RETURN_TYPE_CONTEXT -Fixture {
        InModuleScope -ModuleName $Global:CI_MODULE_NAME -ScriptBlock {
            #region init
            $splat = @{
                Code        = '+8oaKtcO9kuVbjUXlfnlHCY3HmXXCidHjzOBGwr+iTo='
                GrantType   = 'authorization_code'
                ApiVersion  = 'v1.0'
                ErrorAction = 'Stop'
            }

            $Global:ArmorSession = [ArmorSession]::New()
            #endregion

            Mock -CommandName Invoke-WebRequest -Verifiable -MockWith {
                @{
                    StatusCode = 200
                    Content    = $Global:JSON_RESPONSE_BODY.Token1
                }
            } -ParameterFilter {
                $Uri -match ( Get-ArmorApiData -FunctionName 'New-ArmorApiToken' -ApiVersion 'v1.0' ).Endpoints
            }

            $testCases = @(
                @{
                    FoundReturnType    = ( New-ArmorApiToken @splat ).GetType().FullName
                    ExpectedReturnType = 'System.Management.Automation.PSCustomObject'
                }
            )
            $testName = $Global:FORM_RETURN_TYPE
            It -Name $testName -TestCases $testCases -Test {
                param ( [String] $FoundReturnType, [String] $ExpectedReturnType )
                $FoundReturnType |
                    Should -Be $ExpectedReturnType
            }
            Assert-VerifiableMock
            Assert-MockCalled -CommandName Invoke-WebRequest -Times $testCases.Count

            $testName = "has an 'OutputType' entry for <FoundReturnType>"
            It -Name $testName -TestCases $testCases -Test {
                param ( [String] $FoundReturnType, [String] $ExpectedReturnType )
                $FoundReturnType |
                    Should -BeIn ( @( ( Get-Help -Name 'New-ArmorApiToken' ).ReturnValues.ReturnValue.Type.Name ) + $ExpectedReturnType )
            }
        }
    }
}
