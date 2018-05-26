Remove-Module -Name "${env:CI_MODULE_NAME}*" -ErrorAction 'SilentlyContinue'
Import-Module -Name $env:CI_MODULE_MANIFEST_PATH -Force

$systemUnderTest = ( Split-Path -Leaf $MyInvocation.MyCommand.Path ) -replace '\.Tests\.', '.'
$filePath = Join-Path -Path $env:CI_MODULE_PRIVATE_PATH -ChildPath $systemUnderTest

. $filePath

$function = $systemUnderTest.Split( '.' )[0]
$describe = $Global:PrivateFunctionForm -f $function
Describe -Name $describe -Tag 'Function', 'Private', $function -Fixture {
    #region init
    $help = Get-Help -Name $function -Full
    $validFunctionName = 'Example'
    $invalidFunctionName = 'Garbage'
    $validApiVersion = 'v1.0'
    #endregion

    $splat = @{
        'ExpectedFunctionName' = $function
        'FoundFunctionName'    = $help.Name
        }
    TestAdvancedFunctionName @splat

    TestAdvancedFunctionHelpMain -Help $help

    TestAdvancedFunctionHelpInputs -Help $help

    $splat = @{
        'ExpectedOutputTypeNames' = 'System.Management.Automation.PSObject', 'System.String[]'
        'Help'                    = $help
        }
    TestAdvancedFunctionHelpOutputs @splat

    $splat = @{
        'ExpectedParameterNames' = 'FunctionName', 'ApiVersion', 'ApiVersions'
        'Help'                   = $help
    }
    TestAdvancedFunctionHelpParameters @splat

    $splat = @{
        'ExpectedNotes' = $Global:FunctionHelpNotes
        'Help'          = $help
        }
    TestAdvancedFunctionHelpNotes @splat

    Context -Name 'Parameters' -Fixture {
        $value = 3
        $testName = $Global:FunctionParameterCountForm -f $value
        It -Name $testName -TestCases $testCases -Test {
            $help.Parameters.Parameter.Count |
                Should -Be $value
        } # End of It

        $testCases = @(
            @{ 'Name' = 'FunctionName' },
            @{ 'Name' = 'ApiVersion' },
            @{ 'Name' = 'ApiVersions' }
        )
        $testName = $Global:FunctionParameterNameForm
        It -Name $testName -TestCases $testCases -Test {
            param ( [String] $Name )
            $Name |
                Should -BeIn $help.Parameters.Parameter.Name
        } # End of It
    } # End of Context

    Context -Name 'Execution' -Fixture {
        $testCases = @(
            @{
                'FunctionName' = $invalidFunctionName
                'ApiVersion'   = $validApiVersion
            },
            @{
                'FunctionName' = $validFunctionName
                'ApiVersion'   = $invalidFunctionName
            },
            @{
                'FunctionName' = $validFunctionName
                'ApiVersion'   = 'v0.1'
            },
            @{
                'FunctionName' = ''
                'ApiVersion'   = $validApiVersion
            },
            @{
                'FunctionName' = $validFunctionName
                'ApiVersion'   = ''
            },
            @{
                'FunctionName' = $validFunctionName, $validFunctionName
                'ApiVersion'   = $validApiVersion
            },
            @{
                'FunctionName' = $validFunctionName
                'ApiVersion'   = $validApiVersion, $validApiVersion
            }
        )
        $testName = 'should fail when set to: FunctionName: <FunctionName>, ApiVersion: <ApiVersion>'
        It -Name $testName -TestCases $testCases -Test {
            param ( [String] $FunctionName, [String] $ApiVersion )
            { Get-ArmorApiData -FunctionName $FunctionName -ApiVersion $ApiVersion } |
                Should -Throw
        } # End of It

        $testCases = @(
            @{ 'FunctionName' = $invalidFunctionName },
            @{ 'FunctionName' = '' },
            @{ 'FunctionName' = $validFunctionName, $validFunctionName }
        )
        $testName = 'should fail when set to: FunctionName: <FunctionName>, ApiVersions: $true'
        It -Name $testName -TestCases $testCases -Test {
            param ( [String] $FunctionName )
            { Get-ArmorApiData -FunctionName $FunctionName -ApiVersions } |
                Should -Throw
        } # End of It

        $testCases = @(
            @{
                'FunctionName' = $validFunctionName
                'ApiVersion'   = $validApiVersion
            }
        )
        $testName = $Global:ReturnTypeForm
        It -Name $testName -TestCases $testCases -Test {
            param ( [String] $FunctionName, [String] $ApiVersion )
            Get-ArmorApiData -FunctionName $FunctionName -ApiVersion $ApiVersion |
                Should -BeOfType ( [PSCustomObject] )
        } # End of It

        $testCases = @(
            @{ 'FunctionName' = $validFunctionName }
        )
        $testName = $Global:ReturnTypeForm
        It -Name $testName -TestCases $testCases -Test {
            param ( [String] $FunctionName )
            Get-ArmorApiData -FunctionName $FunctionName -ApiVersions |
                Should -BeOfType ( [String] )
        } # End of It
    } # End of Context
} # End of Describe
