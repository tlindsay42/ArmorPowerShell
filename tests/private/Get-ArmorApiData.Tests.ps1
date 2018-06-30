Import-Module -Name $CI_MODULE_MANIFEST_PATH -Force

$systemUnderTest = ( Split-Path -Leaf $MyInvocation.MyCommand.Path ) -replace '\.Tests\.', '.'
$filePath = Join-Path -Path $CI_MODULE_PRIVATE_PATH -ChildPath $systemUnderTest

. $filePath

$function = $systemUnderTest.Split( '.' )[0]
$describe = $Global:FORM_FUNCTION_PRIVATE -f $function
Describe -Name $describe -Tag 'Function', 'Private', $function -Fixture {
    #region init
    $help = Get-Help -Name $function -Full
    $validFunctionName = 'Example'
    $invalidFunctionName = 'Garbage'
    $validApiVersion = 'v1.0'

    [ArmorSession] $Global:ArmorSession = [ArmorSession]::New( 'api.armor.test', 443, $validApiVersion )
    #endregion

    $splat = @{
        ExpectedFunctionName = $function
        FoundFunctionName    = $help.Name
    }
    Test-AdvancedFunctionName @splat

    Test-AdvancedFunctionHelpMain -Help $help

    Test-AdvancedFunctionHelpInput -Help $help

    $splat = @{
        ExpectedOutputTypeNames = 'System.Management.Automation.PSObject[]', 'System.Management.Automation.PSObject', 'System.String[]', 'System.String'
        Help                    = $help
    }
    Test-AdvancedFunctionHelpOutput @splat

    $splat = @{
        ExpectedParameterNames = 'FunctionName', 'ApiVersion', 'ApiVersions'
        Help                   = $help
    }
    Test-AdvancedFunctionHelpParameter @splat

    $splat = @{
        ExpectedNotes = $Global:FORM_FUNCTION_HELP_NOTES
        Help          = $help
    }
    Test-AdvancedFunctionHelpNote @splat

    Context -Name $Global:EXECUTION -Fixture {
        $testCases = @(
            @{
                FunctionName = $invalidFunctionName
                ApiVersion   = $validApiVersion
            },
            @{
                FunctionName = $validFunctionName
                ApiVersion   = $invalidFunctionName
            },
            @{
                FunctionName = $validFunctionName
                ApiVersion   = 'v0.1'
            },
            @{
                FunctionName = ''
                ApiVersion   = $validApiVersion
            },
            @{
                FunctionName = $validFunctionName
                ApiVersion   = ''
            },
            @{
                FunctionName = $validFunctionName, $validFunctionName
                ApiVersion   = $validApiVersion
            },
            @{
                FunctionName = $validFunctionName
                ApiVersion   = $validApiVersion, $validApiVersion
            }
        )
        $testName = 'should fail when set to: FunctionName: <FunctionName>, ApiVersion: <ApiVersion>'
        It -Name $testName -TestCases $testCases -Test {
            param ( [String] $FunctionName, [String] $ApiVersion )
            { Get-ArmorApiData -FunctionName $FunctionName -ApiVersion $ApiVersion } |
                Should -Throw
        }


        $testCases = @(
            @{ FunctionName = $invalidFunctionName },
            @{ FunctionName = '' },
            @{ FunctionName = $validFunctionName, $validFunctionName }
        )
        $testName = 'should fail when set to: FunctionName: <FunctionName> (named)'
        It -Name $testName -TestCases $testCases -Test {
            param ( [String] $FunctionName )
            { Get-ArmorApiData -FunctionName $FunctionName } |
                Should -Throw
        }

        $testName = $testName -replace '\(named\)', '(positional)'
        It -Name $testName -TestCases $testCases -Test {
            param ( [String] $FunctionName )
            { Get-ArmorApiData $FunctionName } |
                Should -Throw
        }

        $testName = $testName -replace '\(named\)', '(pipeline by value)'
        It -Name $testName -TestCases $testCases -Test {
            param ( [String] $FunctionName )
            { $FunctionName | Get-ArmorApiData } |
                Should -Throw
        }

        $testCases = @(
            @{ ApiVersion   = $validFunctionName },
            @{ ApiVersion   = 'v0.1' },
            @{ ApiVersion   = '' },
            @{ ApiVersion   = $validApiVersion, $validApiVersion }
        )
        $testName = 'should fail when set to: ApiVersion: <ApiVersion>'
        It -Name $testName -TestCases $testCases -Test {
            param ( [String] $ApiVersion )
              { Get-ArmorApiData -FunctionName $validFunctionName -ApiVersion $ApiVersion } |
                Should -Throw
        }

        $testName = $testName -replace '\(named\)', '(positional)'
        It -Name $testName -TestCases $testCases -Test {
            param ( [String] $ApiVersion )
            { Get-ArmorApiData $validFunctionName $ApiVersion } |
                Should -Throw
        }

        $testCases = @(
            @{
                FunctionName = $validFunctionName
                ApiVersion   = $validApiVersion
            }
        )
        $testName = 'should not fail when set to: FunctionName: <FunctionName>, ApiVersion: <ApiVersion> (named)'
        It -Name $testName -TestCases $testCases -Test {
            param ( [String] $FunctionName, [String] $ApiVersion )
            { Get-ArmorApiData -FunctionName $FunctionName -ApiVersion $ApiVersion } |
                Should -Not -Throw
        }

        $testName = $testName -replace '\(named\)', '(positional)'
        It -Name $testName -TestCases $testCases -Test {
            param ( [String] $FunctionName, [String] $ApiVersion )
            { Get-ArmorApiData $FunctionName $ApiVersion } |
                Should -Not -Throw
        }

        $testName = $testName -replace '\(positional\)', '(pipeline by value)'
        It -Name $testName -TestCases $testCases -Test {
            param ( [String] $FunctionName, [String] $ApiVersion )
            { $FunctionName | Get-ArmorApiData } |
                Should -Not -Throw
        }

        $testCases = @(
            @{ FunctionName = $invalidFunctionName },
            @{ FunctionName = '' },
            @{ FunctionName = $validFunctionName, $validFunctionName }
        )
        $testName = 'should fail when set to: FunctionName: <FunctionName>, ApiVersions: $true'
        It -Name $testName -TestCases $testCases -Test {
            param ( [String] $FunctionName )
            { Get-ArmorApiData -FunctionName $FunctionName -ApiVersions } |
                Should -Throw
        }

        $testCases = @(
            @{ FunctionName = $validFunctionName }
        )
        $testName = 'should not fail when set to: FunctionName: <FunctionName>, ApiVersions: $true'
        It -Name $testName -TestCases $testCases -Test {
            param ( [String] $FunctionName )
            { Get-ArmorApiData -FunctionName $FunctionName -ApiVersions } |
                Should -Not -Throw
        }
    }

    Context -Name $Global:RETURN_TYPE_CONTEXT -Fixture {
        $testCases = @(
            @{
                FoundReturnType    = ( Get-ArmorApiData -FunctionName $validFunctionName -ApiVersion $validApiVersion -ErrorAction 'Stop' ).GetType().FullName
                ExpectedReturnType = 'System.Management.Automation.PSCustomObject'
            },
            @{
                FoundReturnType    = ( Get-ArmorApiData -FunctionName $validFunctionName -ApiVersions -ErrorAction 'Stop' ).GetType().FullName
                ExpectedReturnType = 'System.String'
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
                Should -BeIn ( $help.ReturnValues.ReturnValue.Type.Name + $ExpectedReturnType )
        }
    }
}
