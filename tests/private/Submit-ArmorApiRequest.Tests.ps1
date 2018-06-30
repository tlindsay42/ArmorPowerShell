Import-Module -Name $CI_MODULE_MANIFEST_PATH -Force

$systemUnderTest = ( Split-Path -Leaf $MyInvocation.MyCommand.Path ) -replace '\.Tests\.', '.'
$filePath = Join-Path -Path $CI_MODULE_PRIVATE_PATH -ChildPath $systemUnderTest

. $filePath

$function = $systemUnderTest.Split( '.' )[0]
$describe = $Global:FORM_FUNCTION_PRIVATE -f $function
Describe -Name $describe -Tag 'Function', 'Private', $function -Fixture {
    #region init
    $help = Get-Help -Name $function -Full
    $invalidUri = 'http://insecure.api/vms'
    $validUri = 'https://api.armor.mock/vms'
    $invalidHeaders = @{}
    $validHeaders = @{}
    $validMethod = 'Get'
    $validBody = ''
    $invalidSuccessCode = 0
    $validSuccessCode = 200
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
        ExpectedParameterNames = 'Uri', 'Headers', 'Method', 'Body', 'SuccessCode'
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
                Uri         = $invalidUri
                Headers     = $validHeaders
                Method      = $validMethod
                Body        = $validBody
                SuccessCode = $validSuccessCode
            },
            @{
                Uri         = $validUri
                Headers     = $invalidHeaders
                Method      = $validMethod
                Body        = $validBody
                SuccessCode = $validSuccessCode
            },
            @{
                Uri         = $validUri
                Headers     = $validHeaders
                Method      = 'Head'
                Body        = $validBody
                SuccessCode = $validSuccessCode
            },
            @{
                Uri         = $validUri
                Headers     = $validHeaders
                Method      = 'Merge'
                Body        = $validBody
                SuccessCode = $validSuccessCode
            },
            @{
                Uri         = $validUri
                Headers     = $validHeaders
                Method      = 'Options'
                Body        = $validBody
                SuccessCode = $validSuccessCode
            },
            @{
                Uri         = $validUri
                Headers     = $validHeaders
                Method      = 'Trace'
                Body        = $validBody
                SuccessCode = $validSuccessCode
            },
            @{
                Uri         = $validUri
                Headers     = $validHeaders
                Method      = $validMethod
                Body        = $validBody
                SuccessCode = $invalidSuccessCode
            }
        )
        $testName = 'should fail when set to: Uri: <Uri>, Headers: <Headers>, Method: <Method>, Body: <Body>, SuccessCode: <SuccessCode>'
        It -Name $testName -TestCases $testCases -Test {
            param ( [String] $Uri, [Hashtable] $Headers, [String] $Method, [String] $Body, [UInt16] $SuccessCode )
            { Submit-ArmorApiRequest -Uri $Uri -Headers $Headers -Method $Method -Body $Body -SuccessCode $SuccessCode } |
                Should -Throw
        }

        Mock -CommandName Invoke-WebRequest -Verifiable -MockWith {
            @{
                StatusCode = $validSuccessCode
                Content    = $Global:JSON_RESPONSE_BODY.VMs1
            }
        }

        $testCases = @(
            @{
                Uri         = $validUri
                Headers     = $validHeaders
                Method      = 'Delete'
                Body        = $validBody
                SuccessCode = $validSuccessCode
            },
            @{
                Uri         = $validUri
                Headers     = $validHeaders
                Method      = 'Get'
                Body        = $validBody
                SuccessCode = $validSuccessCode
            },
            @{
                Uri         = $validUri
                Headers     = $validHeaders
                Method      = 'Patch'
                Body        = $validBody
                SuccessCode = $validSuccessCode
            },
            @{
                Uri         = $validUri
                Headers     = $validHeaders
                Method      = 'Post'
                Body        = $validBody
                SuccessCode = $validSuccessCode
            },
            @{
                Uri         = $validUri
                Headers     = $validHeaders
                Method      = 'Put'
                Body        = $validBody
                SuccessCode = $validSuccessCode
            }
        )
        $testName = 'should not fail when set to: Uri: <Uri>, Headers: <Headers>, Method: <Method>, Body: <Body>, SuccessCode: <SuccessCode>'
        It -Name $testName -TestCases $testCases -Test {
            param ( [String] $Uri, [Hashtable] $Headers, [String] $Method, [String] $Body, [UInt16] $SuccessCode )
            { Submit-ArmorApiRequest -Uri $Uri -Headers $Headers -Method $Method -Body $Body -SuccessCode $SuccessCode } |
                Should -Not -Throw
        }
        Assert-VerifiableMock
        Assert-MockCalled -CommandName Invoke-WebRequest -Times $testCases.Count
    }

    Context -Name $Global:RETURN_TYPE_CONTEXT -Fixture {
        #region init
        $splat = @{
            Uri         = $validUri
            Method      = $validMethod
            SuccessCode = $validSuccessCode
            ErrorAction = 'Stop'
        }
        #endregion

        Mock -CommandName Invoke-WebRequest -Verifiable -MockWith {
            @{
                StatusCode = $validSuccessCode
                Content    = $Global:JSON_RESPONSE_BODY.VMs1
            }
        }

        $testCases = @(
            @{
                FoundReturnType    = ( Submit-ArmorApiRequest @splat ).GetType().FullName
                ExpectedReturnType = 'System.Management.Automation.PSCustomObject'
            }
        )
        $testName = $Global:FORM_RETURN_TYPE
        It -Name $testName -TestCases $testCases -Test {
            param ( [String] $FoundReturnType, [String] $ExpectedReturnType )
            $FoundReturnType |
                Should -Be $ExpectedReturnType
        }
        Assert-VerifiableMock
        Assert-MockCalled -CommandName Invoke-WebRequest -Times $testCases.Count

        $testName = "has an 'OutputType' entry for <FoundReturnType>"
        It -Name $testName -TestCases $testCases -Test {
            param ( [String] $FoundReturnType, [String] $ExpectedReturnType )
            $FoundReturnType |
                Should -BeIn ( $help.ReturnValues.ReturnValue.Type.Name + $ExpectedReturnType )
        }
    }
}
