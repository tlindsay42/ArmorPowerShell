Import-Module -Name $CI_MODULE_MANIFEST_PATH -Force

$systemUnderTest = ( Split-Path -Leaf $MyInvocation.MyCommand.Path ) -replace '\.Tests\.', '.'
$filePath = Join-Path -Path $CI_MODULE_PRIVATE_PATH -ChildPath $systemUnderTest

. $filePath

$function = $systemUnderTest.Split( '.' )[0]
$describe = $Global:FORM_FUNCTION_PRIVATE -f $function
Describe -Name $describe -Tag 'Function', 'Private', $function -Fixture {
    #region init
    $help = Get-Help -Name $function -Full
    $validAuthorization = 'FH-AUTH d4641394719f4513a80f25de11a85138'
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
        ExpectedParameterNames = @()
        Help                   = $help
    }
    Test-AdvancedFunctionHelpParameter @splat

    $splat = @{
        ExpectedNotes = $Global:FORM_FUNCTION_HELP_NOTES
        Help          = $help
    }
    Test-AdvancedFunctionHelpNote @splat

    Context -Name $Global:EXECUTION -Fixture {
        #region init
        #endregion

        [ArmorSession] $Global:ArmorSession = $null
        $testName = 'should fail when the $Global:ArmorSession is $null'
        It -Name $testName -Test {
            { Test-ArmorSession } |
                Should -Throw
        }

        $testCases = @(
            @{
                Session       = [ArmorSession]::New()
                Authorization = ''
            },
            @{
                Session       = $Global:JSON_RESPONSE_BODY.Session1 |
                    ConvertFrom-Json -ErrorAction 'Stop'
                Authorization = 'FH-AUTH efa32575460946e'
            },
            @{
                Session       = $Global:JSON_RESPONSE_BODY.Session1 |
                    ConvertFrom-Json -ErrorAction 'Stop'
                Authorization = 'Bearer d4641394719f4513a80f25de11a85138'
            }
        )
        $testName = 'should fail when the session authorization is: <Authorization>'
        It -Name $testName -TestCases $testCases -Test {
            param ( [PSCustomObject] $Session, [String] $Authorization )
            {
                [ArmorSession] $Global:ArmorSession = $Session
                $Global:ArmorSession.Headers.Authorization = $Authorization
                Test-ArmorSession
            } |
                Should -Throw
        }

        [ArmorSession] $Global:ArmorSession = $Global:JSON_RESPONSE_BODY.Session1 |
            ConvertFrom-Json -ErrorAction 'Stop'
        $Global:ArmorSession.Headers.Authorization = $validAuthorization
        $testName = "should fail when the session expired at: '$( $Global:ArmorSession.SessionExpirationTime )'"
        It -Name $testName -Test {
            { Test-ArmorSession } |
                Should -Throw
        }

        InModuleScope -ModuleName $Global:CI_MODULE_NAME -ScriptBlock {
            Mock -CommandName Update-ArmorApiToken -Verifiable -MockWith {}

            [ArmorSession] $Global:ArmorSession = $Global:JSON_RESPONSE_BODY.Session1 |
                ConvertFrom-Json -ErrorAction 'Stop'
            $Global:ArmorSession.Headers.Authorization = 'FH-AUTH d4641394719f4513a80f25de11a85138'
            $Global:ArmorSession.SessionExpirationTime = ( Get-Date ).AddMinutes( ( $Global:ArmorSession.SessionLengthInMinutes * ( 1 / 3 ) ) )
            $testName = "should not fail and renew the session when it expires at: '$( $Global:ArmorSession.SessionExpirationTime )'"
            It -Name $testName -Test {
                { Test-ArmorSession } |
                    Should -Not -Throw
            }
            Assert-VerifiableMock
            Assert-MockCalled -CommandName Update-ArmorApiToken -Times 1
        }

        [ArmorSession] $Global:ArmorSession = $Global:JSON_RESPONSE_BODY.Session1 |
            ConvertFrom-Json -ErrorAction 'Stop'
        $Global:ArmorSession.Headers.Authorization = $validAuthorization
        $Global:ArmorSession.SessionExpirationTime = ( Get-Date ).AddMinutes( $Global:ArmorSession.SessionLengthInMinutes )
        $testName = "should not fail when the session expires at: '$( $Global:ArmorSession.SessionExpirationTime )'"
        It -Name $testName -Test {
            { Test-ArmorSession } |
                Should -Not -Throw
        }
    }

    Context -Name $Global:RETURN_TYPE_CONTEXT -Fixture {
        #region init
        $returnValue = $null
        $returnType = $null

        [ArmorSession] $Global:ArmorSession = $Global:JSON_RESPONSE_BODY.Session1 |
            ConvertFrom-Json -ErrorAction 'Stop'
        $Global:ArmorSession.Headers.Authorization = $validAuthorization
        $Global:ArmorSession.SessionExpirationTime = ( Get-Date ).AddMinutes( $Global:ArmorSession.SessionLengthInMinutes )

        $returnValue = Test-ArmorSession
        #endregion

        if ( $returnValue -eq $null ) {
            $returnType = 'System.Void'
        }
        else {
            $returnType = $returnValue.GetType().FullName
        }

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
            param ( [String] $FoundReturnType )
            $FoundReturnType |
                Should -BeIn $help.ReturnValues.ReturnValue.Type.Name
        }
    }
}
