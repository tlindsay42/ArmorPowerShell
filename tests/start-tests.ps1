if ( $env:APPVEYOR -eq $true ) {
    $ciName = 'AppVeyor' 
}
elseif ( $env:TRAVIS -eq $true ) {
    $ciName = 'TravisCI' 
}
else {
    throw 'Unknown continuous integration environment.'
}

Write-Host -Object "`nInvoking Pester test framework." -ForegroundColor 'Yellow'
$testsResults = Invoke-Pester -Path ( '{0}\tests' -f $env:BUILD_PATH ) `
    -OutputFormat 'NUnitXml' `
    -OutputFile ( '{0}\tests\results\{1}TestsResults.xml' -f $env:BUILD_PATH, $ciName ) `
    -CodeCoverage ( Get-ChildItem -Path $env:MODULE_PATH -Include '*.ps1' -Recurse ) `
    -CodeCoverageOutputFile ( '{0}\tests\results\{1}CodeCoverageResults.xml' -f $env:BUILD_PATH, $ciName ) `
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
