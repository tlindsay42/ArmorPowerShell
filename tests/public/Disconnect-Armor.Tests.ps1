Import-Module -Name $Env:CI_MODULE_MANIFEST_PATH -Force

$systemUnderTest = ( Split-Path -Leaf $MyInvocation.MyCommand.Path ) -replace '\.Tests\.', '.'

$function = $systemUnderTest.Split( '.' )[0]
$describe = $Global:PublicFunctionForm -f $function
Describe -Name $describe -Tag 'Function', 'Public', $function -Fixture {
    #region init
    $help = Get-Help -Name $function -Full
    #endregion

    $splat = @{
        ExpectedFunctionName = $function
        FoundFunctionName    = $help.Name
    }
    TestAdvancedFunctionName @splat

    TestAdvancedFunctionHelpMain -Help $help

    TestAdvancedFunctionHelpInputs -Help $help

    # $splat = @{
    #     ExpectedOutputTypeNames = 'Void'
    #     Help                    = $help
    # }
    # TestAdvancedFunctionHelpOutputs @splat

    $splat = @{
        ExpectedParameterNames = 'WhatIf', 'Confirm'
        Help                   = $help
    }
    TestAdvancedFunctionHelpParameters @splat

    $splat = @{
        ExpectedNotes = $Global:FORM_FUNCTION_HELP_NOTES
        Help          = $help
    }
    TestAdvancedFunctionHelpNotes @splat

    Context -Name $Global:Execution -Fixture {
        $testName = "should not fail"
        It -Name $testName -Test {
            { Disconnect-Armor -Confirm:$false } |
                Should -Not -Throw
        }
    }

    Context -Name $Global:ReturnTypeContext -Fixture {
        $testCases = @(
            @{
                FoundReturnType    = Disconnect-Armor -Confirm:$false
                ExpectedReturnType = 'System.Void'
            }
        )
        $testName = $Global:ReturnTypeForm
        It -Name $testName -TestCases $testCases -Test {
            param ( [String] $FoundReturnType, [String] $ExpectedReturnType )
            $FoundReturnType |
                Should -BeNullOrEmpty
        }
    }
}
