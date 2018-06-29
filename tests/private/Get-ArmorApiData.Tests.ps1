Import-Module -Name $Env:CI_MODULE_MANIFEST_PATH -Force

$systemUnderTest = ( Split-Path -Leaf $MyInvocation.MyCommand.Path ) -replace '\.Tests\.', '.'
$filePath = Join-Path -Path $Env:CI_MODULE_PRIVATE_PATH -ChildPath $systemUnderTest

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

    Context -Name $Global:Execution -Fixture {
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
        }

        $testCases = @(
            @{
                'FunctionName' = $validFunctionName
                'ApiVersion'   = $validApiVersion
            }
        )
        $testName = 'should not fail when set to: FunctionName: <FunctionName>, ApiVersion: <ApiVersion>'
        It -Name $testName -TestCases $testCases -Test {
            param ( [String] $FunctionName, [String] $ApiVersion )
            { Get-ArmorApiData -FunctionName $FunctionName -ApiVersion $ApiVersion } |
                Should -Not -Throw
        }

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
        }

        $testCases = @(
            @{ 'FunctionName' = $validFunctionName }
        )
        $testName = 'should not fail when set to: FunctionName: <FunctionName>, ApiVersions: $true'
        It -Name $testName -TestCases $testCases -Test {
            param ( [String] $FunctionName )
            { Get-ArmorApiData -FunctionName $FunctionName -ApiVersions } |
                Should -Not -Throw
        }
    }

    Context -Name $Global:ReturnTypeContext -Fixture {
        $testCases = @(
            @{
                'FoundReturnType'    = ( Get-ArmorApiData -FunctionName $validFunctionName -ApiVersion $validApiVersion -ErrorAction 'Stop' ).GetType().FullName
                'ExpectedReturnType' = 'System.Management.Automation.PSCustomObject'
            },
            @{
                'FoundReturnType'    = ( Get-ArmorApiData -FunctionName $validFunctionName -ApiVersions -ErrorAction 'Stop' ).GetType().FullName
                'ExpectedReturnType' = 'System.String'
            }
        )
        $testName = $Global:ReturnTypeForm
        It -Name $testName -TestCases $testCases -Test {
            param ( [String] $FoundReturnType, [String] $ExpectedReturnType )
            $FoundReturnType |
                Should -Be $ExpectedReturnType
        }

        # $testName = "has an 'OutputType' entry for <FoundReturnType>"
        # It -Name $testName -TestCases $testCases -Test {
        #     param ( [String] $FoundReturnType )
        #     $FoundReturnType |
        #         Should -BeIn $help.ReturnValues.ReturnValue.Type.Name
        # }
    }
}
