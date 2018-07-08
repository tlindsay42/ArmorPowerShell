Import-Module -Name $CI_MODULE_MANIFEST_PATH -Force

$systemUnderTest = ( Split-Path -Leaf $MyInvocation.MyCommand.Path ) -replace '\.Tests\.', '.'
$filePath = Join-Path -Path $CI_MODULE_PRIVATE_PATH -ChildPath $systemUnderTest

. $filePath

$function = $systemUnderTest.Split( '.' )[0]
$describe = $Global:FORM_FUNCTION_PRIVATE -f $function
Describe -Name $describe -Tag 'Function', 'Private', $function -Fixture {
    #region init
    $help = Get-Help -Name $function -Full
    $validKeys = 'code', 'grant_type', 'array', 'switch'
    $validParameters = [PSCustomObject] @{
        Code      = '+8oaKtcO9kuVbjUXlfnlHCY3HmXXCidHjzOBGwr+iTo='
        GrantType = 'authorization_code'
        Array     = 'test1', 'test2'
        Switch    = $true
    }

    function Test-FormatArmorApiRequestBody1 {
        param ( [String] $Code, [String] $GrantType, [String[]] $Array, [Switch] $Switch )
        Format-ArmorApiRequestBody -Keys $validKeys -Parameters $PSBoundParameters
    }
    #endregion

    $splat = @{
        ExpectedFunctionName = $function
        FoundFunctionName    = $help.Name
    }
    Test-AdvancedFunctionName @splat

    Test-AdvancedFunctionHelpMain -Help $help

    Test-AdvancedFunctionHelpInput -Help $help

    $splat = @{
        ExpectedOutputTypeNames = 'System.String'
        Help                    = $help
    }
    Test-AdvancedFunctionHelpOutput @splat

    $splat = @{
        ExpectedParameterNames = 'Keys', 'Parameters'
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
                Keys       = ''
                Parameters = $validParameters
            },
            @{
                Keys       = 'key1', ''
                Parameters = $validParameters
            },
            @{
                Keys       = $validKeys
                Parameters = ''
            },
            @{
                Keys       = $validKeys
                Parameters = @()
            },
            @{
                Keys       = $validKeys
                Parameters = 'parameter1', ''
            }
        )
        $testName = 'should fail when set to: Keys: <Keys>, Parameters: <Parameters> (named)'
        It -Name $testName -TestCases $testCases -Test {
            param ( [String[]] $Keys, [PSCustomObject[]] $Parameters )
            { Format-ArmorApiRequestBody -Keys $Keys -Parameters $Parameters } |
                Should -Throw
        }

        $testName = $testName -replace '\(named\)', '(positional)'
        It -Name $testName -TestCases $testCases -Test {
            param ( [String[]] $Keys, [PSCustomObject[]] $Parameters )
            { Format-ArmorApiRequestBody $Keys $Parameters } |
                Should -Throw
        }
    }
}
