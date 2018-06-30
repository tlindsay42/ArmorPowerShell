Import-Module -Name $CI_MODULE_MANIFEST_PATH -Force

$systemUnderTest = ( Split-Path -Leaf $MyInvocation.MyCommand.Path ) -replace '\.Tests\.', '.'

$function = $systemUnderTest.Split( '.' )[0]
$describe = $Global:FORM_FUNCTION_PUBLIC -f $function
Describe -Name $describe -Tag 'Function', 'Public', $function -Fixture {
    #region init
    $help = Get-Help -Name $function -Full
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
        ExpectedParameterNames = 'WhatIf', 'Confirm'
        Help                   = $help
    }
    Test-AdvancedFunctionHelpParameter @splat

    $splat = @{
        ExpectedNotes = $Global:FORM_FUNCTION_HELP_NOTES
        Help          = $help
    }
    Test-AdvancedFunctionHelpNote @splat

    Context -Name $Global:EXECUTION -Fixture {
        $testName = "should not fail"
        It -Name $testName -Test {
            { Disconnect-Armor -Confirm:$false } |
                Should -Not -Throw
        }
    }

    Context -Name $Global:RETURN_TYPE_CONTEXT -Fixture {
        #region init
        $returnValue = Disconnect-Armor -Confirm:$false
        $returnType = $null
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
                Should -BeIn $help.ReturnValues.ReturnValue.Type.Name
        }
    }
}
