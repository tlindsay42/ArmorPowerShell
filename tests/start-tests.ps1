$testsPath = '{0}\tests' -f $env:CI_BUILD_PATH
$results = 'results'
$testsResultsPath = '{0}\{1}' -f $testsPath, $results
$testsResultsFilePath = '{0}\{1}TestsResults.xml' -f $testsResultsPath, $env:CI_NAME
$codeCoverageResultsFilePath = '{0}\{1}CodeCoverageResults.xml' -f $testsResultsPath, $env:CI_NAME
$testsResultsDirectory = $null

if ( -not ( Test-Path -Path $testsResultsPath ) ) {
    $testsResultsDirectory = New-Item -Path $testsPath -Name $results -ItemType 'Directory' -Force -ErrorAction 'Stop'

    if ( -not ( Test-Path -Path $testsResultsPath ) ) {
        throw ( 'Directory not found: "{0}".' -f $testsResultsDirectory )
    }
}

Write-Host -Object "`nInvoking Pester test framework." -ForegroundColor 'Yellow'
$testsResults = Invoke-Pester -Path $testsPath `
    -OutputFormat 'NUnitXml' `
    -OutputFile $testsResultsFilePath `
    -CodeCoverage ( Get-ChildItem -Path $env:CI_MODULE_PATH -Include '*.ps1' -Recurse ) `
    -CodeCoverageOutputFile $codeCoverageResultsFilePath `
    -CodeCoverageOutputFileFormat 'JaCoCo' `
    -PassThru

if ( -not ( Test-Path -Path $testsResultsFilePath ) ) {
    throw ( 'File not found: "{0}".' -f $testsResultsFilePath )
}

if ( $env:APPVEYOR -eq $true ) {
    ( New-Object -TypeName 'System.Net.WebClient' ).UploadFile(
        ( 'https://ci.appveyor.com/api/testresults/nunit/{0}' -f $env:APPVEYOR_JOB_ID ),
        ( '{0}\tests\results\AppVeyorTestsResults.xml' -f $env:CI_BUILD_PATH )
    )

    $coverage = Format-Coverage -PesterResults $testsResults -CoverallsApiToken $env:COVERALLS_API_KEY -BranchName $env:APPVEYOR_REPO_BRANCH

    Publish-Coverage -Coverage $coverage
}

if ( $testsResults.FailedCount -gt 0 ) {
    throw ( '{0} tests failed.' -f $testsResults.FailedCount )
}
