Param
(
	[Parameter( Position = 0 )]
	[ValidateSet( 'AppVeyor', 'Travis' )]
	[String] $ciName = ''
)

Write-Host -Object "`nInvoking Pester test framework." -ForegroundColor 'Yellow'
$testsResults = Invoke-Pester -Path './tests' `
	-OutputFormat NUnitXml `
	-OutputFile ( './tests/results/{0}TestsResults.xml' -f $ciName ) `
	-CodeCoverage ( Get-ChildItem -Path './Armor' -Include '*.ps1' -Recurse ) `
	-CodeCoverageOutputFile ( './tests/results/{0}CodeCoverageResults.xml' -f $ciName ) `
	-CodeCoverageOutputFileFormat 'JaCoCo' `
	-PassThru

If ( $ciName -eq 'AppVeyor' )
{
	( New-Object -TypeName 'System.Net.WebClient' ).UploadFile( 
		( 'https://ci.appveyor.com/api/testresults/nunit/{0}' -f $env:APPVEYOR_JOB_ID ), 
		( Resolve-Path -Path './tests/results/AppVeyorTestsResults.xml' )
	)
}

If ( $testsResults.FailedCount -gt 0 )
{
	Throw ( '{0} tests failed.' -f $testsResults.FailedCount )
}
