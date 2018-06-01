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
        'ExpectedOutputTypeNames' = 'ArmorUser', 'ArmorUser[]'
        'Help'                    = $help
    }
    TestAdvancedFunctionHelpOutputs @splat

    $splat = @{
        'ExpectedParameterNames' = 'ID', 'UserName', 'FirstName', 'LastName', 'ApiVersion'
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
            $validUserName = 'user.name@example.com'
            $validFirstName = 'User'
            $validLastName = 'Name'
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
                { Get-ArmorUser -ID $ID -ApiVersion $ApiVersion } |
                    Should -Throw
            } # End of It

            $testCases = @(
                @{
                    'UserName'   = ''
                    'ApiVersion' = $validApiVersion
                },
                @{
                    'UserName'   = 'garbage@garbage.com'
                    'ApiVersion' = $validApiVersion
                },
                @{
                    'UserName'   = $validUserName
                    'ApiVersion' = $invalidApiVersion
                }
            )
            $testName = 'should fail when set to: UserName: <UserName>, ApiVersion: <ApiVersion>'
            It -Name $testName -TestCases $testCases -Test {
                param ( [String] $UserName, [String] $ApiVersion )
                { Get-ArmorUser -UserName $UserName -ApiVersion $ApiVersion -Verbose -ErrorAction 'Stop' } |
                    Should -Throw
            } # End of It

            $testCases = @(
                @{
                    'FirstName'  = ''
                    'LastName'  = $validLastName
                    'ApiVersion' = $validApiVersion
                },
                @{
                    'FirstName'  = 'Name'
                    'LastName'   = 'NotFound'
                    'ApiVersion' = $validApiVersion
                },
                @{
                    'FirstName'  = $validFirstName
                    'LastName'   = ''
                    'ApiVersion' = $validApiVersion
                },
                @{
                    'FirstName'  = $validFirstName
                    'LastName'   = $validLastName
                    'ApiVersion' = $invalidApiVersion
                }
            )
            $testName = 'should fail when set to: FirstName: <FirstName>, LastName: <LastName>, ApiVersion: <ApiVersion>'
            It -Name $testName -TestCases $testCases -Test {
                param ( [String] $FirstName, [String] $LastName, [String] $ApiVersion )
                { Get-ArmorUser -FirstName $FirstName -LastName $LastName -ApiVersion $ApiVersion } |
                    Should -Throw
            } # End of It

            Mock -CommandName Test-ArmorSession -Verifiable -MockWith {}
            Mock -CommandName Invoke-WebRequest -Verifiable -MockWith {
                @{
                    'StatusCode'        = 200
                    'StatusDescription' = 'OK'
                    'Content'           = $Global:JsonResponseBody.Users1
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
                { Get-ArmorUser -ID $ID -ApiVersion $ApiVersion } |
                    Should -Not -Throw
            } # End of It
            Assert-VerifiableMock
            Assert-MockCalled -CommandName Test-ArmorSession -Times $testCases.Count
            Assert-MockCalled -CommandName Invoke-WebRequest -Times $testCases.Count

            $testCases = @(
                @{
                    'UserName'   = $validUserName
                    'ApiVersion' = $validApiVersion
                }
            )
            $testName = 'should not fail when set to: UserName: <UserName>, ApiVersion: <ApiVersion>'
            It -Name $testName -TestCases $testCases -Test {
                param ( [String] $UserName, [String] $ApiVersion )
                { Get-ArmorUser -UserName $UserName -ApiVersion $ApiVersion } |
                    Should -Not -Throw
            } # End of It
            Assert-VerifiableMock
            Assert-MockCalled -CommandName Test-ArmorSession -Times $testCases.Count
            Assert-MockCalled -CommandName Invoke-WebRequest -Times $testCases.Count

            $testCases = @(
                @{
                    'FirstName'  = $validFirstName
                    'LastName'   = $validLastName
                    'ApiVersion' = $validApiVersion
                }
            )
            $testName = 'should not fail when set to: FirstName: <FirstName>, LastName: <LastName>, ApiVersion: <ApiVersion>'
            It -Name $testName -TestCases $testCases -Test {
                param ( [String] $FirstName, [String] $LastName, [String] $ApiVersion )
                { Get-ArmorUser -FirstName $FirstName -LastName $LastName -ApiVersion $ApiVersion } |
                    Should -Not -Throw
            } # End of It
            Assert-VerifiableMock
            Assert-MockCalled -CommandName Test-ArmorSession -Times $testCases.Count
            Assert-MockCalled -CommandName Invoke-WebRequest -Times $testCases.Count
        } # End of InModuleScope
    } # End of Context

    Context -Name $Global:ReturnTypeContext -Fixture {
        InModuleScope -ModuleName $Env:CI_MODULE_NAME -ScriptBlock {
            #region init
            $validApiVersion = 'v1.0'
            #endregion

            Mock -CommandName Test-ArmorSession -Verifiable -MockWith {}
            Mock -CommandName Invoke-WebRequest -Verifiable -MockWith {
                @{
                    'StatusCode'        = 200
                    'StatusDescription' = 'OK'
                    'Content'           = $Global:JsonResponseBody.Users1
                }
            }

            $testCases = @(
                @{
                    'FoundReturnType'    = ( Get-ArmorUser -ID 1 -ApiVersion $validApiVersion -ErrorAction 'Stop' ).GetType().FullName
                    'ExpectedReturnType' = 'ArmorUser'
                },
                @{
                    'FoundReturnType'    = ( Get-ArmorUser -UserName 'user.name@example.com' -ApiVersion $validApiVersion -ErrorAction 'Stop' ).GetType().FullName
                    'ExpectedReturnType' = 'ArmorUser'
                }
                @{
                    'FoundReturnType'    = ( Get-ArmorUser -FirstName 'User' -LastName 'Name' -ApiVersion $validApiVersion -ErrorAction 'Stop' ).GetType().FullName
                    'ExpectedReturnType' = 'ArmorUser'
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
            #         Should -BeIn ( Get-Help -Name 'Get-ArmorUser' -Full ).ReturnValues.ReturnValue.Type.Name
            # } # End of It
        } # End of InModuleScope
    } # End of Context
} # End of Describe
