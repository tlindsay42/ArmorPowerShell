Try
{
	$manifestPath = './Armor/Armor.psd1'

	Write-Host -Object "`nTest and import the module manifest." -ForegroundColor 'Yellow'
	$manifest = Test-ModuleManifest -Path $manifestPath

	Write-Host -Object ( "`nOld Version- {0}" -f $manifest.Version )
	Write-Host -Object ( 'New Version- {0}' -f $env:APPVEYOR_BUILD_VERSION )

	Write-Host -Object "`nUpdate the module manifest." -ForegroundColor 'Yellow'
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
		-FunctionsToExport ( Get-ChildItem -Path './Armor/Public' ).BaseName `
		-FileList ( Get-ChildItem -Path './Armor' -File -Recurse | Resolve-Path -Relative ) `
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
}
Catch
{
	Throw $_
}

Write-Host -Object "`nImport module: 'Armor'"
Import-Module -Name './Armor/Armor.psm1' -Force

# Update the docs
Write-Host -Object "`nBuilding the documentation." -ForegroundColor 'Yellow'
$content = (
	"Welcome to the Armor PowerShell Module`r`n" +
	"========================`r`n`r`n" +
	".. image:: Windows PowerShell https://ci.appveyor.com/api/projects/status/x4ik2enxvdc5h0x6?svg=true`r`n" +
	"   :target: https://ci.appveyor.com/project/tlindsay42/armorpowershell`r`n`r`n" +
	".. image:: PowerShell Core https://travis-ci.org/tlindsay42/ArmorPowerShell.svg?branch=master`r`n" +
	"   :target: https://travis-ci.org/tlindsay42/armorpowershell`r`n`r`n" +
	".. image:: http://readthedocs.org/projects/armorpowershell/badge/?version=latest`r`n" +
	"   :target: http://armorpowershell.readthedocs.io/en/latest/?badge=latest`r`n`r`n" +
	$manifest.Description +
	"  The code is open source, and ``available on GitHub``_.`r`n`r`n" +
	".. _available on GitHub: https://github.com/tlindsay42/ArmorPowerShell`r`n`r`n" +
	".. toctree::`r`n" +
	":maxdepth: 2`r`n" +
	":hidden:`r`n" +
	":caption: User Documentation`r`n`r`n" +
	"   requirements`r`n" +
	"   installation`r`n" +
	"   getting_started`r`n" +
	"   project_architecture`r`n" +
	"   support`r`n" +
	"   contribution`r`n" +
	"   licensing`r`n" +
	"   faq`r`n`r`n" +
	".. toctree::`r`n" +
	":maxdepth: 2`r`n" +
	":hidden:`r`n" +
	":caption: Command Documentation`r`n`r`n"
)

# Build the command documentation menu
ForEach ( $verb In ( Get-Command -Module Armor ).Verb | Select-Object -Unique )
{
	$content += "   cmd_{0}`r`n" -f $verb.ToLower()
}

$content += "`r`n"

# Write the index file
$content |
	Out-File -FilePath './docs/index.rst' -Encoding utf8

Write-Host -Object "`tindex"

# Build the command documentation files for each verb
ForEach ( $verb In ( Get-Command -Module Armor ).Verb | Select-Object -Unique )
{
	$content = @()
	$content += '{0} Commands' -f $verb
	$content += "=========================`r`n"
	$content += "This page contains details on **{0}** commands.`r`n" -f $verb

	# Build the command documentation from the comment-based help
	ForEach ( $command In ( Get-Command -Module Armor ).Where( { $_.Verb -eq $verb } ) )
 {
		$content += $command.Name
		$content += "-------------------------`r`n"
		$content += Get-Help -Name $command.name -Detailed
		$content += ''
	}

	$content |
		Out-File -FilePath ( './docs/cmd_{0}.rst' -f $verb.ToLower() ) -Encoding utf8

	Write-Host -Object ( "`tcmd_ {0}" -f $verb.ToLower() )
}

Write-Host -Object ''
