If ( $env:APPVEYOR -eq $true )
{
	$buildPath = $env:APPVEYOR_BUILD_FOLDER

	$version = $env:APPVEYOR_BUILD_VERSION
}
ElseIf ( $env:TRAVIS -eq $true )
{
	$buildPath = $env:TRAVIS_BUILD_DIR
}
Else { Throw 'Unknown continuous integration environment.' }

$modulePath = '{0}\Armor' -f $buildPath
If ( ( Test-Path -Path $modulePath ) -eq $false ) { Throw ( 'Module directory: "{0}" not found.' -f $modulePath ) }

Try
{
	Write-Host -Object ( "`nSet the working directory to {0}" -f $modulePath ) -ForegroundColor 'Yellow'
	Push-Location -Path $modulePath -ErrorAction Stop

	$manifestPath = '{0}\Armor.psd1' -f $modulePath

	Write-Host -Object "`nTest and import the module manifest." -ForegroundColor 'Yellow'
	$manifest = Test-ModuleManifest -Path $manifestPath

	If ( $env:TRAVIS -eq $true )
	{
		$version = '{0}.{1}.{2}.{3}' -f 
		$manifest.Version.Major,
		$manifest.Version.Minor,
		$manifest.Version.Build,
		( $manifest.Version.Revision + 1 )
	}

	Write-Host -Object ( "`nOld Version- {0}" -f $manifest.Version )
	Write-Host -Object ( 'New Version- {0}' -f $version )

	Write-Host -Object "`nUpdate the module manifest." -ForegroundColor 'Yellow'
	Update-ModuleManifest `
		-Path $manifestPath `
		-RootModule 'Armor.psm1' `
		-ModuleVersion $version `
		-Guid '226c1ea9-1078-402a-861c-10a845a0d173' `
		-Author 'Troy Lindsay' `
		-CompanyName 'Armor' `
		-Copyright '(c) 2017 Troy Lindsay. All rights reserved.' `
		-Description (
			'This is a community project that provides a powerful command-line interface via a Microsoft PowerShell ' +
			'module for managing, monitoring, and automating many aspects of your Armor Complete and Armor Anywhere ' +
			'environments, including firewalls, VMs, and more.'
		) `
		-PowerShellVersion '5.0' `
		-ProcessorArchitecture 'None' `
		-FunctionsToExport ( Get-ChildItem -Path ( '{0}\Public' -f $modulePath ) ).BaseName `
		-FileList (
			Get-ChildItem -File -Recurse |
			Resolve-Path -Relative
		) `
		-Tags (
			'Armor', 'Defense', 'Cloud', 'Security', 'Performance', 'Complete', 'Anywhere',
			'Compliant', 'PCI-DSS', 'HIPAA', 'HITRUST', 'IaaS', 'SaaS'
		) `
		-LicenseUri 'https://github.com/tlindsay42/ArmorPowerShell/blob/master/LICENSE' `
		-IconUri 'http://i.imgur.com/fbXjkCn.png'

	Write-Host -Object "`nAdjust a couple of PowerShell manifest auto-generated items." -ForegroundColor 'Yellow'
	( Get-Content -Path $manifestPath ) -replace 'PSGet_Armor', 'Armor' |
		ForEach-Object -Process { $_ -replace 'NewManifest', 'Armor' } |
		Set-Content -Path $manifestPath

	Write-Host -Object "`nTest and import the module manifest again." -ForegroundColor 'Yellow'
	$manifest = Test-ModuleManifest -Path $manifestPath

	Pop-Location
	Write-Host -Object ( "`nRestored the working directory to '{0}'.`n" -f ( Get-Location ) ) -ForegroundColor 'Yellow'
}
Catch
{
	Throw $_
}

Write-Host -Object "`nImport module: 'Armor'"
Import-Module -Name ( '{0}\Armor.psm1' -f $modulePath ) -Force

# Update the docs
Write-Host -Object "`nBuilding the documentation." -ForegroundColor 'Yellow'
$content = @()
$content += 'Welcome to the Armor PowerShell Module
========================

.. image:: https://ci.appveyor.com/api/projects/status/x4ik2enxvdc5h0x6/branch/master?svg=true
   :target: https://ci.appveyor.com/project/tlindsay42/armorpowershell
   :alt: Windows PowerShell Status

.. image:: https://travis-ci.org/tlindsay42/armorpowershell.svg?branch=master
   :target: https://travis-ci.org/tlindsay42/armorpowershell
   :alt: PowerShell Core Status

.. image:: http://readthedocs.org/projects/armorpowershell/badge/?version=latest
   :target: http://armorpowershell.readthedocs.io/en/latest/?badge=latest
   :alt: Documentation Status

{0}  The code is open source, and `available on GitHub`_.

.. _available on GitHub: https://github.com/tlindsay42/ArmorPowerShell

.. toctree::
   :maxdepth: 2
   :hidden:
   :caption: User Documentation

   requirements
   installation
   getting_started
   project_architecture
   support
   contribution
   licensing
   faq

.. toctree::
   :maxdepth: 2
   :hidden:
   :caption: Command Documentation
   ' -f $manifest.Description

# Build the command documentation menu
ForEach ( $verb In ( Get-Command -Module Armor ).Verb | Select-Object -Unique )
{
	$content += '   cmd_{0}' -f $verb.ToLower()
}

$content += ''

# Write the index file
$content.ToString() |
	Out-File -FilePath ( '{0}\docs\index.rst' -f $buildPath ) -Encoding utf8

Write-Host -Object '   index'

# Build the command documentation files for each verb
ForEach ( $verb In ( Get-Command -Module Armor ).Verb | Select-Object -Unique )
{
	$content = @()
	$content += '{0} Commands' -f $verb
	$content += '========================='
	$content += 'This page contains details on **{0}** commands.' -f $verb
	$content += ''

	# Build the command documentation from the comment-based help
	ForEach ( $command In ( Get-Command -Module Armor ).Where( { $_.Verb -eq $verb } ) )
 {
		$content += $command.Name
		$content += '-------------------------'
		$content += Get-Help -Name $command.name -Detailed
		$content += ''
	}

	$content.ToString() |
		Out-File -FilePath ( '{0}\docs\cmd_{1}.rst' -f $buildPath, $verb.ToLower() ) -Encoding utf8

	Write-Host -Object ( '   cmd_ {0}' -f $verb.ToLower() )
}
