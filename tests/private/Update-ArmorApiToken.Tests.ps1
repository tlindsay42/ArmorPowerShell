Import-Module -Name $env:CI_MODULE_MANIFEST_PATH -Force

$systemUnderTest = ( Split-Path -Leaf $MyInvocation.MyCommand.Path ) -replace '\.Tests\.', '.'
$filePath = Join-Path -Path $env:CI_MODULE_PRIVATE_PATH -ChildPath $systemUnderTest

. $filePath

$function = $systemUnderTest.Split( '.' )[0]
$describe = $Global:PrivateFunctionForm -f $function
Describe -Name $describe -Tag 'Function', 'Private', $function -Fixture {
    #region init
    $help = Get-Help -Name $function -Full
    #endregion

    $splat = @{
        'ExpectedFunctionName' = $function
        'FoundFunctionName'    = $help.Name
    }
    TestAdvancedFunctionName @splat

    TestAdvancedFunctionHelpMain -Help $help

    TestAdvancedFunctionHelpInputs -Help $help

    $splat = @{
        'ExpectedOutputTypeNames' = 'System.Void'
        'Help'                    = $help
    }
    TestAdvancedFunctionHelpOutputs @splat

    $splat = @{
        'ExpectedParameterNames' = 'Token', 'ApiVersion'
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
            $validToken = 'd4641394719f4513a80f25de11a85138'
            $validApiVersion = 'v1.0'
            #endregion

            Mock -CommandName Submit-ArmorApiRequest -Verifiable -MockWith {
                @{
                    'redirect_uri' = $null
                    'code'         = ''
                    'success'      = 'true'
                }
            }

            $testCases = @(
                @{
                    'Token'      = ''
                    'ApiVersion' = $validApiVersion
                },
                @{
                    'Token'      = 'efa32575460946e'
                    'ApiVersion' = $validApiVersion
                },
                @{
                    'Token'      = $validToken
                    'ApiVersion' = '1.0'
                }
            )
            $testName = 'should fail when Token: <Token> ApiVersion: <ApiVersion>'
            It -Name $testName -TestCases $testCases -Test {
                param ( [String] $Token, [String] $ApiVersion )
                { Update-ArmorApiToken -Token $Token -ApiVersion $ApiVersion } |
                    Should -Throw
            } # End of It
            Assert-VerifiableMock
            Assert-MockCalled -CommandName Submit-ArmorApiRequest -Times 1
        } # End of InModuleScope
    } # End of Context
} # End of Describe
