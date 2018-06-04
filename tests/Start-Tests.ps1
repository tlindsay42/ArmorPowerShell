param (
    [String[]] $Tag,
    [String[]] $ExcludeTag,
    [Boolean] $Coverage = $true
)

function GetTestResponseBody ( [String] $FileName ) {
    [String] $return = ''

    $path = Join-Path -Path $Env:CI_TESTS_PATH -ChildPath 'etc'
    $filePath = Join-Path -Path $path -ChildPath $FileName
    if ( ( Test-Path -Path $filePath ) -eq $true ) {
        $return = Get-Content -Path $filePath

        if ( ( ConvertFrom-Json -InputObject $return -ErrorAction 'SilentlyContinue' ) -eq '' ) {
            throw "Invalid JSON content: '${filePath}'"
        }
    }

    $return
} # End of Function

function TestAdvancedFunctionName (
    [String] $ExpectedFunctionName,
    [String] $FoundFunctionName
) {
    Context -Name 'Function Name' -Fixture {
        $testName = "should be: '${ExpectedFunctionName}'"
        It -Name $testName -Test {
            $FoundFunctionName |
                Should -BeExactly $ExpectedFunctionName
        }
    } # End of Context
} # End of Function

function TestAdvancedFunctionHelpMain ( [PSObject] $Help ) {
    $contextName = $Global:FunctionHelpForm -f 'Main'
    Context -Name $contextName -Fixture {
        $testName = 'should have content in section: <Property>'
        $testCases = @(
            @{ 'Property' = 'Synopsis' },
            @{ 'Property' = 'Description' }
        )
        It -Name $testName -TestCases $testCases -Test {
            param ( [String] $Property )
            $Help.$Property.Length |
                Should -BeGreaterThan 0
        } # End of It

        $testName = "should have at least one: 'Example' entry"
        It -Name $testName -Test {
            $Help.Examples.Example.Remarks.Length |
                Should -BeGreaterThan 0
        } # End of It

        $testName = "should have at least four help: 'Link' entries"
        It -Name $testName -Test {
            $Help.RelatedLinks.NavigationLink.Uri.Count |
                Should -BeGreaterThan 3
        } # End of It

        foreach ( $uri in $Help.RelatedLinks.NavigationLink.Uri ) {
            $testName = "should be a valid help link: '${uri}'"
            It -Name $testName -Test {
                ( Invoke-WebRequest -Method 'Get' -Uri $uri ).StatusCode |
                    Should -Be 200
            } # End of It
        }
    } # End of Context
} # End of Function

function TestAdvancedFunctionHelpInputs ( [PSObject] $Help ) {
    $contextName = $Global:FunctionHelpForm -f 'Inputs'
    Context -Name $contextName -Fixture {
        #region init
        $pipelineInputParameterTypes = @()
        $inputTypes = $Help.InputTypes.InputType.Type.Name.Split( "`n" ).Where( { $_.Length -gt 0 } )
        #endregion

        if ( ( $Help.Parameters.Parameter | Where-Object -FilterScript { $_.PipelineInput -match '^true.*ByPropertyName' } ).Type.Name.Count -gt 0 ) {
            $pipelineInputParameterTypes += 'PSCustomObject'
        }

        $pipelineInputParameterTypes += ( $Help.Parameters.Parameter | Where-Object -FilterScript { $_.PipelineInput -match '^true.*ByValue' } ).Type.Name |
            Sort-Object -Unique

        $testName = "should have at least: '1' entry"
        It -Name $testName -Test {
            $inputTypes.Count |
                Should -BeGreaterThan 0
        } # End of It

        foreach ( $inputType in $inputTypes ) {
            if ( $inputType -match '^None' ) {
                $testName = "should not have any pipeline input parameters since: 'Inputs' is set to: '${inputType}'"
                It -Name $testName -Test {
                    $pipelineInputParameterTypes.Count |
                        Should -Be 0
                } # End of It
            }
            else {
                $testName = "should have a pipeline input parameter of type: '${inputType}'"
                It -Name $testName -Test {
                    $inputType |
                        Should -BeIn $pipelineInputParameterTypes
                } # End of It
            }
        }

        foreach ( $inputType in $pipelineInputParameterTypes ) {
            $testName = "should have an: 'Inputs' entry for type: '${inputType}'"
            It -Name $testName -Test {
                $inputType |
                    Should -BeIn $inputTypes
            } # End of It
        }
    } # End of Context
}

function TestAdvancedFunctionHelpOutputs ( [String[]] $ExpectedOutputTypeNames, [PSObject] $Help ) {
    $contextName = $Global:FunctionHelpForm -f 'Outputs'
    Context -Name $contextName -Fixture {
        #region init
        $outputTypes = $Help.ReturnValues.ReturnValue.Type.Name
        $expectedOutputTypeCount = $ExpectedOutputTypeNames.Count
        #endregion

        $testName = "should have at least one entry"
        It -Name $testName -Test {
            $outputTypes.Count |
                Should -BeGreaterThan 0
        } # End of It

        $testName = "should have: '${expectedOutputTypeCount}' output types"
        It -Name $testName -Test {
            $outputTypes.Count |
                Should -Be $expectedOutputTypeCount
        } # End of It

        foreach ( $outputType in $outputTypes ) {
            $testName = "should have an: 'Outputs' entry for type: '${outputType}'"
            It -Name $testName -Test {
                $outputType |
                    Should -BeIn $ExpectedOutputTypeNames
            } # End of It
        }

        foreach ( $outputType in $ExpectedOutputTypeNames ) {
            $testName = "should have an: 'OutputType' entry for type: '${outputType}'"
            It -Name $testName -Test {
                $outputType |
                    Should -BeIn $outputTypes
            } # End of It
        }
    } # End of Context
}

function TestAdvancedFunctionHelpParameters ( [String[]] $ExpectedParameterNames, [PSObject] $Help ) {
    $contextName = $Global:FunctionHelpForm -f 'Parameters'
    Context -Name $contextName -Fixture {
        #region init
        $expectedParameterCount = $ExpectedParameterNames.Count
        #endregion

        $testName = "should have: '${expectedParameterCount}' parameters"
        It -Name $testName -Test {
            if ( $Help.Parameters.Parameter.Count -eq $null ) {
                @( $Help.Parameters.Parameter ).Count |
                    Should -Be $expectedParameterCount
            }
            else {
                $Help.Parameters.Parameter.Count |
                    Should -Be $expectedParameterCount
            }
        } # End of It

        foreach ( $parameterName in $ExpectedParameterNames ) {
            $testName = "should have parameter: '${parameterName}'"
            It -Name $testName -Test {
                $parameterName |
                    Should -BeIn $Help.Parameters.Parameter.Name
            } # End of It

            if ( $parameterName -notin 'WhatIf', 'Confirm' ) {
                $testName = "should have a description set for parameter: '${parameterName}'"
                It -Name $testName -Test {
                    ( $Help.Parameters.Parameter | Where-Object -FilterScript { $_.Name -eq $parameterName } ).Description.Length |
                        Should -BeGreaterThan 0
                } # End of It
            }
        }
    } # End of Context
} # End of Function

function TestAdvancedFunctionHelpNotes ( [String] $ExpectedNotes, [PSObject] $Help ) {
    $contextName = $Global:FunctionHelpForm -f 'Notes'
    Context -Name $contextName -Fixture {
        $inlineNotes = $ExpectedNotes -replace '\n', ', '
        $testName = "should have set: 'Notes' to: '${inlineNotes}'"
        It -Name $testName -Test {
            $Help.AlertSet.Alert.Text |
                Should -BeExactly $ExpectedNotes
        } # End of It
    } # End of Context
} # End of Function

$Global:ClassForm = 'Class/{0}'
$Global:EnumForm = 'Enum/{0}'
$Global:Constructors = 'Constructors'
$Global:DefaultConstructorForm = 'should not fail when creating an object with the default constructor'
$Global:PropertyForm = 'Property/{0}'
$Global:PropertyFailForm = "should fail when set to: <Value>"
$Global:PropertyPassForm = "should not fail when set to: <Value>"
$Global:PropertyTypeForm = 'should be the expected data type'
$Global:MethodForm = 'Method/{0}'
$Global:MethodNegativeForm = '{0} (Negative)' -f $Global:MethodForm
$Global:MethodPositiveForm = '{0} (Positive)' -f $Global:MethodForm
$Global:Execution = 'Execution'
$Global:ReturnTypeContext = 'Return Type'
$Global:ReturnTypeForm = 'should return the expected data type: <ExpectedReturnType>'
$Global:PrivateFunctionForm = 'Private/Function/{0}'
$Global:PublicFunctionForm = 'Public/Function/{0}'
$Global:FunctionHelpForm = 'Comment-Based Help/{0}'
$Global:FunctionHelpNotes = "Troy Lindsay`nTwitter: @troylindsay42`nGitHub: tlindsay42"

$Global:JsonResponseBody = @{
    'Accounts4'            = GetTestResponseBody( 'Accounts_4.json' )
    'Address1'             = GetTestResponseBody( 'Address_1.json' )
    'Authorize1'           = GetTestResponseBody( 'Authorize_1.json' )
    'Datacenters5'         = GetTestResponseBody( 'Datacenters_5.json' )
    'Identity1'            = GetTestResponseBody( 'Identity_1.json' )
    'Session1'             = GetTestResponseBody( 'Session_1.json' )
    'Tiers1VMs1'           = GetTestResponseBody( 'Tiers_1-VMs_1.json' )
    'Token1'               = GetTestResponseBody( 'Token_1.json' )
    'Users1'               = GetTestResponseBody( 'Users_1.json' )
    'VMs1'                 = GetTestResponseBody( 'VMs_1.json' )
    'VMs2'                 = GetTestResponseBody( 'VMs_2.json' )
    'Workloads1Tiers1VMs1' = GetTestResponseBody( 'Workloads_1-Tiers_1-VMs_1.json' )
    'Workloads1Tiers1VMs2' = GetTestResponseBody( 'Workloads_1-Tiers_1-VMs_2.json' )
}

$splat = @{
    'Path' = Get-ChildItem -Path $PSScriptRoot -Recurse -Directory -Exclude 'etc'
    'OutputFormat' = 'NUnitXml'
    'OutputFile'   = $Env:CI_TEST_RESULTS_PATH
}

if ( $Tag.Count -gt 0 ) {
    $splat.Tag = $Tag
}

if ( $ExcludeTag.Count -gt 0 ) {
    $splat.ExcludeTag = $ExcludeTag
}

if ( $Coverage -eq $true ) {
    $splat.CodeCoverage = Get-ChildItem -Path $Env:CI_MODULE_PATH -Include '*.psm1', '*.ps1' -Recurse
    $splat.CodeCoverageOutputFile = $Env:CI_COVERAGE_RESULTS_PATH
    $splat.CodeCoverageOutputFileFormat = 'JaCoCo'
    $splat.PassThru = $true
}

Write-Host -Object "`nInvoking Pester test framework." -ForegroundColor 'Yellow'
$testsResults = Invoke-Pester @splat

$pathTest = Test-Path -Path $Env:CI_TEST_RESULTS_PATH
if ( $pathTest -eq $false ) {
    throw "File not found: '${Env:CI_TEST_RESULTS_PATH}'."
}

$pathTest = Test-Path -Path $Env:CI_COVERAGE_RESULTS_PATH
if ( $pathTest -eq $false -and $Coverage -eq $true ) {
    throw "File not found: '${Env:CI_COVERAGE_RESULTS_PATH}'."
}

if ( $testsResults.FailedCount -gt 0 ) {
    throw "$( $testsResults.FailedCount ) tests failed."
}

if ( $Env:APPVEYOR -eq $true ) {
    $webClient = New-Object -TypeName 'System.Net.WebClient'
    $webClient.UploadFile(
        "https://ci.appveyor.com/api/testresults/nunit/${Env:APPVEYOR_JOB_ID}",
        $Env:CI_TEST_RESULTS_PATH
    )

    $splat = @{
        'PesterResults'     = $testsResults
        'CoverallsApiToken' = $Env:COVERALLS_API_KEY
        'BranchName'        = $Env:CI_BRANCH
    }
    $coverageResults = Format-Coverage @splat

    Write-Host -Object 'Publishing code coverage' -ForegroundColor 'Yellow'
    Publish-Coverage -Coverage $coverageResults
    Write-Host -Object ''
}

Write-Host -Object "Checking the spelling of all documentation in Markdown format." -ForegroundColor 'Yellow'
& mdspell --en-us --ignore-numbers --ignore-acronyms --report '**/*.md'

Write-Host -Object ''
