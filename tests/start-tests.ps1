If ( $env:APPVEYOR -eq $true ) { $ciName = 'AppVeyor' }
ElseIf ( $env:TRAVIS -eq $true ) { $ciName = 'TravisCI' }
Else { Throw 'Unknown continuous integration environment.' }

Write-Host -Object "`nInvoking Pester test framework." -ForegroundColor 'Yellow'
$testsResults = Invoke-Pester -Path '.\tests' `
	-OutputFormat NUnitXml `
	-OutputFile ( '.\tests\results\{0}TestsResults.xml' -f $ciName ) `
	-CodeCoverage ( Get-ChildItem -Path '.\Armor' -Include '*.ps1' -Recurse ) `
	-CodeCoverageOutputFile ( '.\tests\results\{0}CodeCoverageResults.xml' -f $ciName ) `
	-CodeCoverageOutputFileFormat 'JaCoCo' `
	-PassThru

If ( $ciName -eq 'AppVeyor' )
{
	( New-Object -TypeName 'System.Net.WebClient' ).UploadFile( 
		( 'https://ci.appveyor.com/api/testresults/nunit/{0}' -f $env:APPVEYOR_JOB_ID ), 
		( Resolve-Path -Path '.\tests\results\AppVeyorTestsResults.xml' )
	)

	$coverage = Format-Coverage -PesterResults $testsResults -CoverallsApiToken $env:CoverallsApiKey -BranchName $env:APPVEYOR_REPO_BRANCH

	Publish-Coverage -Coverage $coverage
}

If ( $testsResults.FailedCount -gt 0 )
{
	Throw ( '{0} tests failed.' -f $testsResults.FailedCount )
}
