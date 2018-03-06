param (
    [String[]] $Tag,
    [String[]] $ExcludeTag,
    [Switch] $Coverage = $true
)

function GetTestResponseBody ( [String] $FileName ) {
    [String] $return = ''

    $path = Join-Path -Path $env:CI_TESTS_PATH -ChildPath 'etc'
    $filePath = Join-Path -Path $path -ChildPath $FileName
    if ( ( Test-Path -Path $filePath ) -eq $true ) {
        $return = Get-Content -Path $filePath

        if ( ( ConvertFrom-Json -InputObject $return -ErrorAction 'SilentlyContinue' ) -eq '' ) {
            throw "Invalid JSON content: '${filePath}'"
        }
    }

    $return
}

$Global:ClassForm = 'Class/{0}'
$Global:Constructors = 'Constructors'
$Global:DefaultConstructorForm = 'should not fail when creating an object with the default constructor'
$Global:ConstructorFailForm = 'should fail when creating an object with invalid parameters'
$Global:ConstructorPassForm = 'should not fail when creating an object with valid parameters'
$Global:PropertyForm = 'Property/{0}'
$Global:PropertyFailForm = "should fail when set to: <Value>"
$Global:PropertyPassForm = "should not fail when set to: <Value>"
$Global:PropertyTypeForm = 'should be the expected data type'
$Global:MethodForm = 'Method/{0}'
$Global:MethodNegativeForm = '{0} (Negative)' -f $Global:MethodForm
$Global:MethodPositiveForm = '{0} (Positive)' -f $Global:MethodForm
$Global:ReturnTypeForm = 'should return the expected data type'
$Global:PrivateFunctionForm = 'Private/Function/{0}'
$Global:PublicFunctionForm = 'Public/Function/{0}'
$Global:FunctionName = 'Function Name'
$Global:FunctionHelpContext = 'Comment-Based Help'
$Global:FunctionHelpContentForm = 'should have content in section: <Property>'
$Global:FunctionHelpNoInputs = 'None- you cannot pipe objects to this cmdlet.'
$Global:FunctionHelpSpecificContentForm = "should have set '{0}' to '{1}'"
$Global:FunctionHelpNotes = "Troy Lindsay`nTwitter: @troylindsay42`nGitHub: tlindsay42"
$Global:FunctionHelpExampleEntry = "should have at least one 'Example' entry"
$Global:FunctionHelpLinkEntry = "should have at least four help 'Link' entries"
$Global:FunctionHelpLinkValidForm = "should be a valid help link: '{0}'"
$Global:FunctionParameterCountForm = "should have {0} parameters"
$Global:FunctionParameterNameForm = "should have parameter: <Name>"
$Global:ShouldBeForm = "should be: '{0}'"

$Global:JsonResponseBody = @{
    'Authorize1'           = GetTestResponseBody( 'Authorize_1.json' )
    'Identity1'            = GetTestResponseBody( 'Identity_1.json' )
    'Session1'             = GetTestResponseBody( 'Session_1.json' )
    'Token1'               = GetTestResponseBody( 'Token_1.json' )
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

$pathTest = Test-Path -Path $env:CI_TEST_RESULTS_PATH
if ( $pathTest -eq $false ) {
    throw "File not found: '${env:CI_TEST_RESULTS_PATH}'."
}

$pathTest = Test-Path -Path $env:CI_COVERAGE_RESULTS_PATH
if ( $pathTest -eq $false -and $Coverage -eq $true ) {
    throw "File not found: '${env:CI_COVERAGE_RESULTS_PATH}'."
}

if ( $testsResults.FailedCount -gt 0 ) {
    throw "$( $testsResults.FailedCount ) tests failed."
}

if ( $env:APPVEYOR -eq $true ) {
    $webClient = New-Object -TypeName 'System.Net.WebClient'
    $webClient.UploadFile(
        "https://ci.appveyor.com/api/testresults/nunit/${env:APPVEYOR_JOB_ID}",
        $env:CI_TEST_RESULTS_PATH
    )

    $splat = @{
        'PesterResults'     = $testsResults
        'CoverallsApiToken' = $env:COVERALLS_API_KEY
        'BranchName'        = $env:CI_BRANCH
    }
    $coverageResults = Format-Coverage @splat

    Write-Host -Object 'Publishing code coverage' -ForegroundColor 'Yellow'
    Publish-Coverage -Coverage $coverageResults
    Write-Host -Object ''
}

Write-Host -Object "Checking the spelling of all documentation in Markdown format." -ForegroundColor 'Yellow'
& mdspell --en-us --ignore-numbers --ignore-acronyms --report '**/*.md'

Write-Host -Object ''
