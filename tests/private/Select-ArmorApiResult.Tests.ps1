Import-Module -Name $CI_MODULE_MANIFEST_PATH -Force

$systemUnderTest = ( Split-Path -Leaf $MyInvocation.MyCommand.Path ) -replace '\.Tests\.', '.'
$filePath = Join-Path -Path $CI_MODULE_PRIVATE_PATH -ChildPath $systemUnderTest

. $filePath

$function = $systemUnderTest.Split( '.' )[0]
$describe = $Global:FORM_FUNCTION_PRIVATE -f $function
Describe -Name $describe -Tag 'Function', 'Private', $function -Fixture {
    #region init
    $help = Get-Help -Name $function -Full
    $name = 'TROY-TEST*'

    function Test-SelectArmorApiResult1 {
        param ( [String] $Name, [PSCustomObject[]] $Results, [PSCustomObject[]] $Filters )
        $filterMembers = $Filters |
            Get-Member -MemberType 'NoteProperty' -ErrorAction 'SilentlyContinue'
        Select-ArmorApiResult -Results $Results -Filters $filterMembers
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
        ExpectedOutputTypeNames = 'System.Management.Automation.PSObject', 'System.Management.Automation.PSObject[]'
        Help                    = $help
    }
    Test-AdvancedFunctionHelpOutput @splat

    $splat = @{
        ExpectedParameterNames = 'Results', 'Filters'
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
                Results = [ArmorVM] @{ VmServices = [PSCustomObject] @{ Name = 'TROY-TEST_1' } }
                Filters = [PSCustomObject] @{ Name = 'VmServices.' }
            },
            @{
                Results = [ArmorVM] @{ VmServices = [PSCustomObject] @{ Name = 'TROY-TEST_2' } }
                Filters = [PSCustomObject] @{ Name = '.Name' }
            },
            @{
                Results = [ArmorVM] @{ VmServices = [PSCustomObject] @{ Name = 'TROY-TEST_3' } }
                Filters = [PSCustomObject] @{ Name = 'VmServices.Name.Value' }
            }
        )
        $testName = 'should fail when set to: Results: <Results>, Filters: <Filters>'
        It -Name $testName -TestCases $testCases -Test {
            param ( [PSCustomObject[]] $Results, [PSCustomObject[]] $Filters )
            { Test-SelectArmorApiResult1 -Name $name -Results $Results -Filters $Filters } |
                Should -Throw
        }

        $testCases = @(
            @{
                Results = @()
                Filters = @()
                Count   = 0
            },
            @{
                Results = @()
                Filters = 'Name'
                Count   = 0
            },
            @{
                Results = [ArmorVM]::New(), [ArmorVM]::New()
                Filters = @()
                Count   = 2
            },
            @{
                Results = [ArmorVM] @{ Name = 'TROY-TEST1' }, [ArmorVM]::New()
                Filters = [PSCustomObject] @{ Name = 'Name' }
                Count   = 1
            },
            @{
                Results = [ArmorVM] @{ Name = 'TROY-TESTA' }, [ArmorVM] @{ Name = 'TROY_TESTA' }
                Filters = [PSCustomObject] @{ Name = 'Name' }
                Count   = 1
            },
            @{
                Results = [ArmorVM] @{ Name = 'TROY-TESTB' }, [ArmorVM] @{ CustomLocation = 'TROY-TESTB' }
                Filters = [PSCustomObject] @{ Name = 'CustomLocation' }
                Count   = 1
            },
            @{
                Results = [ArmorVM] @{ Name = 'TROY-TEST!' }, [ArmorVM] @{ Name = 'TROY-TEST#' }
                Filters = [PSCustomObject] @{ Name = 'Name' }
                Count   = 2
            },
            @{
                Results = [ArmorVM] @{ VmServices = [PSCustomObject] @{ Name = 'TROY-TEST' } },
                    [ArmorVM] @{ VmServices = [PSCustomObject] @{ Name = 'TROYTEST' } }
                Filters = [PSCustomObject] @{ Name = 'VmServices.Name' }
                Count   = 1
            }
        )
        $testName = 'should not fail when set to: Results: <Results>, Filters: <Filters>'
        It -Name $testName -TestCases $testCases -Test {
            param ( [PSCustomObject[]] $Results, [PSCustomObject[]] $Filters )
            { Test-SelectArmorApiResult1 -Name $name -Results $Results -Filters $Filters } |
                Should -Not -Throw
        }

        $testName = 'should return: <Count> results when set to: Results: <Results>, Filters: <Filters>'
        It -Name $testName -TestCases $testCases -Test {
            param ( [PSCustomObject[]] $Results, [PSCustomObject[]] $Filters, [UInt16] $Count )
            ( Test-SelectArmorApiResult1 -Name $name -Results $Results -Filters $Filters | Measure-Object ).Count |
                Should -Be $Count
        }
    }

    Context -Name $Global:RETURN_TYPE_CONTEXT -Fixture {
        #region init
        $splat = @{
            Name        = $name
            Results     = [PSCustomObject] @{ Name = 'TROY-TEST3' }, [PSCustomObject]::New()
            Filters     = [PSCustomObject] @{ Name = 'Name' }
            ErrorAction = 'Stop'
        }
        #endregion

        $testCases = @(
            @{
                FoundReturnType    = ( Test-SelectArmorApiResult1 @splat ).GetType().FullName
                ExpectedReturnType = 'System.Management.Automation.PSCustomObject'
            }
        )
        $testName = $Global:FORM_RETURN_TYPE
        It -Name $testName -TestCases $testCases -Test {
            param ( [String] $FoundReturnType, [String] $ExpectedReturnType )
            $FoundReturnType |
                Should -Be $ExpectedReturnType
        }

        # $testName = "has an 'OutputType' entry for <FoundReturnType>"
        # It -Name $testName -TestCases $testCases -Test {
        #     param ( [String] $FoundReturnType, [String] $ExpectedReturnType )
        #     $FoundReturnType |
        #         Should -BeIn $help.ReturnValues.ReturnValue.Type.Name
        # }
    }
}
