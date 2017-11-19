$text = @{
	'AppVeyor'              = 'AppVeyor'
	'AppVeyorImageUrl'      = 'https://ci.appveyor.com/api/projects/status/x4ik2enxvdc5h0x6/branch/master?svg=true'
	'AppVeyorProjectUrl'    = 'https://ci.appveyor.com/project/{0}/{1}/branch/master' -f $env:OWNER_NAME, $env:PROJECT_NAME
	'ArmorAnywhere'         = 'Armor Anywhere'
	'ArmorAnywhereUrl'      = 'https://www.armor.com/armor-anywhere-security/'
	'ArmorApiGuideUrl'      = 'https://docs.armor.com/display/KBSS/Armor+API+Guide'
	'ArmorComplete'         = 'Armor Complete'
	'ArmorCompleteUrl'      = 'https://www.armor.com/armor-complete-secure-hosting/'
	'BoldForm'              = '**{0}**'
	'BuildStatus'           = 'Build Status'
	'CoverageStatus'        = 'Coverage Status'
	'Coveralls'             = 'Coveralls'
	'CoverallsImageUrl'     = 'https://coveralls.io/repos/github/{0}/{1}/badge.svg?branch=master' -f $env:OWNER_NAME, $env:PROJECT_NAME
	'CoverallsProjectUrl'   = 'https://coveralls.io/github/{0}/{1}?branch=master' -f $env:OWNER_NAME, $env:PROJECT_NAME
	'DocumentationStatus'   = 'Documentation Status'
	'macOS'                 = 'macOS'
	'MdBoldLinkForm'        = "**[{0}]({1} '{2}')**"
	'MdLinkForm'            = "[{0}]({1} '{2}')"
	'Pester'                = 'Pester'
	'PesterUrl'             = 'https://github.com/pester/Pester'
	'PSGallery'             = 'PowerShell Gallery'
	'PSGalleryImageUrl'     = 'https://img.shields.io/badge/install-PS%20Gallery-blue.svg'
	'PSGalleryProjectUrl'   = 'https://www.powershellgallery.com/packages/{0}' -f $env:MODULE_NAME
	'ReadTheDocsImageUrl'   = 'https://readthedocs.org/projects/{0}/badge/?version=latest' -f $env:PROJECT_NAME.ToLower()
	'ReadTheDocsProjectUrl' = 'http://{0}.readthedocs.io/en/latest/?badge=latest' -f $env:PROJECT_NAME.ToLower()
	'RepoUrl'               = 'https://github.com/{0}/{1}' -f $env:OWNER_NAME, $env:PROJECT_NAME
	'RestfulApi'            = 'RESTful APIs'
	'RstLinkForm'           = '`{0}`_'
	'Title'                 = 'Armor PowerShell Module'
	'TravisCi'              = 'Travis CI'
	'TravisCiImageUrl'      = 'https://travis-ci.org/{0}/{1}.svg?branch=master' -f $env:OWNER_NAME, $env:PROJECT_NAME
	'TravisCiProjectUrl'    = 'https://travis-ci.org/{0}/{1}' -f $env:OWNER_NAME, $env:PROJECT_NAME
	'Ubuntu'                = 'Ubuntu Linux'
	'Windows'               = 'Windows'
}

If ( ( Test-Path -Path $env:MODULE_PATH ) -eq $false )
{
	Throw ( 'Module directory: "{0}" not found.' -f $env:MODULE_PATH )
}

Write-Host -Object ( "`nSet the working directory to: '{0}'." -f $env:MODULE_PATH ) -ForegroundColor 'Yellow'
Push-Location -Path $env:MODULE_PATH -ErrorAction Stop

$manifestPath = '{0}\{1}.psd1' -f $env:MODULE_PATH, $env:MODULE_NAME

Write-Host -Object "`nTest and import the module manifest." -ForegroundColor 'Yellow'
$manifest = Test-ModuleManifest -Path $manifestPath -ErrorAction Stop

If ( $env:TRAVIS -eq $true )
{
	$env:MODULE_VERSION = '{0}.{1}.{2}.{3}' -f $manifest.Version.Major, $manifest.Version.Minor, $manifest.Version.Build, ( $manifest.Version.Revision + 1 )
}

Write-Host -Object ( "`nOld Version: '{0}'." -f $manifest.Version )
Write-Host -Object ( "New Version: '{0}'." -f $env:MODULE_VERSION )

Write-Host -Object "`nUpdate the module manifest." -ForegroundColor 'Yellow'

$description = 'This is a community project that provides a powerful command-line interface for managing and monitoring your {0} (secure public cloud) and {1} (security as a service) environments & accounts via a PowerShell module with cmdlets that interact with the published {2}.

Every code push is built on {3} via {4}, as well as on {5} and {6} via {7}, and tested using the {8} test & mock framework.

Code coverage scores and reports showing how much of the project is covered by automated unit tests are tracked by {9}.

Every successful build is published on the {10}.' -f
$text.ArmorComplete, #0
$text.ArmorAnywhere, #1
$text.RestfulApi, #2
$text.Windows, #3
$text.AppVeyor, #4
$text.macOS, #5
$text.Ubuntu, #6
$text.TravisCi, #7
$text.Pester, #8
$text.Coveralls, #9
$text.PSGallery #10

Update-ModuleManifest `
	-Path $manifestPath `
	-RootModule ( '{0}.psm1' -f $env:MODULE_NAME ) `
	-ModuleVersion $env:MODULE_VERSION `
	-Guid '226c1ea9-1078-402a-861c-10a845a0d173' `
	-Author 'Troy Lindsay' `
	-CompanyName 'Armor' `
	-Copyright '(c) 2017 Troy Lindsay. All rights reserved.' `
	-Description $description `
	-PowerShellVersion '5.0' `
	-ProcessorArchitecture 'None' `
	-FunctionsToExport ( Get-ChildItem -Path ( '{0}\Public' -f $env:MODULE_PATH ) ).BaseName `
	-FileList ( Get-ChildItem -File -Recurse | Resolve-Path -Relative ) `
	-Tags 'Armor', 'Defense', 'Cloud', 'Security', 'DevOps', 'Scripting', 'Automation', 'Performance',
		'Complete', 'Anywhere', 'Compliant', 'PCI-DSS', 'HIPAA', 'HITRUST', 'GDPR', 'IaaS', 'SaaS' `
	-LicenseUri ( '{0}/blob/master/LICENSE' -f $text.RepoUrl ) `
	-IconUri 'http://i.imgur.com/fbXjkCn.png' `
	-ErrorAction Stop

Write-Host -Object "`nAdjust a couple of PowerShell manifest auto-generated items." -ForegroundColor 'Yellow'
( Get-Content -Path $manifestPath ) `
	-replace ( 'PSGet_{0}|NewManifest' -f $env:MODULE_NAME ), $env:MODULE_NAME |
	Set-Content -Path $manifestPath -ErrorAction Stop

Write-Host -Object "`nTest and import the module manifest again." -ForegroundColor 'Yellow'
$manifest = Test-ModuleManifest -Path $manifestPath -ErrorAction Stop

Pop-Location -ErrorAction Stop
Write-Host -Object ( "`nRestored the working directory to: '{0}'.`n" -f ( Get-Location ) ) -ForegroundColor 'Yellow'

Write-Host -Object ( "Import module: '{0}'." -f $env:MODULE_NAME ) -ForegroundColor 'Yellow'
Import-Module -Name ( '{0}\{1}.psm1' -f $env:MODULE_PATH, $env:MODULE_NAME ) -Force

# Update the docs
Write-Host -Object "`nBuilding the documentation." -ForegroundColor 'Yellow'

# Build README.md
$markDownDescription = $description `
	-replace $text.ArmorComplete, ( $text.MdBoldLinkForm -f $text.ArmorComplete, $text.ArmorCompleteUrl, ( '{0} Product Page' -f $text.ArmorComplete ) ) `
	-replace $text.ArmorAnywhere, ( $text.MdBoldLinkForm -f $text.ArmorAnywhere, $text.ArmorAnywhereUrl, ( '{0} Product Page' -f $text.ArmorAnywhere ) ) `
	-replace $text.RestfulApi, ( $text.MdLinkForm -f $text.RestfulApi, $text.ArmorApiGuideUrl, 'Armor API Guide' ) `
	-replace $text.Windows, ( $text.BoldForm -f $text.Windows ) `
	-replace $text.AppVeyor, ( $text.MdLinkForm -f $text.AppVeyor, $text.AppVeyorProjectUrl, ( '{0}: {1}: latest build console' -f $text.AppVeyor, $env:PROJECT_NAME ) ) `
	-replace $text.macOS, ( $text.BoldForm -f $text.macOS ) `
	-replace $text.Ubuntu, ( $text.BoldForm -f $text.Ubuntu ) `
	-replace $text.TravisCi, ( $text.MdLinkForm -f $text.TravisCi, $text.TravisCiProjectUrl, ( '{0}: {1}: latest build console' -f $text.TravisCi, $env:PROJECT_NAME ) ) `
	-replace $text.Pester, ( $text.MdLinkForm -f $text.Pester, $text.PesterUrl, ( '{0} GitHub repo' -f $text.Pester ) ) `
	-replace $text.Coveralls, ( $text.MdLinkForm -f $text.Coveralls, $text.CoverallsProjectUrl, ( '{0}: {1}: latest report' -f $text.Coveralls, $env:PROJECT_NAME ) ) `
	-replace $text.PSGallery, ( "[{0}]({1})" -f $text.PSGallery, $text.PSGalleryProjectUrl )

$content = @()
$content += "# {0}

[![{1}]({2})]({3}) [![{1}]({4})]({5}) [![{6}]({7})]({8}) [![{9}]({10})]({11}) [![{12}]({13})]({14})

{15}

Please visit the **[full documentation]({11})** for more details." -f
$text.Title, #0
$text.BuildStatus, #1
$text.AppVeyorImageUrl, #2
$text.AppVeyorProjectUrl, #3
$text.TravisCiImageUrl, #4
$text.TravisCiProjectUrl, #5
$text.CoverageStatus, #6
$text.CoverallsImageUrl, #7
$text.CoverallsProjectUrl, #8
$text.DocumentationStatus, #9
$text.ReadTheDocsImageUrl, #10
$text.ReadTheDocsProjectUrl, #11
$text.PSGallery, #12
$text.PSGalleryImageUrl, #13
$text.PSGalleryProjectUrl, #14
$markDownDescription <#15#> |
	Out-File -FilePath ( '{0}\README.md' -f $env:BUILD_PATH ) -Encoding utf8

# Build readthedocs.io index.rst
$reStructuredTextDescription = $description `
 -replace $text.ArmorComplete, ( $text.RstLinkForm -f $text.ArmorComplete ) `
 -replace $text.ArmorAnywhere, ( $text.RstLinkForm -f $text.ArmorAnywhere ) `
 -replace $text.RestfulApi, ( $text.RstLinkForm -f $text.RestfulApi ) `
 -replace $text.Windows, ( $text.BoldForm -f $text.Windows ) `
 -replace $text.AppVeyor, ( $text.RstLinkForm -f $text.AppVeyor ) `
 -replace $text.macOS, ( $text.BoldForm -f $text.macOS ) `
 -replace $text.Ubuntu, ( $text.BoldForm -f $text.Ubuntu ) `
 -replace $text.TravisCi, ( $text.RstLinkForm -f $text.TravisCi ) `
 -replace $text.Pester, ( $text.RstLinkForm -f $text.Pester ) `
 -replace $text.Coveralls, ( $text.RstLinkForm -f $text.Coveralls ) `
 -replace $text.PSGallery, ( $text.RstLinkForm -f $text.PSGallery )

$content = @()
$content += '{0}
========================

.. image:: {2}
   :target: {3}
   :alt: {1}

.. image:: {4}
   :target: {5}
   :alt: {1}

.. image:: {7}
   :target: {8}
   :alt: {6}

.. image:: {10}
   :target: {11}
   :alt: {9}

.. image:: {13}
   :target: {14}
   :alt: {12}

{15}

The source code is `available on GitHub`_.

.. _{16}: {17}

.. _{18}: {19}

.. _{20}: {21}

.. _{22}: {3}

.. _{23}: {5}

.. _{24}: {25}

.. _{26}: {27}

.. _{12}: {14}

.. _available on GitHub: {28}

.. toctree::
   :maxdepth: 2
   :hidden:
   :caption: User Documentation

' -f
$text.Title, #0
$text.BuildStatus, #1
$text.AppVeyorImageUrl, #2
$text.AppVeyorProjectUrl, #3
$text.TravisCiImageUrl, #4
$text.TravisCiProjectUrl, #5
$text.CoverageStatus, #6
$text.CoverallsImageUrl, #7
$text.CoverallsProjectUrl, #8
$text.DocumentationStatus, #9
$text.ReadTheDocsImageUrl, #10
$text.ReadTheDocsProjectUrl, #11
$text.PSGallery, #12
$text.PSGalleryImageUrl, #13
$text.PSGalleryProjectUrl, #14
$reStructuredTextDescription, #15
$text.ArmorComplete, #16
$text.ArmorCompleteUrl, #17
$text.ArmorAnywhere, #18
$text.ArmorAnywhereUrl, #19
$text.RestfulApi, #20
$text.ArmorApiGuideUrl, #21
$text.AppVeyor, #22
$text.TravisCi, #23
$text.Pester, #24
$text.PesterUrl, #25
$text.Coveralls, #26
$text.CoverallsProjectUrl, #27
$repoUrl #28

ForEach ( $fileName In ( Get-ChildItem -Path .\docs ).Where( { $_.Name -match '^usr_\d\d_.*.rst$' } ).Name )
{
	$content += '   {0}' -f $fileName.ToLower()
}

$content += '

.. toctree::
   :maxdepth: 2
   :hidden:
   :caption: Command Documentation
   '

# Build the command documentation menu
ForEach ( $verb In ( Get-Command -Module $env:MODULE_NAME ).Verb | Select-Object -Unique )
{
	$content += '   cmd_{0}' -f $verb.ToLower()
}

$content += ''

# Write the index file
$content |
	Out-File -FilePath ( '{0}\docs\index.rst' -f $env:BUILD_PATH ) -Encoding utf8

Write-Host -Object '   index'

# Build the command documentation files for each verb
ForEach ( $verb In ( Get-Command -Module $env:MODULE_NAME ).Verb | Select-Object -Unique )
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
		Out-File -FilePath ( '{0}\docs\cmd_{1}.rst' -f $env:BUILD_PATH, $verb.ToLower() ) -Encoding utf8

	Write-Host -Object ( '   cmd_{0}' -f $verb.ToLower() )
}

Write-Host -Object ''
