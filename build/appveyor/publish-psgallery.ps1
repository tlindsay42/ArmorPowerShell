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
	Try
	{
		Publish-Module -Path '.\Armor' -NuGetApiKey $env:NuGetApiKey -ErrorAction 'Stop'
		Write-Host -Object ( 'Armor PowerShell Module version {0} published to the PowerShell Gallery.' -f $newVersion ) -ForegroundColor 'Cyan'
	}
	Catch
	{
		Write-Warning -Message ( 'Failed to publish update {0} to the PowerShell Gallery.' -f $newVersion )
		Throw $_
	}
}
