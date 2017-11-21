$testsPath = '{0}\tests' -f $env:BUILD_PATH

if ( $env:APPVEYOR -eq $true ) {
    $ciName = 'AppVeyor' 
}
elseif ( $env:TRAVIS -eq $true ) {
    $ciName = 'TravisCI' 
}
else {
    throw 'Unknown continuous integration environment.'
}

$testsResultsPath = New-Item -Path $testsPath -Name 'results' -ItemType 'Directory' -ErrorAction 'Stop'

if ( -not ( Test-Path -Path $testsPath ) ) {
    throw ( 'Directory not found: "{0}".' -f $testsPath )
}

Write-Host -Object "`nInvoking Pester test framework." -ForegroundColor 'Yellow'
$testsResults = Invoke-Pester -Path $testsPath `
    -OutputFormat 'NUnitXml' `
    -OutputFile ( '{0}\{1}TestsResults.xml' -f $testsResultsPath, $ciName ) `
    -CodeCoverage ( Get-ChildItem -Path $env:MODULE_PATH -Include '*.ps1' -Recurse ) `
    -CodeCoverageOutputFile ( '{0}\{1}CodeCoverageResults.xml' -f $testsResultsPath, $ciName ) `
    -CodeCoverageOutputFileFormat 'JaCoCo' `
    -PassThru

if ( $ciName -eq 'AppVeyor' ) {
    ( New-Object -TypeName 'System.Net.WebClient' ).UploadFile(
        ( 'https://ci.appveyor.com/api/testresults/nunit/{0}' -f $env:APPVEYOR_JOB_ID ), 
        ( '{0}\tests\results\AppVeyorTestsResults.xml' -f $env:BUILD_PATH )
    )

    $coverage = Format-Coverage -PesterResults $testsResults -CoverallsApiToken $env:COVERALLS_API_KEY -BranchName $env:APPVEYOR_REPO_BRANCH

    Publish-Coverage -Coverage $coverage
}

if ( $testsResults.FailedCount -gt 0 ) {
    throw ( '{0} tests failed.' -f $testsResults.FailedCount )
}
