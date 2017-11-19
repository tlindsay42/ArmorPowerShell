If ( $env:APPVEYOR_REPO_BRANCH -ne 'master' )
{
	Write-Warning -Message ( 'Skipping publish for branch {0}' -f $env:APPVEYOR_REPO_BRANCH )
}
ElseIf ( $env:APPVEYOR_PULL_REQUEST_NUMBER -gt 0 )
{
	Write-Warning -Message ( 'Skipping publish for pull request {0}' -f $env:APPVEYOR_PULL_REQUEST_NUMBER )
}
Else
{
	# Publish the new version to the PowerShell Gallery
	Publish-Module -Path $env:MODULE_PATH -NuGetApiKey $env:NUGET_API_KEY -ErrorAction 'Stop'
	Write-Host -Object ( '`n{0} Module version {1} published to the PowerShell Gallery.`n' -f $env:APPVEYOR_PROJECT_NAME, $env:MODULE_VERSION ) -ForegroundColor 'Yellow'
}
