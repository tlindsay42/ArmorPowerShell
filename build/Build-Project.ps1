#region init
$tempFile = [System.IO.Path]::GetTempFileName()

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
    'Copyright'             = "2017-$( ( Get-Date ).Year ) Troy Lindsay. All rights reserved."
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
#endregion

#region module
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

$scriptsToProcess = Get-ChildItem -Path "${Env:CI_MODULE_LIB_PATH}/*.ps1" -File -ErrorAction 'Stop' |
    Resolve-Path -Relative

$splat = @{
    'Path'                  = $Env:CI_MODULE_MANIFEST_PATH
    'RootModule'            = "${Env:CI_MODULE_NAME}.psm1"
    'ModuleVersion'         = $Env:CI_MODULE_VERSION
    'Guid'                  = '226c1ea9-1078-402a-861c-10a845a0d173'
    'Author'                = 'Troy Lindsay'
    'CompanyName'           = 'Armor'
    'Copyright'             = '© ' + $text.Copyright
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
    'IconUri'               = $text.GitHubPagesProjectUrl + 'img/Armor_logo.png'
    'HelpInfoUri'           = $text.GitHubPagesProjectUrl
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
#endregion

#region documentation
if ( $Env:APPVEYOR_JOB_NUMBER -eq 1 ) {
    Write-Host -Object "`nBuilding the documentation." -ForegroundColor 'Yellow'
    $readmePath = Join-Path -Path $Env:CI_BUILD_PATH -ChildPath 'README.md' -ErrorAction 'Stop'
    $indexPath = Join-Path -Path $Env:CI_DOCS_PATH -ChildPath 'index.md'
    $docsUserPath = Join-Path -Path $Env:CI_DOCS_PATH -ChildPath 'user' -ErrorAction 'Stop'
    $docsPrivatePath = Join-Path -Path $Env:CI_DOCS_PATH -ChildPath 'private' -ErrorAction 'Stop'
    $docsPublicPath = Join-Path -Path $Env:CI_DOCS_PATH -ChildPath 'public' -ErrorAction 'Stop'
    $modulePage = Join-Path -Path $docsPublicPath -ChildPath "${Env:CI_MODULE_NAME}.md" -ErrorAction 'Stop'
    $externalHelpDirectory = Join-Path -Path $Env:CI_MODULE_PATH -ChildPath 'en-US' -ErrorAction 'Stop'

    Write-Host -Object "`nEnrich keywords in the description for use in 'README.md' (Markdown formatting)" -ForegroundColor 'Yellow'
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

    Write-Host -Object "`nBuild 'README.md'." -ForegroundColor 'Yellow'
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

    Write-Host -Object "Copy '/README.md' to '/docs/index.md'." -ForegroundColor 'Yellow'
    $splat = @{
        'Path'        = $readmePath
        'Destination' = $indexPath
        'Force'       = $true
        'ErrorAction' = 'Stop'
    }
    Copy-Item @splat

    Write-Host -Object "`nRemoving the last two lines of the home page." -ForegroundColor 'Yellow'
    Get-Content -Path $indexPath |
        Select-Object -SkipLast 2 |
        Out-String |
        Set-Content -Path $indexPath -Force -ErrorAction 'Stop'


    Write-Host -Object "Copy '/.github/CONTRIBUTING.md' to '/docs/user/Contributing.md'." -ForegroundColor 'Yellow'
    $splat.Path = Join-Path -Path $Env:CI_BUILD_PATH -ChildPath '.github' |
        Join-Path -ChildPath 'CONTRIBUTING.md'
    $splat.Destination = Join-Path -Path $docsUserPath -ChildPath 'Contributing.md'
    Copy-Item @splat

    Write-Host -Object "Copy '/.github/CODE_OF_CONDUCT.md' to '/docs/user/Code_of_Conduct.md'." -ForegroundColor 'Yellow'
    $splat.Path = Join-Path -Path $Env:CI_BUILD_PATH -ChildPath '.github' |
        Join-Path -ChildPath 'CODE_OF_CONDUCT.md'
    $splat.Destination = Join-Path -Path $docsUserPath -ChildPath 'Code_of_Conduct.md'
    Copy-Item @splat

    #region mkdocs.yml
    Write-Host -Object "Build the 'mkdocs.yml' config file." -ForegroundColor 'Yellow'
    $mkdocsConfig = "# https://www.mkdocs.org/user-guide/configuration/

# Project information
site_name: '$( $text.Title )'
site_description: 'This is a community project that provides a powerful command-line interface for managing and monitoring your Armor Complete (secure public cloud) and Armor Anywhere (security as a service) environments & accounts via a PowerShell module with cmdlets that interact with the published RESTful APIs.'
site_author: 'Troy Lindsay'
site_url: '$( $text.GitHubPagesProjectUrl )'

# Repository
repo_name: '${Env:CI_OWNER_NAME}/${Env:CI_PROJECT_NAME}'
repo_url: '$( $text.RepoUrl )'
remote_branch: 'gh-pages'
edit_uri: 'blob/master/docs/'

# Copyright
copyright: 'Copyright &copy; $( $text.Copyright )'

# Google Analytics
google_analytics: ['UA-117909744-3', '${Env:CI_PROJECT_NAME}']

# Configuration
theme:
  name: 'material'

  # 404 page
  static_templates:
    - '404.html'

  # Don't include MkDocs' JavaScript
  include_search_page: false
  search_index_only: false

  # Default values, taken from mkdocs_theme.yml
  language: 'en'
  feature:
    tabs: false
  palette:
    primary: 'grey'
    accent: 'deep orange'
  font:
    text: 'Roboto'
    code: 'Roboto Mono'
  favicon: 'img/favicon.ico'
  logo: 'img/armor_logo.svg'

# Customization
extra:
  social:
    - type: 'globe'
      link: 'https://www.troylindsay.io'
    - type: 'github-alt'
      link: 'https://github.com/tlindsay42'
    - type: 'twitter'
      link: 'https://twitter.com/troylindsay42'
    - type: 'linkedin'
      link: 'https://www.linkedin.com/in/troylindsay'

# Extensions
markdown_extensions:
  - admonition
  - markdown.extensions.codehilite:
      guess_lang: false
  - markdown.extensions.def_list
  - markdown.extensions.footnotes
  - markdown.extensions.meta
  - markdown.extensions.toc:
      permalink: true
  - pymdownx.arithmatex
  - pymdownx.betterem:
      smart_enable: all
  - pymdownx.caret
  - pymdownx.critic
  - pymdownx.details
  - pymdownx.emoji:
      emoji_generator: !!python/name:pymdownx.emoji.to_svg
  - pymdownx.inlinehilite
  - pymdownx.keys
  - pymdownx.magiclink
  - pymdownx.mark
  - pymdownx.smartsymbols
  - pymdownx.superfences
  - pymdownx.tasklist:
      custom_checkbox: true
  - pymdownx.tilde

# Page tree
pages:
  - Home: 'index.md'
  - User Documentation:
    - Requirements: 'user/Requirements.md'
    - Install Guide: 'user/Install.md'
    - Update Guide: 'user/Update.md'
    - Uninstall Guide: 'user/Uninstall.md'
    - Getting Started: 'user/Getting_Started.md'
    - Project Architecture: 'user/Project_Architecture.md'
    - Licensing: 'user/Licensing.md'
    - Contributing: 'user/Contributing.md'
    - Code of Conduct: 'user/Code_of_Conduct.md'
    - FAQs: 'user/FAQs.md'
  - Cmdlet Documentation:
    - Module Description: 'public/${Env:CI_MODULE_NAME}.md'`r`n"

    foreach ( $file in ( Get-ChildItem -Path $Env:CI_MODULE_PUBLIC_PATH -Filter '*.ps1' | Sort-Object -Property 'Name' ) ) {
        $mkdocsConfig += "    - $( $file.BaseName ): 'public/$( $file.BaseName ).md'`r`n"
    }

    $mkdocsConfig += "  - Private Functions:`r`n"

    foreach ( $file in ( Get-ChildItem -Path $Env:CI_MODULE_PRIVATE_PATH -Filter '*.ps1' | Sort-Object -Property 'Name' ) ) {
        $mkdocsConfig += "    - $( $file.BaseName ): 'private/$( $file.BaseName ).md'`r`n"
    }

    $splat = @{
        'InputObject' = $mkdocsConfig
        'FilePath'    = Join-Path -Path $Env:CI_BUILD_PATH -ChildPath 'mkdocs.yml'
        'Encoding'    = 'utf8'
        'Force'       = $true
        'ErrorAction' = 'Stop'
    }
    Out-File @splat
    #endregion

    Write-Host -Object "`nClean the cmdlet & private function documentation directories." -ForegroundColor 'Yellow'
    Remove-Item -Path "$docsPrivatePath/*.md" -Force
    Remove-Item -Path "$docsPublicPath/*.md" -Force

    Write-Host -Object "`nUpdate the cmdlet documentation content and add metadata for building external help files." -ForegroundColor 'Yellow'
    $splat = @{
        'Module'                = $Env:CI_MODULE_NAME
        'Force'                 = $true
        'AlphabeticParamsOrder' = $true
        'OutputFolder'          = $docsPublicPath
        'WithModulePage'        = $true
        'HelpVersion'           = $Env:CI_MODULE_VERSION
        'Locale'                = 'en-US'
        'FwLink'                = $text.GitHubPagesProjectUrl
        'ErrorAction'           = 'Stop'
    }
    New-MarkdownHelp @splat

    Write-Host -Object "`nUpdate the module page content." -ForegroundColor 'Yellow'
    Update-MarkdownHelpModule -Path $docsPublicPath -RefreshModulePage -ErrorAction 'Stop'

    Write-Host -Object "`nUpdate the external help module description." -ForegroundColor 'Yellow'
    ( Get-Content -Path $modulePage ) -replace '^{{Manually Enter Description Here}}$', "The Armor command-line interface" |
        Set-Content -Path $modulePage -Force -ErrorAction 'Stop'

    Write-Host -Object "`nUpdate the external help files." -ForegroundColor 'Yellow'
    New-ExternalHelp -Path $docsPublicPath -OutputPath $externalHelpDirectory -Force -ErrorAction 'Stop'

    if ( $Env:CI_WINDOWS -eq $true ) {
        Write-Host -Object "`nBuild the cabinet file for supporting updatable help." -ForegroundColor 'Yellow'
        Write-Host -Object 'This is only supported on Windows for now.'
        New-ExternalHelpCab -CabFilesFolder $docsPublicPath -LandingPagePath $modulePage -OutputFolder $Env:CI_DOCS_PATH -ErrorAction 'Stop'
    }

    Write-Host -Object "`nRemove the metadata from the public cmdlet documentation pages." -ForegroundColor 'Yellow'
    $splat = @{
        'Module'                = $Env:CI_MODULE_NAME
        'Force'                 = $true
        'AlphabeticParamsOrder' = $true
        'OutputFolder'          = $docsPublicPath
        'NoMetadata'            = $true
        'ErrorAction'           = 'Stop'
    }
    New-MarkdownHelp @splat

    Write-Host -Object "`nUpdate the private function documentation content." -ForegroundColor 'Yellow'
    foreach ( $file in ( Get-ChildItem -Path $Env:CI_MODULE_PRIVATE_PATH -Filter '*.ps1' -ErrorAction 'Stop' ) ) {
        . $file.FullName

        $splat = @{
            'Command'               = $file.BaseName
            'Force'                 = $true
            'AlphabeticParamsOrder' = $true
            'OutputFolder'          = $docsPrivatePath
            'NoMetadata'            = $true
            'ErrorAction'           = 'Stop'
        }
        New-MarkdownHelp @splat
    }

    Write-Host -Object "`nRemove the metadata from the module description documentation page." -ForegroundColor 'Yellow'
    Get-Content -Path $modulePage |
        Select-Object -Skip 8 |
        Out-String |
        Set-Content -Path $modulePage -Force -ErrorAction 'Stop'

    Write-Host -Object "`nBuild the documentation site." -ForegroundColor 'Yellow'
    mkdocs build --clean --strict 2> $tempFile
    Get-Content -Path $tempFile
}
#endregion

Write-Host -Object ''
