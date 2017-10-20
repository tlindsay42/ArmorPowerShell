# Line break for readability in AppVeyor console
Write-Host -Object ''

# Make sure we're using the Master branch and that it's not a pull request
# Environmental Variables Guide: https://www.appveyor.com/docs/environment-variables/
If ( $env:APPVEYOR_REPO_BRANCH -ne 'master' )
{
	Write-Warning -Message ( 'Skipping version increment and publish for branch {0}.' -f $env:APPVEYOR_REPO_BRANCH )
}
ElseIf ( $env:APPVEYOR_PULL_REQUEST_NUMBER -gt 0 )
{
	Write-Warning -Message ( 'Skipping version increment and publish for pull request #{0}' -f $env:APPVEYOR_PULL_REQUEST_NUMBER )
}
Else
{
	# We're going to add 1 to the revision value since a new commit has been merged to Master
	# This means that the major / minor / build values will be consistent across GitHub and the Gallery
	Try
	{
		# This is where the module manifest lives
		$manifestPath = '.\Armor\Armor.psd1'

		# Start by importing the manifest to determine the version, then add 1 to the revision
		$manifest = Test-ModuleManifest -Path $manifestPath
		[System.Version] $version = $manifest.Version
		Write-Host -Object ( 'Old Version: {0}' -f $version )

		[String] $newVersion = New-Object -TypeName 'System.Version' -ArgumentList ( $version.Major, $version.Minor, $version.Build, ( $version.Revision + 1 ) )
		Write-Host -Object ( 'New Version: {0}' -f $newVersion )

		# Update the manifest with the new version value and fix the weird string replace bug
		$functionList = ( Get-ChildItem -Path .\Armor\Public ).BaseName

		Update-ModuleManifest `
			-Path $manifestPath `
			-RootModule 'Armor.psm1' `
			-ModuleVersion $newVersion `
			-Guid '226c1ea9-1078-402a-861c-10a845a0d173' `
			-Author 'Troy Lindsay' `
			-CompanyName 'Armor' `
			-Copyright '(c) 2017 Troy Lindsay. All rights reserved.' `
			-Description 'This is a community project that provides a Windows PowerShell module for managing and monitoring your Armor Complete and Anywhere environments.' `
			-PowerShellVersion '4.0' `
			-ProcessorArchitecture 'None' `
			-FunctionsToExport $functionList `
			-VariablesToExport global:ArmorConnection `
			-FileList ( ( Get-ChildItem -Path '.\Armor' -File -Recurse ).Name.ForEach( { "'{0}'" -f $_ } ) -join ', ' ) `
			-Tags 'Armor', 'Defense', 'Security', 'Complete', 'Anywhere', 'Secure', 'Cloud', 'Protect', 'Protection', 'Compliance', 'Compliant', 'PCI', 'DSS', 'HIPAA', 'Performance', 'Hosting', 'Hosted', 'Infrastructure', 'IaaS', 'SaaS', 'Amazon', 'AWS', 'Microsoft', 'Azure' `
			-LicenseUri 'https://github.com/tlindsay42/ArmorPowerShell/blob/master/LICENSE' `
			-IconUri 'http://i.imgur.com/fbXjkCn.png' `
			-HelpInfoUri 'https://github.com/tlindsay42/ArmorPowerShell'

		( Get-Content -Path $manifestPath ) -replace 'PSGet_Armor', 'Armor' |
			ForEach-Object -Process { $_ -replace 'NewManifest', 'Armor' } |
			Set-Content -Path $manifestPath
	}
	Catch
	{
		Throw $_
	}

	# Update the docs
	Write-Host -Object 'Building new documentation.' -ForegroundColor 'Yellow'
	. .\docs\BuildDocs.ps1
	Write-Host -Object ''

	# Publish the new version to the PowerShell Gallery
	Try
	{
		Publish-Module -Path '.\Armor' -NuGetApiKey $env:NuGetApiKey -ErrorAction 'Stop'
		Write-Host -Object ( 'Armor PowerShell Module version {0} published to the PowerShell Gallery.' -f $newVersion ) -ForegroundColor 'Cyan'
		#Write-Host -Object ( 'Armor PowerShell Module version {0} would be published to the PowerShell Gallery if enabled.' -f $newVersion ) -ForegroundColor 'Cyan'
	}
	Catch
	{
		# Sad panda; it broke
		Write-Warning -Message ( 'Failed to publish update {0} to the PowerShell Gallery.' -f $newVersion )
		Throw $_
	}

	# Publish the new version back to Master on GitHub
	Try
	{
		# Set up a path to the git.exe cmd, import posh-git to give us control over git, and then push changes to GitHub
		# Note that "update version" is included in the appveyor.yml file's "skip a build" regex to avoid a loop
		If ( ( '{0}\Git\cmd' -f $env:ProgramFiles ) -notin $env:Path.Split( ';' ).Trim() )
		{
			$env:Path += ';{0}\Git\cmd' -f $env:ProgramFiles
		}

		Import-Module -Name 'Posh-Git' -ErrorAction 'Stop'

		git checkout master
		git add --all
		git status
		git commit -s -m ( 'Update version to {0}' -f $newVersion )
		git push origin master

		Write-Host -Object ( 'Armor PowerShell Module version {0} published to GitHub.' -f $newVersion ) -ForegroundColor 'Cyan'
	}
	Catch
	{
		# Sad panda; it broke
		Write-Warning -Message ( 'Publishing update {0} to GitHub failed.' -f $newVersion )

		Throw $_
	}
}
