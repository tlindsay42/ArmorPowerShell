$projectNameLowerCase = $Env:CI_PROJECT_NAME.ToLower()

$text = @{
    'AppVeyor'              = 'AppVeyor'
    'AppVeyorImageUrl'      = 'https://ci.appveyor.com/api/projects/status/x4ik2enxvdc5h0x6/branch/master?svg=true'
    'AppVeyorProjectUrl'    = "https://ci.appveyor.com/project/${Env:CI_OWNER_NAME}/${Env:CI_PROJECT_NAME}/branch/master"
    'ArmorAnywhere'         = 'Armor Anywhere'
    'ArmorAnywhereUrl'      = 'https://www.armor.com/armor-anywhere-security/'
    'ArmorApiGuideUrl'      = 'https://docs.armor.com/display/KBSS/Armor+API+Guide'
    'ArmorComplete'         = 'Armor Complete'
    'ArmorCompleteUrl'      = 'https://www.armor.com/armor-complete-secure-hosting/'
    'AvailableOnGitHub'     = 'available on GitHub'
    'BoldForm'              = '**{0}**'
    'BuildStatus'           = 'Build Status'
    'CoverageStatus'        = 'Coverage Status'
    'Coveralls'             = 'Coveralls'
    'CoverallsImageUrl'     = "https://coveralls.io/repos/github/${Env:CI_OWNER_NAME}/${Env:CI_PROJECT_NAME}/badge.svg?branch=master"
    'CoverallsProjectUrl'   = "https://coveralls.io/github/${Env:CI_OWNER_NAME}/${Env:CI_PROJECT_NAME}?branch=master"
    'CurrentVersion'        = 'Current Version'
    'DocumentationStatus'   = 'Documentation Status'
    'GitHubPages'           = 'GitHubPages'
    'GitHubPagesProjectUrl' = "https://${Env:CI_OWNER_NAME}.github.io/${Env:CI_PROJECT_NAME}/"
    'Gitter'                = 'Gitter'
    'GitterImageAlt'        = "Join the chat at https://gitter.im/${Env:CI_PROJECT_NAME}/Lobby"
    'GitterImageUrl'        = "https://badges.gitter.im/${Env:CI_PROJECT_NAME}/Lobby.svg"
    'GitterProjectUrl'      = "https://gitter.im/${Env:CI_PROJECT_NAME}/Lobby?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge"
    'LatestBuild'           = "${Env:CI_PROJECT_NAME}: Latest Build"
    'macOS'                 = 'macOS'
    'MdBoldLinkForm'        = "**[{0}]({1} '{2}')**"
    'MdImageForm'           = '[![{0}]({1})]({2})'
    'MdLinkForm'            = "[{0}]({1} '{2}')"
    'Pester'                = 'Pester'
    'PesterUrl'             = 'https://github.com/pester/Pester'
    'ProductPage'           = 'Product Page'
    'PSDownloadsImageUrl'   = "https://img.shields.io/powershellgallery/dt/${Env:CI_MODULE_NAME}.svg"
    'PSGallery'             = 'PowerShell Gallery'
    'PSGalleryImageUrl'     = "https://img.shields.io/powershellgallery/v/${Env:CI_MODULE_NAME}.svg"
    'PSGalleryProjectUrl'   = "https://www.powershellgallery.com/packages/${Env:CI_MODULE_NAME}"
    'RepoUrl'               = "https://github.com/${Env:CI_OWNER_NAME}/${Env:CI_PROJECT_NAME}"
    'RestfulApi'            = 'RESTful APIs'
    'Title'                 = 'The Armor Community PowerShell Module'
    'TotalDownloads'        = 'Total Downloads'
    'TravisCi'              = 'Travis CI'
    'TravisCiImageUrl'      = "https://travis-ci.org/${Env:CI_OWNER_NAME}/${Env:CI_PROJECT_NAME}.svg?branch=master"
    'TravisCiProjectUrl'    = "https://travis-ci.org/${Env:CI_OWNER_NAME}/${Env:CI_PROJECT_NAME}"
    'Ubuntu'                = 'Ubuntu Linux'
    'Windows'               = 'Windows'
}

# Add formatted versions of entries above
$text += @{
    'LatestBuildConsole' = "$( $text.LatestBuild ) Console"
}

# Add more formatted versions of entries above
$text += @{
    'AppVeyorMdLinkTitle'      = "$( $text.AppVeyor ): $( $text.LatestBuildConsole )"
    'ArmorAnywhereMdLinkTitle' = "$( $text.ArmorAnywhere ) $( $text.ProductPage )"
    'ArmorCompleteMdLinkTitle' = "$( $text.ArmorComplete ) $( $text.ProductPage )"
    'CoverallsMdLinkTitle'     = "$( $text.Coveralls ): ${Env:CI_PROJECT_NAME}: Latest Report"
    'GitHubPagesMdLinkTitle'   = "$( $text.GitHubPages ): $( $text.LatestBuild )"
    'PesterMdLinkTitle'        = "$( $text.Pester ) GitHub repo"
    'PSGalleryMdLinkTitle'     = $text.PSGallery
    'RestfulApiMdLinkTitle'    = 'Armor API Guide'
    'TravisCiMdLinkTitle'      = "$( $text.TravisCi ): $( $text.LatestBuildConsole )"
}

# Add more formatted versions of entries above
$text += @{
    'AppVeyorMd'           = $text.MdLinkForm -f $text.AppVeyor, $text.AppVeyorProjectUrl, $text.AppVeyorMdLinkTitle
    'AppVeyorMdShield'     = $text.MdImageForm -f $text.BuildStatus, $text.AppVeyorImageUrl, $text.AppVeyorProjectUrl
    'ArmorAnywhereMd'      = $text.MdBoldLinkForm -f $text.ArmorAnywhere, $text.ArmorAnywhereUrl, $text.ArmorAnywhereMdLinkTitle
    'ArmorCompleteMd'      = $text.MdBoldLinkForm -f $text.ArmorComplete, $text.ArmorCompleteUrl, $text.ArmorCompleteMdLinkTitle
    'CoverallsMd'          = $text.MdLinkForm -f $text.Coveralls, $text.CoverallsProjectUrl, $text.CoverallsMdLinkTitle
    'CoverallsMdShield'    = $text.MdImageForm -f $text.CoverageStatus, $text.CoverallsImageUrl, $text.CoverallsProjectUrl
    'GitHubPagesMd'        = $text.MdBoldLinkForm -f 'full documentation', $text.GitHubPagesProjectUrl, $text.GitHubPagesMdLinkTitle
    'GitterMdShield'       = $text.MdImageForm -f $text.GitterImageAlt, $text.GitterImageUrl, $text.GitterProjectUrl
    'macOSBold'            = $text.BoldForm -f $text.macOS
    'PesterMd'             = $text.MdLinkForm -f $text.Pester, $text.PesterUrl, $text.PesterMdLinkTitle
    'PSDownloadsMdShield'  = $text.MdImageForm -f $text.TotalDownloads, $text.PSDownloadsImageUrl, $text.PSGalleryProjectUrl
    'PSGalleryMd'          = $text.MdLinkForm -f $text.PSGallery, $text.PSGalleryProjectUrl, $text.PSGalleryMdLinkTitle
    'PSGalleryMdShield'    = $text.MdImageForm -f $text.CurrentVersion, $text.PSGalleryImageUrl, $text.PSGalleryProjectUrl
    'RestfulApiMd'         = $text.MdLinkForm -f $text.RestfulApi, $text.ArmorApiGuideUrl, $text.RestfulApiMdLinkTitle
    'TravisCiMd'           = $text.MdLinkForm -f $text.TravisCi, $text.TravisCiProjectUrl, $text.TravisCiMdLinkTitle
    'TravisCiMdShield'     = $text.MdImageForm -f $text.BuildStatus, $text.TravisCiImageUrl, $text.TravisCiProjectUrl
    'UbuntuBold'           = $text.BoldForm -f $text.Ubuntu
    'WindowsBold'          = $text.BoldForm -f $text.Windows
}

if ( ( Test-Path -Path $Env:CI_MODULE_PATH ) -eq $false ) {
    throw "Module directory: '${Env:CI_MODULE_PATH}' not found."
}

Write-Host -Object "`nSet the working directory to: '${Env:CI_MODULE_PATH}'." -ForegroundColor 'Yellow'
Push-Location -Path $Env:CI_MODULE_PATH -ErrorAction 'Stop'

Write-Host -Object "`nTest and import the module manifest." -ForegroundColor 'Yellow'
$manifest = Test-ModuleManifest -Path $Env:CI_MODULE_MANIFEST_PATH -ErrorAction 'Stop'

Write-Host -Object "`tOld Version: '$( $manifest.Version )'."
Write-Host -Object "`tNew Version: '${Env:CI_MODULE_VERSION}'."

Write-Host -Object "`nUpdate the module manifest." -ForegroundColor 'Yellow'

$year = ( Get-Date ).Year

$description = (
    'This is a community project that provides a powerful command-line interface for managing and monitoring ' +
    "your $( $text.ArmorComplete ) (secure public cloud) and $( $text.ArmorAnywhere ) (security as a service) " +
    'environments & accounts via a PowerShell module with cmdlets that interact with the published ' +
    "$( $text.RestfulApi ).`r`n`r`nEvery code push is built on $( $text.Windows ) via $( $text.AppVeyor ), as " +
    "well as on $( $text.macOS ) and $( $text.Ubuntu ) via $( $text.TravisCi ), and tested using the " +
    "$( $text.Pester ) test & mock framework.`r`n`r`nCode coverage scores and reports showing how much of the " +
    "project is covered by automated tests are tracked by $( $text.Coveralls ).`r`n`r`nEvery successful " +
    "build is published on the $( $text.PSGallery )."
)

$functionsToExport = ( Get-ChildItem -Path $Env:CI_MODULE_PUBLIC_PATH -ErrorAction 'Stop' ).BaseName

$fileList = Get-ChildItem -Path $Env:CI_MODULE_PATH -File -Recurse -ErrorAction 'Stop' |
    Resolve-Path -Relative -ErrorAction 'Stop'

$aliasesToExport = ( Get-Content -Path "${Env:CI_MODULE_ETC_PATH}/Aliases.json" -ErrorAction 'Stop' | ConvertFrom-Json -ErrorAction 'Stop' ).Name

$classesWithDependencies = Get-Content -Path "${Env:CI_MODULE_ETC_PATH}/ClassesWithDependenciesImportOrder.json" -ErrorAction 'Stop' |
    ConvertFrom-Json -ErrorAction 'Stop'

$scriptsToProcess = @()
$scriptsToProcess += Get-ChildItem -Path "${Env:CI_MODULE_LIB_PATH}/*.ps1" -Exclude $classesWithDependencies -File -ErrorAction 'Stop' |
    Resolve-Path -Relative

foreach ( $classWithDependencies in $classesWithDependencies ) {
    $scriptsToProcess += Get-ChildItem -Path "${Env:CI_MODULE_LIB_PATH}/${classWithDependencies}.ps1" -ErrorAction 'Stop'
}

$splat = @{
    'Path'                  = $Env:CI_MODULE_MANIFEST_PATH
    'RootModule'            = "${Env:CI_MODULE_NAME}.psm1"
    'ModuleVersion'         = $Env:CI_MODULE_VERSION
    'Guid'                  = '226c1ea9-1078-402a-861c-10a845a0d173'
    'Author'                = 'Troy Lindsay'
    'CompanyName'           = 'Armor'
    'Copyright'             = "(c) 2017-${year} Troy Lindsay. All rights reserved."
    'Description'           = $description
    'PowerShellVersion'     = '5.0'
    'ProcessorArchitecture' = 'None'
    'ScriptsToProcess'      = $scriptsToProcess
    'FunctionsToExport'     = $functionsToExport
    'AliasesToExport'       = $aliasesToExport
    'FileList'              = $fileList
    'Tags'                  = 'Armor', 'Defense', 'Cloud', 'Security', 'DevOps', 'Scripting', 'Automation',
        'Performance', 'Complete', 'Anywhere', 'Compliant', 'PCI-DSS', 'HIPAA', 'HITRUST', 'GDPR', 'IaaS', 'SaaS'
    'LicenseUri'            = $text.RepoUrl + '/blob/master/LICENSE.txt'
    'IconUri'               = 'https://tlindsay42.github.io/ArmorPowerShell/img/Armor_logo.png'
    'ErrorAction'           = 'Stop'
}

Update-ModuleManifest @splat

Write-Host -Object "`nAdjust a couple of PowerShell manifest auto-generated items." -ForegroundColor 'Yellow'
$manifestContent = Get-Content -Path $Env:CI_MODULE_MANIFEST_PATH
$manifestContent -replace "PSGet_${Env:CI_MODULE_NAME}|NewManifest", $Env:CI_MODULE_NAME |
    Set-Content -Path $Env:CI_MODULE_MANIFEST_PATH -ErrorAction 'Stop'

Write-Host -Object "`nTest and import the module manifest again." -ForegroundColor 'Yellow'
$manifest = Test-ModuleManifest -Path $Env:CI_MODULE_MANIFEST_PATH -ErrorAction 'Stop'

Pop-Location -ErrorAction 'Stop'
$location = Get-Location
Write-Host -Object "`nRestored the working directory to: '${location}'." -ForegroundColor 'Yellow'

Write-Host -Object "`nImport module: '${Env:CI_MODULE_NAME}'." -ForegroundColor 'Yellow'
Import-Module -Name $Env:CI_MODULE_MANIFEST_PATH -Force

# Update the docs
Write-Host -Object "`nBuilding the documentation." -ForegroundColor 'Yellow'

# Enrich keywords in the description for use in README.md (Markdown formatting)
$markDownDescription = $description -replace
    $text.ArmorComplete, $text.ArmorCompleteMd -replace
    $text.ArmorAnywhere, $text.ArmorAnywhereMd -replace
    $text.RestfulApi, $text.RestfulApiMd -replace
    $text.Windows, $text.WindowsBold -replace
    $text.AppVeyor, $text.AppVeyorMd -replace
    $text.macOS, $text.macOSBold -replace
    $text.Ubuntu, $text.UbuntuBold -replace
    $text.TravisCi, $text.TravisCiMd -replace
    $text.Pester, $text.PesterMd -replace
    $text.Coveralls, $text.CoverallsMd -replace
    $text.PSGallery, $text.PSGalleryMd

$readmePath = Join-Path -Path $Env:CI_BUILD_PATH -ChildPath 'README.md' -ErrorAction 'Stop'
# Build README.md
"# $( $text.Title )`r`n`r`n" +
    $text.PSGalleryMdShield + "`r`n" +
    $text.PSDownloadsMdShield + "`r`n`r`n" +
    $text.AppVeyorMdShield + "`r`n" +
    $text.TravisCiMdShield + "`r`n" +
    $text.CoverallsMdShield + "`r`n" +
    $text.GitterMdShield + "`r`n`r`n" +
    "${markDownDescription}`r`n`r`n" +
    "Please visit the $( $text.GitHubPagesMd ) for more details." |
    Out-File -FilePath $readmePath -Encoding 'utf8' -Force -ErrorAction 'Stop'

$indexPath = Join-Path -Path $Env:CI_DOCS_PATH -ChildPath 'index.md' -ErrorAction 'Stop'
Copy-Item -Path $readmePath -Destination $indexPath -Force -ErrorAction 'Stop'

$docsPrivatePath = Join-Path -Path $Env:CI_DOCS_PATH -ChildPath 'private' -ErrorAction 'Stop'
$docsPublicPath = Join-Path -Path $Env:CI_DOCS_PATH -ChildPath 'public' -ErrorAction 'Stop'
$modulePage = Join-Path -Path $docsPublicPath -ChildPath "${Env:CI_MODULE_NAME}.md" -ErrorAction 'Stop'
$externalHelpDirectory = Join-Path -Path $Env:CI_MODULE_PATH -ChildPath 'en-US' -ErrorAction 'Stop'

# Update the cmdlet documentation content and add metadata for building external help files
New-MarkdownHelp -Module $Env:CI_MODULE_NAME -Force -OutputFolder $docsPublicPath -ErrorAction 'Stop'

# Update the module page content
Update-MarkdownHelpModule -Path $docsPublicPath -RefreshModulePage -ErrorAction 'Stop'

# Update the external help version
( Get-Content -Path $modulePage ) -replace '^Help Version: \S+$', "Help Version: ${Env:CI_MODULE_VERSION}" |
    Set-Content -Path $modulePage -Force -ErrorAction 'Stop'

# Update the external help files
New-ExternalHelp -Path $docsPublicPath -OutputPath $externalHelpDirectory -Force -ErrorAction 'Stop'


if ( $PSVersionTable.OS -match 'Windows' ) {
    # Build the cabinet file for supporting updatable help
    # This is only supported on Windows for now
    New-ExternalHelpCab -CabFilesFolder $docsPublicPath -LandingPagePath $modulePage -OutputFolder $externalHelpDirectory -ErrorAction 'Stop'
}

# Remove the metadata from the documentation pages again
New-MarkdownHelp -Module $Env:CI_MODULE_NAME -Force -OutputFolder $docsPublicPath -NoMetadata -ErrorAction 'Stop'

# Update the private function documentation content
foreach ( $file in ( Get-ChildItem -Path $Env:CI_MODULE_PRIVATE_PATH -Filter '*.ps1' -ErrorAction 'Stop' ) ) {
    . $file.FullName
    New-MarkdownHelp -Command $file.BaseName -Force -NoMetadata -OutputFolder $docsPrivatePath -ErrorAction 'Stop'
}

# Build the documentation site
mkdocs build 2>&1

Write-Host -Object ''
