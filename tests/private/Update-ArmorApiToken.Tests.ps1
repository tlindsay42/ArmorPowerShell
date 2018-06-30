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
        ExpectedOutputTypeNames = 'System.Void'
        Help                    = $help
    }
    Test-AdvancedFunctionHelpOutput @splat

    $splat = @{
        ExpectedParameterNames = 'Token', 'ApiVersion'
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
            $validToken = 'd4641394719f4513a80f25de11a85138'
            $validApiVersion = 'v1.0'
            #endregion

            Mock -CommandName Submit-ArmorApiRequest -Verifiable -MockWith {
                @{
                    access_token = '2c307390e95843'
                    id_token     = $null
                    expires_in   = 15
                    token_type   = 'Bearer'
                }
            }

            $testCases = @(
                @{
                    Token      = ''
                    ApiVersion = $validApiVersion
                },
                @{
                    Token      = $validToken
                    ApiVersion = '1.0'
                },
                @{ # Invalid access_token in response body
                    Token      = $validToken
                    ApiVersion = $validApiVersion
                }
            )
            $testName = 'should fail when Token: <Token> ApiVersion: <ApiVersion> access_token: 2c307390e95843'
            It -Name $testName -TestCases $testCases -Test {
                param ( [String] $Token, [String] $ApiVersion )
                { Update-ArmorApiToken -Token $Token -ApiVersion $ApiVersion } |
                    Should -Throw
            }
            Assert-VerifiableMock
            Assert-MockCalled -CommandName Submit-ArmorApiRequest -Times 1

            Mock -CommandName Submit-ArmorApiRequest -Verifiable -MockWith {
                @{
                    access_token = '2c307390e95843e38804f40ca8cac03e'
                    id_token     = $null
                    expires_in   = 15
                    token_type   = 'Bearer'
                }
            }

            [ArmorSession] $Global:ArmorSession = $Global:JSON_RESPONSE_BODY.Session1 |
                ConvertFrom-Json -ErrorAction 'Stop'
            $Global:ArmorSession.Headers.Authorization = "FH-AUTH ${validToken}"

            $testCases = @(
                @{
                    Token      = $validToken
                    ApiVersion = $validApiVersion
                }
            )
            $testName = 'should not fail when Token: <Token> ApiVersion: <ApiVersion> access_token: 2c307390e95843e38804f40ca8cac03e'
            It -Name $testName -TestCases $testCases -Test {
                param ( [String] $Token, [String] $ApiVersion )
                { Update-ArmorApiToken -Token $Token -ApiVersion $ApiVersion } |
                    Should -Not -Throw
            }
            Assert-VerifiableMock
            Assert-MockCalled -CommandName Submit-ArmorApiRequest -Times $testCases.Count
        }
    }

    Context -Name $Global:RETURN_TYPE_CONTEXT -Fixture {
        InModuleScope -ModuleName $Global:CI_MODULE_NAME -ScriptBlock {
            #region init
            $returnValue = $null
            $returnType = $null

            [ArmorSession] $Global:ArmorSession = $Global:JSON_RESPONSE_BODY.Session1 |
                ConvertFrom-Json -ErrorAction 'Stop'
            $Global:ArmorSession.Headers.Authorization = "FH-AUTH d4641394719f4513a80f25de11a85138"
            #endregion

            Mock -CommandName Submit-ArmorApiRequest -Verifiable -MockWith {
                @{
                    access_token = '2c307390e95843e38804f40ca8cac03e'
                    id_token     = $null
                    expires_in   = 15
                    token_type   = 'Bearer'
                }
            }

            $returnValue = Update-ArmorApiToken

            if ( $returnValue -eq $null ) {
                $returnType = 'System.Void'
            }
            else {
                $returnType = $returnValue.GetType().FullName
            }
            Assert-VerifiableMock
            Assert-MockCalled -CommandName Submit-ArmorApiRequest -Times 1

            $testCases = @(
                @{
                    FoundReturnType    = $returnType
                    ExpectedReturnType = 'System.Void'
                }
            )
            $testName = $Global:FORM_RETURN_TYPE
            It -Name $testName -TestCases $testCases -Test {
                param ( [String] $FoundReturnType, [String] $ExpectedReturnType )
                $FoundReturnType |
                    Should -Be $ExpectedReturnType
            }

            $testName = "has an 'OutputType' entry for <FoundReturnType>"
            It -Name $testName -TestCases $testCases -Test {
                param ( [String] $FoundReturnType, [String] $ExpectedReturnType )
                $FoundReturnType |
                    Should -BeIn ( Get-Help -Name Update-ArmorApiToken ).ReturnValues.ReturnValue.Type.Name
            }
        }
    }
}
