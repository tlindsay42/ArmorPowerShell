Import-Module -Name $CI_MODULE_MANIFEST_PATH -Force

$systemUnderTest = ( Split-Path -Leaf $MyInvocation.MyCommand.Path ) -replace '\.Tests\.', '.'
$filePath = Join-Path -Path $CI_MODULE_PRIVATE_PATH -ChildPath $systemUnderTest

. $filePath

$function = $systemUnderTest.Split( '.' )[0]
$describe = $Global:FORM_FUNCTION_PRIVATE -f $function
Describe -Name $describe -Tag 'Function', 'Private', $function -Fixture {
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
        ExpectedOutputTypeNames = 'System.Collections.Hashtable'
        Help                    = $help
    }
    Test-AdvancedFunctionHelpOutput @splat

    $splat = @{
        ExpectedParameterNames = 'InputObject', 'SensitiveProperties', 'ForceVerbose'
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
        $validInputObject = @{
            Credential    = 'credential'
            Authorization = 'authorization'
            Token         = 'token'
        }
        $validSensitiveProperties = @(
            'Credential',
            'Authorization',
            'Token'
        )
        #endregion

        $testCases = @(
            @{
                InputObject         = $validInputObject
                SensitiveProperties = @()
                ForceVerbose        = $false
            }
        )
        $testName = 'should fail when set to: InputObject: <InputObject> SensitiveProperties: <SensitiveProperties> ForceVerbose: <ForceVerbose> (named)'
        It -Name $testName -TestCases $testCases -Test {
            param ( [Hashtable] $InputObject, [String[]] $SensitiveProperties, [Switch] $ForceVerbose )
            { Hide-SensitiveData -InputObject $InputObject -SensitiveProperties $SensitiveProperties -ForceVerbose:$ForceVerbose } |
                Should -Throw
        }

        $testCases = @(
            @{
                InputObject         = $validInputObject
                SensitiveProperties = $validSensitiveProperties
                ForceVerbose        = $false
            },
            @{
                InputObject         = $validInputObject
                SensitiveProperties = $validSensitiveProperties
                ForceVerbose        = $true
            }
        )
        $testName = 'should not fail when set to: InputObject: <InputObject> SensitiveProperties: <SensitiveProperties> ForceVerbose: <ForceVerbose> (named)'
        It -Name $testName -TestCases $testCases -Test {
            param ( [Hashtable] $InputObject, [String[]] $SensitiveProperties, [Switch] $ForceVerbose )
            { Hide-SensitiveData -InputObject $InputObject -SensitiveProperties $SensitiveProperties -ForceVerbose:$ForceVerbose } |
                Should -Not -Throw
        }

        $testName = $testName -replace '\(named\)', '(positional)'
        It -Name $testName -TestCases $testCases -Test {
            param ( [Hashtable] $InputObject, [String[]] $SensitiveProperties, [Switch] $ForceVerbose )
            { Hide-SensitiveData $InputObject $SensitiveProperties $ForceVerbose } |
                Should -Not -Throw
        }

        $testName = $testName -replace '\(positional\)', '(pipeline by value)'
        It -Name $testName -TestCases $testCases -Test {
            param ( [Hashtable] $InputObject, [String[]] $SensitiveProperties, [Switch] $ForceVerbose )
            { $InputObject | Hide-SensitiveData -SensitiveProperties $SensitiveProperties -ForceVerbose:$ForceVerbose } |
                Should -Not -Throw
        }
    }

    Context -Name $Global:RETURN_TYPE_CONTEXT -Fixture {
        #region init
        $splat = @{
            InputObject = @{
                Credential    = 'credential'
                Authorization = 'authorization'
                Token         = 'token'
            }
            SensitiveProperties = @(
                'Credential',
                'Authorization',
                'Token'
            )
            ForceVerbose = $false
        }
        #endregion

        $testCases = @(
            @{
                FoundReturnType    = ( Hide-SensitiveData @splat ).GetType().FullName
                ExpectedReturnType = 'System.Collections.Hashtable'
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
                Should -BeIn ( $help.ReturnValues.ReturnValue.Type.Name )
        }
    }
}
