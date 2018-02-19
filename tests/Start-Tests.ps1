$splat = @{
    'Path'                         = $env:CI_TESTS_PATH
    'OutputFormat'                 = 'NUnitXml'
    'OutputFile'                   = $env:CI_TEST_RESULTS_PATH
    'CodeCoverage'                 = Get-ChildItem -Path $env:CI_MODULE_PATH -Include '*.ps1' -Recurse
    'CodeCoverageOutputFile'       = $env:CI_COVERAGE_RESULTS_PATH
    'CodeCoverageOutputFileFormat' = 'JaCoCo'
    'PassThru'                     = $true
}

Write-Host -Object "`nInvoking Pester test framework." -ForegroundColor 'Yellow'
$testsResults = Invoke-Pester @splat

$pathTest = Test-Path -Path $env:CI_TEST_RESULTS_PATH
if ( $pathTest -eq $false ) {
    throw "File not found: '${env:CI_TEST_RESULTS_PATH}'."
}

$pathTest = Test-Path -Path $env:CI_COVERAGE_RESULTS_PATH
if ( $pathTest -eq $false ) {
    throw "File not found: '${env:CI_COVERAGE_RESULTS_PATH}'."
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
        'BranchName'        = $env:APPVEYOR_REPO_BRANCH
    }
    $coverage = Format-Coverage @splat

    Write-Host -Object 'Publishing code coverage' -ForegroundColor 'Yellow'
    Publish-Coverage -Coverage $coverage
    Write-Host -Object ''
}

if ( $testsResults.FailedCount -gt 0 ) {
    throw "$( $testsResults.FailedCount ) tests failed."
}

Write-Host -Object "Checking the spelling of all documentation in Markdown format." -ForegroundColor 'Yellow'
& mdspell --en-us --ignore-numbers --ignore-acronyms --report '**/*.md'

Write-Host -Object ''
