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
	Write-Host -Object ( "`nSet the working directory to: '{0}'." -f $modulePath ) -ForegroundColor 'Yellow'
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

	Write-Host -Object ( "`nOld Version: '{0}'." -f $manifest.Version )
	Write-Host -Object ( "New Version: '{0}'." -f $version )

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
			'This is a community project that provides a powerful command-line interface for managing and monitoring your ' +
			'Armor Complete (secure public cloud) and Armor Anywhere (security as a service) environments & accounts via a ' +
			'PowerShell module with cmdlets that interact with the published RESTful APIs.  It is continuously tested on ' +
			'Windows via AppVeyor, as well as on macOS and Linux via Travis CI.'
		) `
		-PowerShellVersion '5.0' `
		-ProcessorArchitecture 'None' `
		-FunctionsToExport ( Get-ChildItem -Path ( '{0}\Public' -f $modulePath ) ).BaseName `
		-FileList (
			Get-ChildItem -File -Recurse |
				Resolve-Path -Relative
		) `
		-Tags (
			'Armor', 'Defense', 'Cloud', 'Security', 'DevOps', 'Scripting', 'Automation', 'Performance',
			'Complete', 'Anywhere', 'Compliant', 'PCI-DSS', 'HIPAA', 'HITRUST', 'GDPR', 'IaaS', 'SaaS'
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
	Write-Host -Object ( "`nRestored the working directory to: '{0}'.`n" -f ( Get-Location ) ) -ForegroundColor 'Yellow'
}
Catch
{
	Throw $_
}

Write-Host -Object "Import module: 'Armor'." -ForegroundColor 'Yellow'
Import-Module -Name ( '{0}\Armor.psm1' -f $modulePath ) -Force

# Update the docs
Write-Host -Object "`nBuilding the documentation." -ForegroundColor 'Yellow'
$content = @()
$content += "# Armor PowerShell Module

[![Build status](https://ci.appveyor.com/api/projects/status/x4ik2enxvdc5h0x6/branch/master?svg=true)](https://ci.appveyor.com/project/tlindsay42/armorpowershell/branch/master) [![Build status](https://travis-ci.org/tlindsay42/ArmorPowerShell.svg?branch=master)](https://travis-ci.org/tlindsay42/ArmorPowerShell) [![Coverage Status](https://coveralls.io/repos/github/tlindsay42/ArmorPowerShell/badge.svg?branch=master)](https://coveralls.io/github/tlindsay42/ArmorPowerShell?branch=master) [![Documentation Status](https://readthedocs.org/projects/armorpowershell/badge/?version=latest)](http://armorpowershell.readthedocs.io/en/latest/?badge=latest) [![PS Gallery](https://img.shields.io/badge/install-PS%20Gallery-blue.svg)](https://www.powershellgallery.com/packages/Armor)

This is a community project that provides a powerful command-line interface for managing and monitoring your **[Armor Complete](https://www.armor.com/armor-complete-secure-hosting/ 'Armor Complete Product Page')** (secure public cloud) and **[Armor Anywhere](https://www.armor.com/armor-anywhere-security/ 'Armor Anywhere Product Page')** (security as a service) environments & accounts via a PowerShell module that interfaces with the published [RESTful APIs](https://docs.armor.com/display/KBSS/Armor+API+Guide 'Armor API Guide').

Every release is tested on **Windows** via [AppVeyor](https://ci.appveyor.com/project/tlindsay42/ArmorPowerShell), as well as on **macOS** and **Ubuntu Linux** via [Travis CI](https://travis-ci.org/tlindsay42/ArmorPowerShell), and it is published on the [PowerShell Gallery](https://www.powershellgallery.com/packages/Armor).

Please visit the **[full documentation](http://ArmorPowerShell.readthedocs.io/en/latest/)** for more details." |
	Out-File -FilePath ( '{0}\README.md' -f $buildPath ) -Encoding utf8

$content = @()
$content += 'Welcome to the Armor PowerShell Module
========================

.. image:: https://ci.appveyor.com/api/projects/status/x4ik2enxvdc5h0x6/branch/master?svg=true
   :target: https://ci.appveyor.com/project/tlindsay42/armorpowershell/branch/master
   :alt: Windows PowerShell Status

.. image:: https://travis-ci.org/tlindsay42/ArmorPowerShell.svg?branch=master
   :target: https://travis-ci.org/tlindsay42/ArmorPowerShell
   :alt: PowerShell Core Status

.. image:: https://coveralls.io/repos/github/tlindsay42/ArmorPowerShell/badge.svg?branch=master
   :target: https://coveralls.io/github/tlindsay42/ArmorPowerShell?branch=master
   :alt: Code Coverage Status

.. image:: https://readthedocs.org/projects/armorpowershell/badge/?version=latest
   :target: http://armorpowershell.readthedocs.io/en/latest/?badge=latest
   :alt: Documentation Status

.. image:: https://img.shields.io/badge/install-PS%20Gallery-blue.svg
   :target: https://www.powershellgallery.com/packages/armor
   :alt: PowerShell Gallery

This is a community project that provides a powerful command-line interface for managing and monitoring your `**Armor Complete**`_ (secure public cloud) and `**Armor Anywhere**`_ (security as a service) environments & accounts via a PowerShell module with cmdlets that interact with the published `RESTful APIs`_.

Every release is tested on **Windows** via `AppVeyor`_, as well as on **macOS** and **Ubuntu Linux** via `Travis CI`_, and it is published on the `PowerShell Gallery`_.

The source code is `available on GitHub`_.

.. _Armor Complete: https://www.armor.com/armor-complete-secure-hosting/

.. _Armor Anywhere: https://www.armor.com/armor-anywhere-security/

.. _RESTful APIs: https://docs.armor.com/display/KBSS/Armor+API+Guide

.. _AppVeyor: https://ci.appveyor.com/project/tlindsay42/ArmorPowerShell

.. _Travis CI: https://travis-ci.org/tlindsay42/ArmorPowerShell

.. _PowerShell Gallery: https://www.powershellgallery.com/packages/Armor

.. _available on GitHub: https://github.com/tlindsay42/ArmorPowerShell

.. toctree::
   :maxdepth: 2
   :hidden:
   :caption: User Documentation

   requirements
   install
	 update
	 uninstall
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
   '

# Build the command documentation menu
ForEach ( $verb In ( Get-Command -Module Armor ).Verb | Select-Object -Unique )
{
	$content += '   cmd_{0}' -f $verb.ToLower()
}

$content += ''

# Write the index file
$content |
	Out-File -FilePath ( '{0}\docs\index.rst' -f $buildPath ) -Encoding utf8

Write-Host -Object ( '{0}\docs\index.rst' -f $buildPath )

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

	$content |
		Out-File -FilePath ( '{0}\docs\cmd_{1}.rst' -f $buildPath, $verb.ToLower() ) -Encoding utf8

	Write-Host -Object ( '   cmd_{0}' -f $verb.ToLower() )
}

Write-Host -Object ''
