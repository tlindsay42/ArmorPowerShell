Try
{
	$manifestPath = '.\Armor\Armor.psd1'

	Write-Host -Object 'Test and import the module manifest'
	$manifest = Test-ModuleManifest -Path $manifestPath

	Write-Host -Object ( "`nOld Version- {0}" -f $manifest.Version )
	Write-Host -Object ( 'New Version- {0}' -f $env:APPVEYOR_BUILD_VERSION )

	Write-Host -Object 'Update the module manifest'
	Update-ModuleManifest `
		-Path $manifestPath `
		-RootModule 'Armor.psm1' `
		-ModuleVersion $env:APPVEYOR_BUILD_VERSION `
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
		-FunctionsToExport ( Get-ChildItem -Path .\Armor\Public ).BaseName `
		-FileList ( Get-ChildItem -Path '.\Armor' -File -Recurse | Resolve-Path -Relative ) `
		-Tags (
			'Armor', 'Defense', 'Cloud', 'Security', 'Performance', 'Complete', 'Anywhere',
			'Compliant', 'PCI-DSS', 'HIPAA', 'HITRUST', 'IaaS', 'SaaS'
		) `
		-LicenseUri 'https://github.com/tlindsay42/ArmorPowerShell/blob/master/LICENSE' `
		-IconUri 'http://i.imgur.com/fbXjkCn.png'

	Write-Host -Object 'Adjust a couple of PowerShell manifest auto-generated items'
	( Get-Content -Path $manifestPath ) -replace 'PSGet_Armor', 'Armor' |
		ForEach-Object -Process { $_ -replace 'NewManifest', 'Armor' } |
		Set-Content -Path $manifestPath

	Write-Host -Object 'Test and import the module manifest again'
	$manifest = Test-ModuleManifest -Path $manifestPath
}
Catch
{
	Throw $_
}

Write-Host -Object 'Import module'
Import-Module -Name ( '{0}\..\..\Armor' -f $PSScriptRoot ) -Force

# Update the docs
Write-Host -Object "`nBuilding the documentation." -ForegroundColor 'Yellow'
Set-Content -Path '.\docs\index.rst' -Value (
	"Welcome to the Armor PowerShell Module`n" +
	"========================`n`n" +
	".. image:: Windows PowerShell https://ci.appveyor.com/api/projects/status/x4ik2enxvdc5h0x6?svg=true`n" +
	":target: https://ci.appveyor.com/project/tlindsay42/armorpowershell`n`n" +
	".. image:: PowerShell Core https://travis-ci.org/tlindsay42/ArmorPowerShell.svg?branch=master`n" +
	":target: https://travis-ci.org/tlindsay42/armorpowershell`n`n" +
	".. image:: http://readthedocs.org/projects/armorpowershell/badge/?version=latest`n" +
	":target: http://armorpowershell.readthedocs.io/en/latest/?badge=latest`n`n" +
	$manifest.Description +
	"  The code is open source, and ``available on GitHub``_.`n`n" +
	".. _available on GitHub: https://github.com/tlindsay42/ArmorPowerShell`n`n" +
	".. toctree::`n" +
	":maxdepth: 2`n" +
	":hidden:`n" +
	":caption: User Documentation`n`n" +
	"   requirements`n" +
	"   installation`n" +
	"   getting_started`n" +
	"   project_architecture`n" +
	"   support`n" +
	"   contribution`n" +
	"   licensing`n" +
	"   faq`n`n" +
	".. toctree::`n" +
	":maxdepth: 2`n" +
	":hidden:`n" +
	":caption: Command Documentation`n`n"
)

# Build the command documentation menu
ForEach ( $verb In ( Get-Command -Module Armor ).Verb | Select-Object -Unique )
{
	$content += "   cmd_{0}`n" -f $verb.ToLower()
}

$content += "`n"

# Write the index file
$content |
	Out-File -FilePath '.\docs\index.rst' -Encoding utf8

Write-Host -Object "`tindex"

# Build the command documentation files for each verb
ForEach ( $verb In ( Get-Command -Module Armor ).Verb | Select-Object -Unique )
{
	$content = @()
	$content += '{0} Commands' -f $verb
	$content += "=========================`n"
	$content += "This page contains details on **{0}** commands.`n" -f $verb

	# Build the command documentation from the comment-based help
	ForEach ( $command In ( Get-Command -Module Armor ).Where( { $_.Verb -eq $verb } ) )
 {
		$content += $command.Name
		$content += "-------------------------`n"
		$content += Get-Help -Name $command.name -Detailed
		$content += ''
	}

	$content |
		Out-File -FilePath ( '.\docs\cmd_{0}.rst' -f $verb.ToLower() ) -Encoding utf8

	Write-Host -Object ( "`tcmd_ {0}" -f $verb.ToLower() )
}

Write-Host -Object ''
