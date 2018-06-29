Import-Module -Name $Env:CI_MODULE_MANIFEST_PATH -Force

$systemUnderTest = ( Split-Path -Leaf $MyInvocation.MyCommand.Path ) -replace '\.Tests\.', '.'
$filePath = Join-Path -Path $Env:CI_MODULE_PRIVATE_PATH -ChildPath $systemUnderTest

. $filePath

$function = $systemUnderTest.Split( '.' )[0]
$describe = $Global:PrivateFunctionForm -f $function
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
    $validDescription = 'Get VMs'
    #endregion

    $splat = @{
        'ExpectedFunctionName' = $function
        'FoundFunctionName'    = $help.Name
    }
    TestAdvancedFunctionName @splat

    TestAdvancedFunctionHelpMain -Help $help

    TestAdvancedFunctionHelpInputs -Help $help

    $splat = @{
        'ExpectedOutputTypeNames' = 'System.Management.Automation.PSObject', 'System.Management.Automation.PSObject[]'
        'Help'                    = $help
    }
    TestAdvancedFunctionHelpOutputs @splat

    $splat = @{
        'ExpectedParameterNames' = 'Uri', 'Headers', 'Method', 'Body', 'SuccessCode'
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
                'Uri'         = $invalidUri
                'Headers'     = $validHeaders
                'Method'      = $validMethod
                'Body'        = $validBody
                'SuccessCode' = $validSuccessCode
            },
            @{
                'Uri'         = $validUri
                'Headers'     = $invalidHeaders
                'Method'      = $validMethod
                'Body'        = $validBody
                'SuccessCode' = $validSuccessCode
            },
            @{
                'Uri'         = $validUri
                'Headers'     = $validHeaders
                'Method'      = 'Head'
                'Body'        = $validBody
                'SuccessCode' = $validSuccessCode
            },
            @{
                'Uri'         = $validUri
                'Headers'     = $validHeaders
                'Method'      = 'Merge'
                'Body'        = $validBody
                'SuccessCode' = $validSuccessCode
            },
            @{
                'Uri'         = $validUri
                'Headers'     = $validHeaders
                'Method'      = 'Options'
                'Body'        = $validBody
                'SuccessCode' = $validSuccessCode
            },
            @{
                'Uri'         = $validUri
                'Headers'     = $validHeaders
                'Method'      = 'Trace'
                'Body'        = $validBody
                'SuccessCode' = $validSuccessCode
            },
            @{
                'Uri'         = $validUri
                'Headers'     = $validHeaders
                'Method'      = $validMethod
                'Body'        = $validBody
                'SuccessCode' = $invalidSuccessCode
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
                'StatusCode' = $validSuccessCode
                'Content'    = $Global:JsonResponseBody.VMs1
            }
        }

        $testCases = @(
            @{
                'Uri'         = $validUri
                'Headers'     = $validHeaders
                'Method'      = 'Delete'
                'Body'        = $validBody
                'SuccessCode' = $validSuccessCode
            },
            @{
                'Uri'         = $validUri
                'Headers'     = $validHeaders
                'Method'      = 'Get'
                'Body'        = $validBody
                'SuccessCode' = $validSuccessCode
            },
            @{
                'Uri'         = $validUri
                'Headers'     = $validHeaders
                'Method'      = 'Patch'
                'Body'        = $validBody
                'SuccessCode' = $validSuccessCode
            },
            @{
                'Uri'         = $validUri
                'Headers'     = $validHeaders
                'Method'      = 'Post'
                'Body'        = $validBody
                'SuccessCode' = $validSuccessCode
            },
            @{
                'Uri'         = $validUri
                'Headers'     = $validHeaders
                'Method'      = 'Put'
                'Body'        = $validBody
                'SuccessCode' = $validSuccessCode
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

    Context -Name $Global:ReturnTypeContext -Fixture {
        #region init
        $splat = @{
            'Uri'         = $validUri
            'Method'      = $validMethod
            'SuccessCode' = $validSuccessCode
            'ErrorAction' = 'Stop'
        }
        #endregion

        Mock -CommandName Invoke-WebRequest -Verifiable -MockWith {
            @{
                'StatusCode' = $validSuccessCode
                'Content'    = $Global:JsonResponseBody.VMs1
            }
        }

        $testCases = @(
            @{
                'FoundReturnType'    = ( Submit-ArmorApiRequest @splat ).GetType().FullName
                'ExpectedReturnType' = 'System.Management.Automation.PSCustomObject'
            }
        )
        $testName = $Global:ReturnTypeForm
        It -Name $testName -TestCases $testCases -Test {
            param ( [String] $FoundReturnType, [String] $ExpectedReturnType )
            $FoundReturnType |
                Should -Be $ExpectedReturnType
        }
        Assert-VerifiableMock
        Assert-MockCalled -CommandName Invoke-WebRequest -Times $testCases.Count

        # $testName = "has an 'OutputType' entry for <FoundReturnType>"
        # It -Name $testName -TestCases $testCases -Test {
        #     param ( [String] $FoundReturnType )
        #     $FoundReturnType |
        #         Should -BeIn $help.ReturnValues.ReturnValue.Type.Name
        # }
    }
}
