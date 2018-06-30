Import-Module -Name $CI_MODULE_MANIFEST_PATH -Force

$systemUnderTest = ( Split-Path -Leaf $MyInvocation.MyCommand.Path ) -replace '\.Tests\.', '.'

$function = $systemUnderTest.Split( '.' )[0]
$describe = $Global:FORM_FUNCTION_PUBLIC -f $function
Describe -Name $describe -Tag 'Function', 'Public', $function -Fixture {
    #region init
    $help = Get-Help -Name $function -Full

    $Global:ArmorSession = [ArmorSession]::New( 'api.armor.com', 443, 'v1.0' )
    #endregion

    $splat = @{
        ExpectedFunctionName = $function
        FoundFunctionName    = $help.Name
    }
    Test-AdvancedFunctionName @splat

    Test-AdvancedFunctionHelpMain -Help $help

    Test-AdvancedFunctionHelpInput -Help $help

    $splat = @{
        ExpectedOutputTypeNames = 'ArmorUser', 'ArmorUser[]'
        Help                    = $help
    }
    Test-AdvancedFunctionHelpOutput @splat

    $splat = @{
        ExpectedParameterNames = 'ID', 'UserName', 'FirstName', 'LastName', 'ApiVersion'
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
            $invalidID = 0
            $validID = 1
            $validUserName = 'user.name@example.com'
            $validFirstName = 'User'
            $validLastName = 'Name'
            $invalidApiVersion = 'v0.0'
            $validApiVersion = 'v1.0'
            #endregion

            $testCases = @(
                @{
                    ID         = $invalidID
                    ApiVersion = $validApiVersion
                },
                @{
                    ID         = $validID
                    ApiVersion = $invalidApiVersion
                }
            )
            $testName = 'should fail when set to: ID: <ID>, ApiVersion: <ApiVersion>'
            It -Name $testName -TestCases $testCases -Test {
                param ( [String] $ID, [String] $ApiVersion )
                { Get-ArmorUser -ID $ID -ApiVersion $ApiVersion } |
                    Should -Throw
            }

            $testCases = @(
                @{
                    UserName   = ''
                    ApiVersion = $validApiVersion
                },
                @{
                    UserName   = $validUserName
                    ApiVersion = $invalidApiVersion
                }
            )
            $testName = 'should fail when set to: UserName: <UserName>, ApiVersion: <ApiVersion>'
            It -Name $testName -TestCases $testCases -Test {
                param ( [String] $UserName, [String] $ApiVersion )
                { Get-ArmorUser -UserName $UserName -ApiVersion $ApiVersion -ErrorAction 'Stop' } |
                    Should -Throw
            }

            $testCases = @(
                @{
                    FirstName  = ''
                    LastName  = $validLastName
                    ApiVersion = $validApiVersion
                },
                @{
                    FirstName  = $validFirstName
                    LastName   = ''
                    ApiVersion = $validApiVersion
                },
                @{
                    FirstName  = $validFirstName
                    LastName   = $validLastName
                    ApiVersion = $invalidApiVersion
                }
            )
            $testName = 'should fail when set to: FirstName: <FirstName>, LastName: <LastName>, ApiVersion: <ApiVersion>'
            It -Name $testName -TestCases $testCases -Test {
                param ( [String] $FirstName, [String] $LastName, [String] $ApiVersion )
                { Get-ArmorUser -FirstName $FirstName -LastName $LastName -ApiVersion $ApiVersion } |
                    Should -Throw
            }

            Mock -CommandName Test-ArmorSession -Verifiable -MockWith {}
            Mock -CommandName Invoke-WebRequest -Verifiable -MockWith {
                @{
                    StatusCode        = 200
                    StatusDescription = 'OK'
                    Content           = $Global:JSON_RESPONSE_BODY.Users1
                }
            }

            $testCases = @(
                @{
                    UserName   = 'pwnd@kobayashi.maru'
                    ApiVersion = $validApiVersion
                }
            )
            $testName = 'should fail when set to: UserName: <UserName>, ApiVersion: <ApiVersion>'
            It -Name $testName -TestCases $testCases -Test {
                param ( [String] $UserName, [String] $ApiVersion )
                { Get-ArmorUser -UserName $UserName -ApiVersion $ApiVersion -ErrorAction 'Stop' } |
                    Should -Throw
            }
            Assert-VerifiableMock
            Assert-MockCalled -CommandName Test-ArmorSession -Times $testCases.Count
            Assert-MockCalled -CommandName Invoke-WebRequest -Times $testCases.Count

            $testCases = @(
                @{
                    FirstName  = 'Locutus'
                    LastName   = $validLastName
                    ApiVersion = $validApiVersion
                },
                @{
                    FirstName  = $validFirstName
                    LastName   = 'Rozhenko'
                    ApiVersion = $validApiVersion
                },
                @{
                    FirstName  = 'Noonien'
                    LastName   = 'Soong'
                    ApiVersion = $validApiVersion
                }
            )
            $testName = 'should fail when set to: FirstName: <FirstName>, LastName: <LastName>, ApiVersion: <ApiVersion>'
            It -Name $testName -TestCases $testCases -Test {
                param ( [String] $FirstName, [String] $LastName, [String] $ApiVersion )
                { Get-ArmorUser -FirstName $FirstName -LastName $LastName -ApiVersion $ApiVersion -ErrorAction 'Stop' } |
                    Should -Throw
            }
            Assert-VerifiableMock
            Assert-MockCalled -CommandName Test-ArmorSession -Times $testCases.Count
            Assert-MockCalled -CommandName Invoke-WebRequest -Times $testCases.Count

            $testCases = @(
                @{
                    ID         = $validID
                    ApiVersion = $validApiVersion
                }
            )
            $testName = 'should not fail when set to: ID: <ID>, ApiVersion: <ApiVersion>'
            It -Name $testName -TestCases $testCases -Test {
                param ( [String] $ID, [String] $ApiVersion )
                { Get-ArmorUser -ID $ID -ApiVersion $ApiVersion } |
                    Should -Not -Throw
            }
            Assert-VerifiableMock
            Assert-MockCalled -CommandName Test-ArmorSession -Times $testCases.Count
            Assert-MockCalled -CommandName Invoke-WebRequest -Times $testCases.Count

            $testCases = @(
                @{
                    UserName   = $validUserName
                    ApiVersion = $validApiVersion
                }
            )
            $testName = 'should not fail when set to: UserName: <UserName>, ApiVersion: <ApiVersion>'
            It -Name $testName -TestCases $testCases -Test {
                param ( [String] $UserName, [String] $ApiVersion )
                { Get-ArmorUser -UserName $UserName -ApiVersion $ApiVersion } |
                    Should -Not -Throw
            }
            Assert-VerifiableMock
            Assert-MockCalled -CommandName Test-ArmorSession -Times $testCases.Count
            Assert-MockCalled -CommandName Invoke-WebRequest -Times $testCases.Count

            $testCases = @(
                @{
                    FirstName  = $validFirstName
                    LastName   = $validLastName
                    ApiVersion = $validApiVersion
                }
            )
            $testName = 'should not fail when set to: FirstName: <FirstName>, LastName: <LastName>, ApiVersion: <ApiVersion>'
            It -Name $testName -TestCases $testCases -Test {
                param ( [String] $FirstName, [String] $LastName, [String] $ApiVersion )
                { Get-ArmorUser -FirstName $FirstName -LastName $LastName -ApiVersion $ApiVersion } |
                    Should -Not -Throw
            }
            Assert-VerifiableMock
            Assert-MockCalled -CommandName Test-ArmorSession -Times $testCases.Count
            Assert-MockCalled -CommandName Invoke-WebRequest -Times $testCases.Count
        }
    }

    Context -Name $Global:RETURN_TYPE_CONTEXT -Fixture {
        InModuleScope -ModuleName $Global:CI_MODULE_NAME -ScriptBlock {
            #region init
            $validApiVersion = 'v1.0'
            #endregion

            Mock -CommandName Test-ArmorSession -Verifiable -MockWith {}
            Mock -CommandName Invoke-WebRequest -Verifiable -MockWith {
                @{
                    StatusCode        = 200
                    StatusDescription = 'OK'
                    Content           = $Global:JSON_RESPONSE_BODY.Users1
                }
            }

            $testCases = @(
                @{
                    FoundReturnType    = ( Get-ArmorUser -ID 1 -ApiVersion $validApiVersion -ErrorAction 'Stop' ).GetType().FullName
                    ExpectedReturnType = 'ArmorUser'
                },
                @{
                    FoundReturnType    = ( Get-ArmorUser -UserName 'user.name@example.com' -ApiVersion $validApiVersion -ErrorAction 'Stop' ).GetType().FullName
                    ExpectedReturnType = 'ArmorUser'
                }
                @{
                    FoundReturnType    = ( Get-ArmorUser -FirstName 'User' -LastName 'Name' -ApiVersion $validApiVersion -ErrorAction 'Stop' ).GetType().FullName
                    ExpectedReturnType = 'ArmorUser'
                }
            )
            $testName = $Global:FORM_RETURN_TYPE
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
