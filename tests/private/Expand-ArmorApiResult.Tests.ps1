Import-Module -Name $CI_MODULE_MANIFEST_PATH -Force

$systemUnderTest = ( Split-Path -Leaf $MyInvocation.MyCommand.Path ) -replace '\.Tests\.', '.'
$filePath = Join-Path -Path $CI_MODULE_PRIVATE_PATH -ChildPath $systemUnderTest

. $filePath

$function = $systemUnderTest.Split( '.' )[0]
$describe = $Global:FORM_FUNCTION_PRIVATE -f $function
Describe -Name $describe -Tag 'Function', 'Private', $function -Fixture {
    #region init
    $help = Get-Help -Name $function -Full
    $validResults = @(
        [PSCustomObject] @{ Data = [PSCustomObject] @{ Desired = 'Result1' } },
        [PSCustomObject] @{ Data = [PSCustomObject] @{ Desired = 'Result2' } }
    )
    $invalidLocation = ''
    $validLocation = 'Data'
    #endregion

    $splat = @{
        ExpectedFunctionName = $function
        FoundFunctionName    = $help.Name
    }
    Test-AdvancedFunctionName @splat

    Test-AdvancedFunctionHelpMain -Help $help

    Test-AdvancedFunctionHelpInput -Help $help

    $splat = @{
        ExpectedOutputTypeNames = 'System.Management.Automation.PSObject', 'System.Management.Automation.PSObject[]'
        Help                    = $help
    }
    Test-AdvancedFunctionHelpOutput @splat

    $splat = @{
        ExpectedParameterNames = 'Results', 'Location'
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

        $testCases = @(
            @{
                Results  = $null
                Location = $validLocation
            },
            @{
                Results  = @()
                Location = $invalidLocation
            },
            @{
                Results  = $validResults[0]
                Location = $invalidLocation
            },
            @{
                Results  = $validResults
                Location = $invalidLocation
            }
        )
        $testName = 'should fail when set to: Results: <Results>, Location: <Location>'
        It -Name $testName -TestCases $testCases -Test {
            param ( [PSCustomObject[]] $Results, [String] $Location )
            { Expand-ArmorApiResult -Results $Results -Location $Location } |
                Should -Throw
        }

        $testCases = @(
            @{
                Results  = $validResults
                Location = $validLocation
            }
        )
        $testName = 'should not fail when set to: Results: <Results>, Location: <Location>'
        It -Name $testName -TestCases $testCases -Test {
            param ( [PSCustomObject[]] $Results, [String] $Location )
            { Expand-ArmorApiResult -Results $Results -Location $Location } |
                Should -Not -Throw
        }

    }

    Context -Name $Global:RETURN_TYPE_CONTEXT -Fixture {
        #region init
        $splat = @{
            Results  = [PSCustomObject] @{ Data = [PSCustomObject] @{ Desired = 'Result1' } }
            Location = 'Data'
        }
        #endregion

        $testCases = @(
            @{
                FoundReturnType    = ( Expand-ArmorApiResult @splat ).GetType().FullName
                ExpectedReturnType = 'System.Management.Automation.PSCustomObject'
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
                Should -BeIn ( Get-Help -Name 'Expand-ArmorApiResult' ).ReturnValues.ReturnValue.Type.Name
        }
    }
}
