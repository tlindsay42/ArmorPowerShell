#requires -Version 5.0
#requires -Modules BuildHelpers, Pester, platyPS, psake, PSDeploy

#region Format task title style
$horizontalLine = '#' * 80
FormatTaskName "$horizontalLine`n{0}`n$horizontalLine`n"
Remove-Variable -Name 'horizontalLine'
#endregion

#region Includes
$privatePath = Join-Path -Path $PSScriptRoot -ChildPath 'private'
Include ( Join-Path -Path $privatePath -ChildPath 'Get-TestResponseBody.ps1' )
Include ( Join-Path -Path $privatePath -ChildPath 'Test-AdvancedFunctionName.ps1' )
Include ( Join-Path -Path $privatePath -ChildPath 'Test-AdvancedFunctionHelpMain.ps1' )
Include ( Join-Path -Path $privatePath -ChildPath 'Test-AdvancedFunctionHelpInput.ps1' )
Include ( Join-Path -Path $privatePath -ChildPath 'Test-AdvancedFunctionHelpOutput.ps1' )
Include ( Join-Path -Path $privatePath -ChildPath 'Test-AdvancedFunctionHelpParameter.ps1' )
Include ( Join-Path -Path $privatePath -ChildPath 'Test-AdvancedFunctionHelpNote.ps1' )
Include ( Join-Path -Path $privatePath -ChildPath 'Write-StatusUpdate.ps1' )
Remove-Variable -Name 'privatePath'
#endregion

#region Set default error action
$errorAction = 'Stop'
$ErrorActionPreference = $errorAction
Assert ( $ErrorActionPreference -eq 'Stop' ) "Unexpected error action preference: '${errorAction}'."
Remove-Variable -Name 'errorAction'
#endregion

#region Assert PowerShell module dependencies
$moduleDevDependencies = @(
    @{
        Name           = 'BuildHelpers'
        MinimumVersion = '1.1.4'
    },
    @{
        Name           = 'Pester'
        MinimumVersion = '4.3.1'
    },
    @{
        Name           = 'platyPS'
        MinimumVersion = '0.10.1'
    },
    @{
        Name           = 'psake'
        MinimumVersion = '4.7.0'
    },
    @{
        Name           = 'PSDeploy'
        MinimumVersion = '0.2.5'
    }
)

if ( $Env:APPVEYOR -eq $true ) {
    $moduleDevDependencies += @{
        Name           = 'Coveralls'
        MinimumVersion = '1.0.25'
    }
}

foreach ( $moduleDevDependency in $moduleDevDependencies ) {
    $message = (
        "PowerShell module development dependency: '$( $moduleDevDependency.Name )', " +
        "minimum version: '$( $moduleDevDependency.MinimumVersion )' not found."
    )
    Assert ( ( Get-Module -Name $moduleDevDependency.Name ).Version -ge $moduleDevDependency.MinimumVersion ) $message
}
#endregion

#region Assert BuildHelpers environment variable existence
$buildHelperVariableNames = (
    'BranchName',
    'BuildNumber',
    'BuildOutput',
    'BuildSystem',
    'CommitMessage',
    'ModulePath',
    'ProjectName',
    'ProjectPath',
    'PSModuleManifest'
)
foreach ( $buildHelperVariableName in $buildHelperVariableNames ) {
    Assert ( Test-Path -Path "Env:BH${buildHelperVariableName}" ) "Missing BuildHelpers environment variable: 'Env:BH${buildHelperVariableName}'."
}
Remove-Variable -Name 'buildHelperVariableName', 'buildHelperVariableNames'
#endregion

#region Assert BuildHelpers environment variable values
Assert ( $Env:BHBuildSystem -in 'AppVeyor', 'Travis' ) "Unsupported continuous integration build system: '${Env:BHBuildSystem}'."
Assert ( $Env:BHBranchName.Length -gt 0 ) "Invalid branch name: '${Env:BHBranchName}'."
Assert ( Test-Path -Path $Env:BHModulePath ) "PowerShell module path not found: '${Env:BHModulePath}'."
Assert ( Test-Path -Path $Env:BHPSModuleManifest ) "PowerShell module manifest path not found: '${Env:BHPSModuleManifest}'."
Assert ( $Env:BHCommitMessage.Length -gt 0 ) "Invalid commit message: '${Env:BHCommitMessage}'."
Assert ( $Env:BHBuildNumber.Length -gt 0 ) "Invalid build number: '${Env:BHBuildNumber}'."
Assert ( Test-Path -Path $Env:BHProjectPath ) "Project path not found: '${Env:BHProjectPath}'."
Assert ( Test-Path -Path $Env:BHBuildOutput ) "Build output path not found: '${Env:BHBuildOutput}'."
Assert ( $Env:BHProjectName -eq 'Armor' ) "Unexpected project name: '${Env:BHProjectName}'."
#endregion

Assert ( Get-Command -Name 'mdspell' ) "Cannot find the Markdown spell-check tool dependency: 'mdspell'"
Assert ( Get-Command -Name 'mkdocs' ) "Cannot find the Markdown static site generation and deployment tool dependency: 'mkdocs'"

Properties {
    #region init build parameters
    if ( -not $DeploymentMode ) {
        $DeploymentMode = $false
    }

    if ( -not $TestMode ) {
        $TestMode = $false
    }

    if ( -not $Local ) {
        $Local = $false
    }

    if ( -not $TestTag ) {
        $TestTag = @()
    }

    if ( -not $ExcludeTestTag ) {
        $ExcludeTestTag = @()
    }

    if ( -not $Coverage ) {
        $Coverage = $false
    }
    #endregion

    Set-StrictMode -Version 'Latest'

    Push-Location -Path $Env:BHProjectPath

    #region CI abstraction variables
    $CI_PROJECT_PATH = $Env:BHProjectPath
    $CI_BUILD_PATH = Join-Path -Path $CI_PROJECT_PATH -ChildPath 'build'
    $CI_BUILD_SCRIPTS_PATH = Join-Path -Path $CI_BUILD_PATH -ChildPath 'scripts'
    $CI_BUILD_OUTPUT_PATH = Join-Path -Path $CI_PROJECT_PATH -ChildPath 'BuildOutput'
    $CI_OWNER_NAME = $null
    $CI_PROJECT_NAME = $null
    $CI_COMMIT_MESSAGE = $Env:BHCommitMessage
    #endregion

    #region Coveralls variables
    $CI_NAME = $Env:BHBuildSystem
    $CI_BUILD_NUMBER = $null
    $CI_BUILD_URL = $null
    $CI_BRANCH = $Env:BHBranchName
    $CI_PULL_REQUEST = $null
    #endregion

    #region PowerShell Module variables
    $Global:CI_MODULE_NAME = $Env:BHProjectName
    $CI_MODULE_PATH = $Env:BHModulePath
    $Script:CI_MODULE_VERSION = $null
    $CI_MODULE_GUID = '226c1ea9-1078-402a-861c-10a845a0d173'
    $CI_MODULE_MANIFEST_PATH = $Env:BHPSModuleManifest
    $CI_MODULE_MANIFEST_RELATIVE_PATH = Resolve-Path -Path $CI_MODULE_MANIFEST_PATH -Relative
    $CI_MODULE_ETC_PATH = Join-Path -Path $CI_MODULE_PATH -ChildPath 'Etc'
    $CI_MODULE_LIB_PATH = Join-Path -Path $CI_MODULE_PATH -ChildPath 'Lib'
    $CI_MODULE_PRIVATE_PATH = Join-Path -Path $CI_MODULE_PATH -ChildPath 'Private'
    $CI_MODULE_PUBLIC_PATH = Join-Path -Path $CI_MODULE_PATH -ChildPath 'Public'
    #endregion

    #region Testing variables
    $CI_TESTS_PATH = Join-Path -Path $CI_PROJECT_PATH -ChildPath 'tests'
    $CI_TEST_RESULTS = $null
    $CI_TEST_RESULTS_PATH = Join-Path -Path $CI_BUILD_OUTPUT_PATH -ChildPath 'TestResults.xml'
    $CI_COVERAGE_RESULTS_PATH = Join-Path -Path $CI_BUILD_OUTPUT_PATH -ChildPath 'CodeCoverageResults.xml'
    $Global:FORM_CLASS = 'Class/{0}'
    $Global:FORM_ENUM = 'Enum/{0}'
    $Global:CONSTRUCTORS = 'Constructors'
    $Global:FORM_DEFAULT_CONTRUCTORS = 'should not fail when creating an object with the default constructor'
    $Global:FORM_PROPERTY = 'Property/{0}'
    $Global:FORM_PROPERTY_FAIL = "should fail when set to: <Value>"
    $Global:FORM_PROPERTY_PASS = "should not fail when set to: <Value>"
    $Global:FORM_PROPERTY_TYPE = 'should be the expected data type'
    $Global:FORM_METHOD = 'Method/{0}'
    $Global:FORM_METHOD_FAIL = '{0} (fail)' -f $Global:FORM_METHOD
    $Global:FORM_METHOD_PASS = '{0} (pass)' -f $Global:FORM_METHOD
    $Global:EXECUTION = 'Execution'
    $Global:RETURN_TYPE_CONTEXT = 'Return Type'
    $Global:FORM_RETURN_TYPE = 'should return the expected data type: <ExpectedReturnType>'
    $Global:FORM_FUNCTION_PRIVATE = 'Function/Private/{0}'
    $Global:FORM_FUNCTION_PUBLIC = 'Function/Public/{0}'
    $Global:FORM_FUNCTION_HELP = 'Comment-Based Help/{0}'
    $Global:FORM_FUNCTION_HELP_NOTES = "- Troy Lindsay`n- Twitter: @troylindsay42`n- GitHub: tlindsay42"

    $Global:JSON_RESPONSE_BODY = @{
        Accounts4            = Get-TestResponseBody -FileName 'Accounts_4.json'
        Address1             = Get-TestResponseBody -FileName 'Address_1.json'
        Authorize1           = Get-TestResponseBody -FileName 'Authorize_1.json'
        Datacenters5         = Get-TestResponseBody -FileName 'Datacenters_5.json'
        Identity1            = Get-TestResponseBody -FileName 'Identity_1.json'
        Session1             = Get-TestResponseBody -FileName 'Session_1.json'
        Tiers1VMs1           = Get-TestResponseBody -FileName 'Tiers_1-VMs_1.json'
        Token1               = Get-TestResponseBody -FileName 'Token_1.json'
        Users1               = Get-TestResponseBody -FileName 'Users_1.json'
        VmOrders1            = Get-TestResponseBody -FileName 'VmOrders_1.json'
        VMs1                 = Get-TestResponseBody -FileName 'VMs_1.json'
        VMs2                 = Get-TestResponseBody -FileName 'VMs_2.json'
        Workloads1Tiers1VMs1 = Get-TestResponseBody -FileName 'Workloads_1-Tiers_1-VMs_1.json'
        Workloads1Tiers1VMs2 = Get-TestResponseBody -FileName 'Workloads_1-Tiers_1-VMs_2.json'
    }
    #endregion

    #region Deployment variables
    $CI_DEPLOY_SCRIPTS_PATH = Join-Path -Path $CI_PROJECT_PATH -ChildPath 'deploy'
    $CI_SKIP_PUBLISH_KEYWORD = '\b\[skip publish\]\b'
    $CI_PUBLISH_MESSAGE_FORM = "Publishing {0}: '{1}' version: '{2}' to {3}."
    $CI_DEPLOY_COMMIT_MESSAGE = $null
    #endregion

    #region Documentation variables
    $CI_DOCS_PATH = Join-Path -Path $CI_PROJECT_PATH -ChildPath 'docs'
    $CI_DOCS_PRIVATE_PATH = Join-Path -Path $CI_DOCS_PATH -ChildPath 'private'
    $CI_DOCS_PUBLIC_PATH = Join-Path -Path $CI_DOCS_PATH -ChildPath 'public'
    $CI_DOCS_USER_PATH = Join-Path -Path $CI_DOCS_PATH -ChildPath 'user'

    $CI_DOCS_SITE_PATH = Join-Path -Path $CI_PROJECT_PATH -ChildPath 'site'

    $GLOB_MD = '*.md'
    $GLOB_PS1 = '*.ps1'
    #endregion

    #region Script path variables
    $CI_START_TESTS_SCRIPT_PATH = Join-Path -Path $CI_TESTS_PATH -ChildPath 'Start-Tests.ps1'
    $CI_PUBLISH_PROJECT_SCRIPT_PATH = Join-Path -Path $CI_DEPLOY_SCRIPTS_PATH -ChildPath 'Publish-Project.ps1'
    #endregion

    # Update build system-specific variables
    switch ( $CI_NAME ) {
        'AppVeyor' {
            #region CI abstraction variables
            $CI_OWNER_NAME = $Env:APPVEYOR_ACCOUNT_NAME
            $CI_PROJECT_NAME = $Env:APPVEYOR_PROJECT_NAME
            #endregion

            #region Coveralls variables
            $CI_BUILD_NUMBER = $Env:APPVEYOR_BUILD_NUMBER
            $CI_BUILD_URL = "https://ci.appveyor.com/project/${CI_OWNER_NAME}/${CI_PROJECT_NAME}/build/job/${Env:APPVEYOR_JOB_ID}"
            $CI_PULL_REQUEST = $Env:APPVEYOR_PULL_REQUEST_NUMBER
            #endregion

            #region PowerShell Module variables
            $Script:CI_MODULE_VERSION = ( $Env:APPVEYOR_BUILD_VERSION ).Split( '-' )[0]
            #endregion
        }

        'Travis' {
            #region CI abstraction variables
            $CI_OWNER_NAME = $Env:TRAVIS_REPO_SLUG.Split( '/' )[0]
            $CI_PROJECT_NAME = $Env:TRAVIS_REPO_SLUG.Split( '/' )[-1]
            #endregion

            #region Coveralls variables
            $CI_BUILD_NUMBER = $Env:TRAVIS_BUILD_NUMBER
            $CI_BUILD_URL = "https://travis-ci.org/${CI_OWNER_NAME}/${CI_PROJECT_NAME}/jobs/${Env:TRAVIS_JOB_ID}"
            $CI_PULL_REQUEST = $Env:TRAVIS_PULL_REQUEST
            #endregion

            #region PowerShell Module variables
            $Script:CI_MODULE_VERSION = Get-NextNugetPackageVersion -Name $Global:CI_MODULE_NAME
            #endregion
        }

        default {
            throw "Unsupported continuous integration build system: '${CI_NAME}'."
        }
    }

    #region Text
    $TEXT = @{
        AppVeyor              = 'AppVeyor'
        AppVeyorImageUrl      = 'https://ci.appveyor.com/api/projects/status/x4ik2enxvdc5h0x6/branch/master?svg=true'
        AppVeyorProjectUrl    = "https://ci.appveyor.com/project/${CI_OWNER_NAME}/${CI_PROJECT_NAME}/branch/master"
        ArmorAnywhere         = 'Armor Anywhere'
        ArmorAnywhereUrl      = 'https://www.armor.com/armor-anywhere-security/'
        ArmorApiGuideUrl      = 'https://docs.armor.com/display/KBSS/Armor+API+Guide'
        ArmorComplete         = 'Armor Complete'
        ArmorCompleteUrl      = 'https://www.armor.com/armor-complete-secure-hosting/'
        AvailableOnGitHub     = 'available on GitHub'
        BoldForm              = '**{0}**'
        BuildStatus           = 'Build Status'
        Copyright             = "2017-$( ( Get-Date ).Year ) Troy Lindsay. All rights reserved."
        CoverageStatus        = 'Coverage Status'
        Coveralls             = 'Coveralls'
        CoverallsImageUrl     = "https://coveralls.io/repos/github/${CI_OWNER_NAME}/${CI_PROJECT_NAME}/badge.svg?branch=master"
        CoverallsProjectUrl   = "https://coveralls.io/github/${CI_OWNER_NAME}/${CI_PROJECT_NAME}?branch=master"
        CurrentVersion        = 'Current Version'
        DocumentationStatus   = 'Documentation Status'
        GitHubPages           = 'GitHubPages'
        GitHubPagesProjectUrl = "https://${CI_OWNER_NAME}.github.io/${CI_PROJECT_NAME}/"
        Gitter                = 'Gitter'
        GitterImageAlt        = "Join the chat at https://gitter.im/${CI_PROJECT_NAME}/Lobby"
        GitterImageUrl        = "https://badges.gitter.im/${CI_PROJECT_NAME}/Lobby.svg"
        GitterProjectUrl      = "https://gitter.im/${CI_PROJECT_NAME}/Lobby?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge"
        LatestBuild           = "${CI_PROJECT_NAME}: Latest Build"
        macOS                 = 'macOS'
        MdBoldLinkForm        = "**[{0}]({1} '{2}')**"
        MdImageForm           = '[![{0}]({1})]({2})'
        MdLinkForm            = "[{0}]({1} '{2}')"
        Pester                = 'Pester'
        PesterUrl             = 'https://github.com/pester/Pester'
        ProductPage           = 'Product Page'
        PSDownloadsImageUrl   = "https://img.shields.io/powershellgallery/dt/${Global:CI_MODULE_NAME}.svg"
        PSGallery             = 'PowerShell Gallery'
        PSGalleryImageUrl     = "https://img.shields.io/powershellgallery/v/${Global:CI_MODULE_NAME}.svg"
        PSGalleryProjectUrl   = "https://www.powershellgallery.com/packages/${Global:CI_MODULE_NAME}"
        RepoUrl               = "https://github.com/${CI_OWNER_NAME}/${CI_PROJECT_NAME}"
        RestfulApi            = 'RESTful APIs'
        SkipMessage           = "Skipping since this is not a deployment build."
        Title                 = 'The Armor Community PowerShell Module'
        TotalDownloads        = 'Total Downloads'
        TravisCi              = 'Travis CI'
        TravisCiImageUrl      = "https://travis-ci.org/${CI_OWNER_NAME}/${CI_PROJECT_NAME}.svg?branch=master"
        TravisCiProjectUrl    = "https://travis-ci.org/${CI_OWNER_NAME}/${CI_PROJECT_NAME}"
        Ubuntu                = 'Ubuntu Linux'
        Windows               = 'Windows'
    }

    # Add formatted versions of entries above
    $TEXT += @{
        LatestBuildConsole = "$( $TEXT.LatestBuild ) Console"
    }

    # Add more formatted versions of entries above
    $TEXT += @{
        AppVeyorMdLinkTitle      = "$( $TEXT.AppVeyor ): $( $TEXT.LatestBuildConsole )"
        ArmorAnywhereMdLinkTitle = "$( $TEXT.ArmorAnywhere ) $( $TEXT.ProductPage )"
        ArmorCompleteMdLinkTitle = "$( $TEXT.ArmorComplete ) $( $TEXT.ProductPage )"
        CoverallsMdLinkTitle     = "$( $TEXT.Coveralls ): ${CI_PROJECT_NAME}: Latest Report"
        GitHubPagesMdLinkTitle   = "$( $TEXT.GitHubPages ): $( $TEXT.LatestBuild )"
        PesterMdLinkTitle        = "$( $TEXT.Pester ) GitHub repo"
        PSGalleryMdLinkTitle     = $TEXT.PSGallery
        RestfulApiMdLinkTitle    = 'Armor API Guide'
        TravisCiMdLinkTitle      = "$( $TEXT.TravisCi ): $( $TEXT.LatestBuildConsole )"
    }

    # Add more formatted versions of entries above
    $TEXT += @{
        AppVeyorMd          = $TEXT.MdLinkForm -f $TEXT.AppVeyor, $TEXT.AppVeyorProjectUrl, $TEXT.AppVeyorMdLinkTitle
        AppVeyorMdShield    = $TEXT.MdImageForm -f $TEXT.BuildStatus, $TEXT.AppVeyorImageUrl, $TEXT.AppVeyorProjectUrl
        ArmorAnywhereMd     = $TEXT.MdBoldLinkForm -f $TEXT.ArmorAnywhere, $TEXT.ArmorAnywhereUrl, $TEXT.ArmorAnywhereMdLinkTitle
        ArmorCompleteMd     = $TEXT.MdBoldLinkForm -f $TEXT.ArmorComplete, $TEXT.ArmorCompleteUrl, $TEXT.ArmorCompleteMdLinkTitle
        CoverallsMd         = $TEXT.MdLinkForm -f $TEXT.Coveralls, $TEXT.CoverallsProjectUrl, $TEXT.CoverallsMdLinkTitle
        CoverallsMdShield   = $TEXT.MdImageForm -f $TEXT.CoverageStatus, $TEXT.CoverallsImageUrl, $TEXT.CoverallsProjectUrl
        GitHubPagesMd       = $TEXT.MdBoldLinkForm -f 'full documentation', $TEXT.GitHubPagesProjectUrl, $TEXT.GitHubPagesMdLinkTitle
        GitterMdShield      = "$( $TEXT.MdImageForm )`r`n" -f $TEXT.GitterImageAlt, $TEXT.GitterImageUrl, $TEXT.GitterProjectUrl
        macOSBold           = $TEXT.BoldForm -f $TEXT.macOS
        PesterMd            = $TEXT.MdLinkForm -f $TEXT.Pester, $TEXT.PesterUrl, $TEXT.PesterMdLinkTitle
        PSDownloadsMdShield = "$( $TEXT.MdImageForm )`r`n" -f $TEXT.TotalDownloads, $TEXT.PSDownloadsImageUrl, $TEXT.PSGalleryProjectUrl
        PSGalleryMd         = $TEXT.MdLinkForm -f $TEXT.PSGallery, $TEXT.PSGalleryProjectUrl, $TEXT.PSGalleryMdLinkTitle
        PSGalleryMdShield   = $TEXT.MdImageForm -f $TEXT.CurrentVersion, $TEXT.PSGalleryImageUrl, $TEXT.PSGalleryProjectUrl
        RestfulApiMd        = $TEXT.MdLinkForm -f $TEXT.RestfulApi, $TEXT.ArmorApiGuideUrl, $TEXT.RestfulApiMdLinkTitle
        TravisCiMd          = $TEXT.MdLinkForm -f $TEXT.TravisCi, $TEXT.TravisCiProjectUrl, $TEXT.TravisCiMdLinkTitle
        TravisCiMdShield    = $TEXT.MdImageForm -f $TEXT.BuildStatus, $TEXT.TravisCiImageUrl, $TEXT.TravisCiProjectUrl
        UbuntuBold          = $TEXT.BoldForm -f $TEXT.Ubuntu
        WindowsBold         = $TEXT.BoldForm -f $TEXT.Windows
    }

    $TEXT += @{
        Description = "This is a community project that provides a powerful command-line interface for managing and monitoring your $( $TEXT.ArmorComplete ) (secure public cloud) and $( $TEXT.ArmorAnywhere ) (security as a service) environments & accounts via a PowerShell module with cmdlets that interact with the published $( $TEXT.RestfulApi ).",
        "Every code push is built on $( $TEXT.Windows ) via $( $TEXT.AppVeyor ), as well as on $( $TEXT.macOS ) and $( $TEXT.Ubuntu ) via $( $TEXT.TravisCi ), and tested using the $( $TEXT.Pester ) test & mock framework.",
        "Code coverage scores and reports showing how much of the project is covered by automated tests are tracked by $( $TEXT.Coveralls ).",
        "Every successful build is published on the $( $TEXT.PSGallery )." -join "`r`n`r`n"
    }



















    # $BuildDate = Get-Date -UFormat '%Y%m%d'
    # $ReleaseNotes = "$ProjectRoot\RELEASE.md"
    # $ChangeLog = "$ProjectRoot\docs\ChangeLog.md"


















    Pop-Location
}

# Run the following before every Task
TaskSetup {
}

# Run the following after every Task
TaskTearDown {
    Write-Host
}

$task = @{
    Name   = 'List Variables'
    Action = {
        Write-StatusUpdate -Message "List all key continuous integration environment & script-level variables."
        $buildVariables = ( Get-ChildItem -Path 'Env:' ).Where( { $_.Name -match "^(?:BH|CI(?:_|$)|${CI_NAME})" } )
        $buildVariables += ( Get-Variable -Name 'CI_*' -Scope 'Script' )
        $details = $buildVariables |
            Where-Object -FilterScript { $_.Name -notmatch 'EMAIL' } |
            Sort-Object -Property 'Name' |
            Format-Table -AutoSize -Property 'Name', 'Value' |
            Out-String
        Write-StatusUpdate -Message "CI variables:" -Details $details
    }
}
Task @task


$stepModuleTask = @{
    Name              = 'Step module build version'
    Depends           = $task.Name
    RequiredVariables = (
        'CI_COMMIT_MESSAGE',
        'CI_MODULE_VERSION'
    )
    PreCondition      = {
        $Script:CI_MODULE_VERSION -match '^\d+\.\d+\.\d+$' -and
        $CI_COMMIT_MESSAGE -match '!(?:Major|Minor)'
    }
    Action            = {
        #region init
        $increment = ''
        #endregion

        <#
        If the commit message contains a flag indicating a major or minor version
        increase, update the module version variable accordingly.
        #>
        switch -Regex ( $CI_COMMIT_MESSAGE ) {
            '!Major' {
                $increment = 'Major'
                break
            }

            '!Minor' {
                $increment = 'Minor'
                break
            }
        }

        Write-StatusUpdate -Message "Step module version by $( $increment.ToLower() ) increment per commit flag."
        $Script:CI_MODULE_VERSION = $Script:CI_MODULE_VERSION |
            Step-Version -By $increment
        Write-StatusUpdate -Message "Module version stepped to: '${Script:CI_MODULE_VERSION}'"
    }
}
Task @stepModuleTask


$stepAppVeyorBuildTask = @{
    Name              = 'Step AppVeyor build version'
    Depends           = $stepModuleTask.Name
    RequiredVariables = (
        'CI_MODULE_VERSION',
        'CI_PROJECT_PATH'
    )
    PreCondition      = {
        $CI_NAME -eq 'AppVeyor' -and
        $Script:CI_MODULE_VERSION -match '^\d+\.\d+\.\d+$' -and
        $CI_COMMIT_MESSAGE -match '!(?:Major|Minor)'
    }
    Action            = {
        #region init
        $version = $Script:CI_MODULE_VERSION.Split( '.' )
        $appveyorConfigPath = Join-Path -Path $CI_PROJECT_PATH -ChildPath 'appveyor.yml'
        #endregion

        Write-StatusUpdate -Message "Update AppVeyor build version config: '${appveyorConfigPath}'."
        ( Get-Content -Path $appveyorConfigPath ) -replace '^version: \d+\.\d+\.\{build\}$', "version: $( $version[0] ).$( $version[1] ).{build}" |
            Set-Content -Path $appveyorConfigPath -Force

        if ( $Local -eq $false ) {
            Write-StatusUpdate -Message "Update AppVeyor build version."
            Update-AppVeyorBuild -Version $Script:CI_MODULE_VERSION
        }    
    }
}
Task @stepAppVeyorBuildTask


$task = @{
    Name              = 'Update the module manifest'
    Depends           = $task.Name, $stepModuleTask.Name, $stepAppVeyorBuildTask.Name
    RequiredVariables = (
        'CI_MODULE_GUID',
        'CI_MODULE_LIB_PATH',
        'CI_MODULE_MANIFEST_PATH',
        'CI_MODULE_MANIFEST_RELATIVE_PATH',
        'CI_MODULE_NAME',
        'CI_MODULE_PATH',
        'CI_MODULE_VERSION',
        'CI_PROJECT_PATH',
        'TEXT'
    )
    PreAction         = {
        Set-Location -Path $CI_PROJECT_PATH

        $CI_DEPLOY_COMMIT_MESSAGE = "${CI_NAME}: Update version to ${Script:CI_MODULE_VERSION} [ci skip]"

        Write-StatusUpdate -Message "Set the working directory to: '${CI_MODULE_PATH}'."
        Push-Location -Path $CI_MODULE_PATH

        Write-StatusUpdate -Message "Test the module manifest: '${CI_MODULE_MANIFEST_RELATIVE_PATH}'."
        $manifest = Test-ModuleManifest -Path $CI_MODULE_MANIFEST_PATH
        $details = [PSCustomObject] @{
            'Current Version' = $manifest.Version
            'New Version'     = $Script:CI_MODULE_VERSION
        } |
            Format-Table |
            Out-String
        Write-StatusUpdate -Message 'Module manifest:' -Details $details
    }
    Action            = {
        Write-StatusUpdate -Message "Update the module manifest: '${CI_MODULE_MANIFEST_RELATIVE_PATH}'."

        $splat = @{
            Path                  = $CI_MODULE_MANIFEST_PATH
            RootModule            = "${Global:CI_MODULE_NAME}.psm1"
            ModuleVersion         = $Script:CI_MODULE_VERSION
            Guid                  = $CI_MODULE_GUID
            Author                = 'Troy Lindsay'
            CompanyName           = 'Armor'
            Copyright             = '©' + $TEXT.Copyright
            Description           = $TEXT.Description
            PowerShellVersion     = '5.0'
            ProcessorArchitecture = 'None'
            ScriptsToProcess      = Get-ChildItem -Path $CI_MODULE_LIB_PATH -Filter $GLOB_PS1 -File |
                Resolve-Path -Relative
            FunctionsToExport     = ( Get-ChildItem -Path $CI_MODULE_PUBLIC_PATH ).BaseName
            AliasesToExport       = (
                Get-Content -Path ( Join-Path -Path $CI_MODULE_ETC_PATH -ChildPath 'Aliases.json' ) |
                    ConvertFrom-Json
            ).Name
            FileList              = Get-ChildItem -Path $CI_MODULE_PATH -File -Recurse |
                Resolve-Path -Relative
            Tags                  = 'Armor', 'Defense', 'Cloud', 'Security', 'DevOps', 'Scripting', 'Automation',
            'Performance', 'Complete', 'Anywhere', 'Compliant', 'PCI-DSS', 'HIPAA', 'HITRUST', 'GDPR', 'IaaS', 'SaaS'
            LicenseUri            = $TEXT.RepoUrl + '/blob/master/LICENSE.txt'
            IconUri               = $TEXT.GitHubPagesProjectUrl + 'img/Armor_logo.png'
            HelpInfoUri           = $TEXT.GitHubPagesProjectUrl
        }
        Update-ModuleManifest @splat

        Write-StatusUpdate -Message "Rename auto-generated PowerShell module manifest title to: '${Global:CI_MODULE_NAME}'."
        ( Get-Content -Path $CI_MODULE_MANIFEST_PATH ) -replace "PSGet_${Global:CI_MODULE_NAME}|NewManifest", $Global:CI_MODULE_NAME |
            Set-Content -Path $CI_MODULE_MANIFEST_PATH
    }
    PostAction        = {
        Pop-Location
        $location = Get-Location
        Write-StatusUpdate -Message "Restored the working directory to: '${location}'."
    }
    PostCondition     = {
        Test-ModuleManifest -Path $CI_MODULE_MANIFEST_PATH
    }
}
Task @task


$task = @{
    Name              = 'Import the updated module'
    Depends           = $task.Name
    RequiredVariables = (
        'CI_MODULE_MANIFEST_PATH',
        'CI_MODULE_MANIFEST_RELATIVE_PATH',
        'CI_MODULE_NAME',
        'CI_MODULE_VERSION'
    )
    Action            = {
        Write-StatusUpdate -Message "Import module: '${CI_MODULE_MANIFEST_RELATIVE_PATH}'."
        Remove-Module -Name "${Global:CI_MODULE_NAME}*" -Force
        Import-Module -Name $CI_MODULE_MANIFEST_PATH -Global -Force
    }
    PostCondition     = {
        ( Get-Module -Name $Global:CI_MODULE_NAME ).Version -eq $Script:CI_MODULE_VERSION
    }
}
Task @task


$task = @{
    Name              = 'Build the README & index pages'
    Depends           = $task.Name
    RequiredVariables = (
        'CI_DOCS_PATH',
        'CI_PROJECT_PATH',
        'TEXT'
    )
    Action            = {
        #region init
        $readmePath = Join-Path -Path $CI_PROJECT_PATH -ChildPath 'README.md'
        $readmeRelativePath = Resolve-Path -Path $readmePath -Relative
        $indexPath = Join-Path -Path $CI_DOCS_PATH -ChildPath 'index.md'
        $indexRelativePath = Resolve-Path -Path $indexPath -Relative
        #endregion

        Write-StatusUpdate -Message "Enrich keywords in: '${readmeRelativePath}' with Markdown formatting."
        $markDownDescription = $TEXT.Description -replace
        $TEXT.ArmorComplete, $TEXT.ArmorCompleteMd -replace
        $TEXT.ArmorAnywhere, $TEXT.ArmorAnywhereMd -replace
        $TEXT.RestfulApi, $TEXT.RestfulApiMd -replace
        $TEXT.Windows, $TEXT.WindowsBold -replace
        $TEXT.AppVeyor, $TEXT.AppVeyorMd -replace
        $TEXT.macOS, $TEXT.macOSBold -replace
        $TEXT.Ubuntu, $TEXT.UbuntuBold -replace
        $TEXT.TravisCi, $TEXT.TravisCiMd -replace
        $TEXT.Pester, $TEXT.PesterMd -replace
        $TEXT.Coveralls, $TEXT.CoverallsMd -replace
        $TEXT.PSGallery, $TEXT.PSGalleryMd

        Write-StatusUpdate -Message "Build '${readmeRelativePath}'."
        (
            "# $( $TEXT.Title )`r`n",
            $TEXT.PSGalleryMdShield, $TEXT.PSDownloadsMdShield,
            $TEXT.AppVeyorMdShield, $TEXT.TravisCiMdShield, $TEXT.CoverallsMdShield, $TEXT.GitterMdShield,
            $markDownDescription -join "`r`n"
        ) |
            Set-Content -Path $readmePath -Force

        Write-StatusUpdate -Message "Copy '${readmeRelativePath}' to '${indexRelativePath}'."
        $splat = @{
            Path        = $readmePath
            Destination = $indexPath
            Force       = $true
        }
        Copy-Item @splat

        Write-StatusUpdate -Message "Append documentation reference link to: '${readmeRelativePath}'."
        $splat = @{
            Path  = $readmePath
            Value = "`r`nPlease visit the $( $TEXT.GitHubPagesMd ) for more details."
            Force = $true
        }
        Add-Content @splat
    }
    PostCondition     = {
        ( Join-Path -Path $CI_PROJECT_PATH -ChildPath 'README.md' | Test-Path -PathType 'Leaf' ) -eq $true -and
        ( Join-Path -Path $CI_DOCS_PATH -ChildPath 'index.md' | Test-Path -PathType 'Leaf' ) -eq $true
    }
}
Task @task


$task = @{
    Name              = 'Copy the Contributing page'
    Description       = "Copies the project's Contributing page to the documentation site source."
    Depends           = $task.Name
    RequiredVariables = 'CI_PROJECT_PATH', 'CI_DOCS_USER_PATH'
    Action            = {
        #region init
        $sourcePath = Join-Path -Path $CI_PROJECT_PATH -ChildPath '.github' |
            Join-Path -ChildPath 'CONTRIBUTING.md'
        $sourceRelativePath = Resolve-Path -Path $sourcePath -Relative
        $destinationPath = Join-Path -Path $CI_DOCS_USER_PATH -ChildPath 'Contributing.md'
        $destinationRelativePath = Resolve-Path -Path $destinationPath -Relative
        #endregion

        Write-StatusUpdate -Message "Copy '${sourceRelativePath}' to '${destinationRelativePath}'."
        Copy-Item -Path $sourcePath -Destination $destinationPath -Force
    }
    PostCondition     = {
        ( Join-Path -Path $CI_DOCS_USER_PATH -ChildPath 'Contributing.md' | Test-Path -PathType 'Leaf' ) -eq $true
    }
}
Task @task


$task = @{
    Name              = 'Copy the Code of Conduct page'
    Description       = "Copies the project's Code of Conduct page to the documentation site source."
    Depends           = $task.Name
    RequiredVariables = 'CI_PROJECT_PATH', 'CI_DOCS_USER_PATH'
    Action            = {
        #region init
        $sourcePath = Join-Path -Path $CI_PROJECT_PATH -ChildPath '.github' |
            Join-Path -ChildPath 'CODE_OF_CONDUCT.md'
        $sourceRelativePath = Resolve-Path -Path $sourcePath -Relative
        $destinationPath = Join-Path -Path $CI_DOCS_USER_PATH -ChildPath 'Code_of_Conduct.md'
        $destinationRelativePath = Resolve-Path -Path $destinationPath -Relative
        #endregion

        Write-StatusUpdate -Message "Copy '${sourceRelativePath}' to '${destinationRelativePath}'."
        Copy-Item -Path $sourcePath -Destination $destinationPath -Force
    }
    PostCondition     = {
        ( Join-Path -Path $CI_DOCS_USER_PATH -ChildPath 'Code_of_Conduct.md' | Test-Path -PathType 'Leaf' ) -eq $true
    }
}
Task @task


$task = @{
    Name              = 'Build the documentation site config file'
    Depends           = $task.Name
    RequiredVariables = (
        'CI_BUILD_PATH',
        'CI_MODULE_NAME',
        'CI_MODULE_PRIVATE_PATH',
        'CI_MODULE_PUBLIC_PATH',
        'CI_OWNER_NAME',
        'CI_PROJECT_NAME',
        'CI_PROJECT_PATH',
        'TEXT'
    )
    Action            = {
        #region init
        $mkdocsConfigTemplatePath = Join-Path -Path $CI_BUILD_PATH -ChildPath 'templates' |
            Join-Path -ChildPath 'mkdocs.yml.template'
        $mkdocsConfigTemplateRelativePath = Resolve-Path -Path $mkdocsConfigTemplatePath -Relative
        $mkdocsConfigPath = Join-Path -Path $CI_PROJECT_PATH -ChildPath 'mkdocs.yml'
        $mkdocsConfigRelativePath = Resolve-Path -Path $mkdocsConfigPath -Relative
        $functionEntry = "    - {0}: '{1}/{0}.md'"
        #endregion

        Write-StatusUpdate -Message "Load: '${mkdocsConfigTemplateRelativePath}'."
        $mkdocsConfig = Get-Content -Path $mkdocsConfigTemplatePath

        Write-StatusUpdate -Message "Interpolate template variables."
        $mkdocsConfig = $mkdocsConfig -replace
        '{{ ?title ?}}', $TEXT.Title -replace
        '{{ ?site_url ?}}', $TEXT.GitHubPagesProjectUrl -replace
        '{{ ?owner_name ?}}', $CI_OWNER_NAME -replace
        '{{ ?project_name ?}}', $CI_PROJECT_NAME -replace
        '{{ ?repo_url ?}}', $TEXT.RepoUrl -replace
        '{{ ?copyright ?}}', $TEXT.Copyright -replace
        '{{ ?module_name ?}}', $Global:CI_MODULE_NAME

        Write-StatusUpdate -Message "Build the public cmdlet page navigation config."
        foreach ( $file in ( Get-ChildItem -Path $CI_MODULE_PUBLIC_PATH -Filter $GLOB_PS1 | Sort-Object -Property 'Name' ) ) {
            $mkdocsConfig += $functionEntry -f $file.BaseName, 'public'
        }

        Write-StatusUpdate -Message "Build the private function page navigation config."
        $mkdocsConfig += "  - Private Functions:"
        foreach ( $file in ( Get-ChildItem -Path $CI_MODULE_PRIVATE_PATH -Filter $GLOB_PS1 | Sort-Object -Property 'Name' ) ) {
            $mkdocsConfig += $functionEntry -f $file.BaseName, 'private'
        }

        Write-StatusUpdate -Message "Write the mkdocs config file: '${mkdocsConfigRelativePath}'."
        Set-Content -Path $mkdocsConfigPath -Value $mkdocsConfig -Force
    }
    PostCondition     = {
        ( Join-Path -Path $CI_PROJECT_PATH -ChildPath 'mkdocs.yml' | Test-Path -PathType 'Leaf' ) -eq $true
    }
}
Task @task


$task = @{
    Name              = 'Clean project'
    Description       = 'Clean the build output, documentation function source, and documentation site directories'
    Depends           = $task.Name
    RequiredVariables = (
        'CI_BUILD_OUTPUT_PATH',
        'CI_DOCS_PATH',
        'CI_DOCS_SITE_PATH'
    )
    Action            = {
        #region init
        $buildOutputRelativePath = Resolve-Path -Path $CI_BUILD_OUTPUT_PATH -Relative
        $docsPrivateRelativePath = Resolve-Path -Path $CI_DOCS_PRIVATE_PATH -Relative
        $docsPublicRelativePath = Resolve-Path -Path $CI_DOCS_PUBLIC_PATH -Relative
        #endregion

        Write-StatusUpdate -Message "Clean the build output directory: '${buildOutputRelativePath}'."
        Get-ChildItem -Path $CI_BUILD_OUTPUT_PATH -File |
            Remove-Item -Force

        Write-StatusUpdate -Message "Clean the cmdlet documentation directory: '${docsPublicRelativePath}'."
        Get-ChildItem -Path $CI_DOCS_PUBLIC_PATH -Filter $GLOB_MD |
            Remove-Item -Force

        Write-StatusUpdate -Message "Clean the private function documentation directory: '${docsPrivateRelativePath}'."
        Get-ChildItem -Path $CI_DOCS_PRIVATE_PATH -Filter $GLOB_MD |
            Remove-Item -Force

        Write-StatusUpdate -Message "Clean the documentation site directory: '${CI_DOCS_SITE_PATH}'"
        Remove-Item -Path $CI_DOCS_SITE_PATH -Recurse -Force -ErrorAction 'SilentlyContinue'
    }
    PostCondition     = {
        ( Get-ChildItem -Path $CI_BUILD_OUTPUT_PATH -File | Measure-Object ).Count -eq 0 -and
        ( Get-ChildItem -Path $CI_DOCS_PUBLIC_PATH -Filter $GLOB_MD | Measure-Object ).Count -eq 0 -and
        ( Get-ChildItem -Path $CI_DOCS_PRIVATE_PATH -Filter $GLOB_MD | Measure-Object ).Count -eq 0 -and
        ( Test-Path -Path $CI_DOCS_SITE_PATH ) -eq $false
    }
}
Task @task


$task = @{
    Name              = 'Build the module documentation content'
    Description       = 'This is handled in a separate script via a job due to some odd issues with inheritence in psake 4.7.0 that prevents platyPS 0.10.2 from running properly.'
    Depends           = $task.Name
    RequiredVariables = (
        'CI_BUILD_SCRIPTS_PATH',
        'CI_DOCS_PATH',
        'CI_MODULE_GUID',
        'CI_MODULE_MANIFEST_PATH',
        'CI_MODULE_NAME',
        'CI_MODULE_PATH',
        'CI_MODULE_VERSION',
        'CI_PROJECT_PATH',
        'TEXT'
    )
    Action            = {
        $splat = @{
            FilePath     = Join-Path -Path $CI_BUILD_SCRIPTS_PATH -ChildPath 'Build-Documentation.ps1'
            ArgumentList = @(
                $Global:CI_MODULE_NAME,
                $Script:CI_MODULE_VERSION,
                $CI_MODULE_GUID,
                $TEXT.GitHubPagesProjectUrl,
                $CI_PROJECT_PATH,
                $CI_MODULE_PATH,
                $CI_MODULE_MANIFEST_PATH,
                $CI_DOCS_PATH
            )
        }
        Start-Job @splat |
            Receive-Job -Wait -AutoRemoveJob |
            Out-Null
    }
    PostCondition     = {
        # Subtract the module page from the docs/public directory when comparing file count.
        ( ( Get-ChildItem -Path $CI_DOCS_PUBLIC_PATH -Filter $GLOB_MD | Measure-Object ).Count - 1 ) -eq
            ( Get-ChildItem -Path $CI_MODULE_PUBLIC_PATH -Filter $GLOB_PS1 | Measure-Object ).Count -and
        ( Get-ChildItem -Path $CI_DOCS_PRIVATE_PATH -Filter $GLOB_MD | Measure-Object ).Count -eq
            ( Get-ChildItem -Path $CI_MODULE_PRIVATE_PATH -Filter $GLOB_PS1 | Measure-Object ).Count
    }
}
Task @task


$task = @{
    Name         = 'Spell check the documentation'
    Description  = 'Spell check all Markdown files in the project.'
    Depends      = $task.Name
    Action       = {
        Write-StatusUpdate -Message 'Start markdown-spellcheck for spell checking the documentation.'
        mdspell --en-us --ignore-numbers --ignore-acronyms --report "**/${GLOB_MD}"
        if ( $? -eq $false ) {
            Write-StatusUpdate -Message 'Spelling errors found.' -Category 'Error'
        }
    }
}
Task @task


$task = @{
    Name              = 'Build the documentation site'
    Depends           = $task.Name
    RequiredVariables = (
        'CI_DOCS_SITE_PATH'
    )
    PreCondition      = {
        $TestMode -eq $false
    }
    Action            = {
        Write-StatusUpdate -Message 'Build the mkdocs site.'
        # mkdocs output is written directly to the console instead of stdout in v0.17.4 and earlier
        mkdocs build --clean --strict
        if ( $? -eq $false ) {
            Write-StatusUpdate -Message 'Failed to build the mkdocs site.' -Category 'Error'
        }
    }
    PostCondition     = {
        ( Test-Path -Path $CI_DOCS_SITE_PATH -PathType 'Container' ) -eq $true
    }
}
Task @task


$testTask = @{
    Name              = 'Test project'
    Depends           = $task.Name
    RequiredVariables = (
        'CI_COVERAGE_RESULTS_PATH',
        'CI_MODULE_PATH',
        'CI_TESTS_PATH',
        'CI_TEST_RESULTS_PATH',
        'CI_MODULE_NAME',
        'GLOB_PS1'
    )
    Action            = {
        $splat = @{
            Path         = $CI_TESTS_PATH
            OutputFormat = 'NUnitXml'
            OutputFile   = $CI_TEST_RESULTS_PATH
            PassThru     = $true
            Strict       = $true
        }

        if ( $TestTag.Count -gt 0 ) {
            $splat.Tag = $TestTag
        }

        if ( $ExcludeTestTag.Count -gt 0 ) {
            $splat.ExcludeTag = $ExcludeTestTag
        }

        if ( $Coverage -eq $true ) {
            $splat.CodeCoverage = Get-ChildItem -Path $CI_MODULE_PATH -Include "${Global:CI_MODULE_NAME}.psm1", $GLOB_PS1 -Recurse
            $splat.CodeCoverageOutputFile = $CI_COVERAGE_RESULTS_PATH
            $splat.CodeCoverageOutputFileFormat = 'JaCoCo'
        }

        if ( $TestMode -eq $true ) {
            $splat.PesterOption = New-PesterOption -IncludeVSCodeMarker
        }

        Write-StatusUpdate -Message 'Invoking Pester automated test framework.'
        $CI_TEST_RESULTS = Invoke-Pester @splat

        if (
            $CI_TEST_RESULTS |
                Where-Object -FilterScript { $_ | Get-Member -Name 'FailedCount' } |
                Where-Object -FilterScript { $_.FailedCount -gt 0 }
        ) {
            Write-StatusUpdate -Message "$( $CI_TEST_RESULTS.FailedCount ) tests failed." -Category 'Error'
        }
    }
    PostCondition     = {
        ( Test-Path -Path $CI_TEST_RESULTS_PATH ) -eq $true
    }
}
Task @testTask


$publishTestResults = @{
    Name              = 'Publish test results'
    Depends           = $testTask.Name
    RequiredVariables = (
        'CI_TEST_RESULTS_PATH'
    )
    PreCondition      = {
        $DeploymentMode -eq $true -and
        $TestMode -eq $false -and
        $CI_NAME -eq 'AppVeyor' -and
        ( Test-Path -Path $CI_TEST_RESULTS_PATH ) -eq $true -and
        $Env:APPVEYOR_JOB_ID -ne $null
    }
    Action            = {
        #region init
        $webClient = New-Object -TypeName 'System.Net.WebClient'
        #endregion

        $webClient.UploadFile(
            "https://ci.appveyor.com/api/testresults/nunit/${Env:APPVEYOR_JOB_ID}",
            $CI_TEST_RESULTS_PATH
        )
    }
}
Task @publishTestResults


$publishCodeCoverageTask = @{
    Name              = 'Publish code coverage'
    Depends           = $testTask.Name
    RequiredVariables = (
        'CI_BRANCH',
        'CI_TEST_RESULTS'
    )
    PreCondition      = {
        $DeploymentMode -eq $true -and
        $TestMode -eq $false -and
        $CI_NAME -eq 'AppVeyor' -and
        $CI_TEST_RESULTS -ne $null -and
        $Env:COVERALLS_API_KEY -ne $null
    }
    Action            = {
        Write-StatusUpdate -Message "Formatting code coverage for 'Coveralls.io'."
        $splat = @{
            'PesterResults'     = $CI_TEST_RESULTS
            'CoverallsApiToken' = $Env:COVERALLS_API_KEY
            'BranchName'        = $CI_BRANCH
        }
        $coverageResults = Format-Coverage @splat

        Write-StatusUpdate -Message "Publishing code coverage to 'Coveralls.io'." -Details $coverageResults
        Publish-Coverage -Coverage $coverageResults
    }
}
Task @publishCodeCoverageTask


$deployAppVeyorNuGetFeedTask = @{
    Name              = 'PSDeploy prerelease module to AppVeyor NuGet Feed'
    Depends           = $task.Name
    RequiredVariables = (
        'CI_DEPLOY_SCRIPTS_PATH',
        'CI_PROJECT_NAME',
        'CI_PROJECT_PATH'
    )
    PreCondition      = {
        $DeploymentMode -eq $true -and
        $TestMode -eq $false -and
        $CI_NAME -eq 'AppVeyor'
    }
    PreAction         = {
        #region init
        $prerelease = 'alpha'
        $Script:CI_MODULE_PRERELEASE_VERSION = "${Script:CI_MODULE_VERSION}-${prerelease}"
        #endregion

        Update-ModuleManifest -Path $CI_MODULE_MANIFEST_PATH -Prerelease $prerelease
        Remove-Module -Name "${Global:CI_MODULE_NAME}*"
        Import-Module -Name $CI_MODULE_MANIFEST_PATH -Force
    }
    Action            = {
        $path = Join-Path -Path $CI_DEPLOY_SCRIPTS_PATH -ChildPath 'AppVeyor.PSDeploy.ps1'
        Write-StatusUpdate -Message "Start PSDeploy task: '${path}'."
        Invoke-PSDeploy -Path $path -DeploymentRoot $CI_PROJECT_PATH -Force
    }
    PostAction        = {
        Update-ModuleManifest -Path $CI_MODULE_MANIFEST_PATH -Prerelease $null
        Remove-Module -Name "${Global:CI_MODULE_NAME}*"
        Import-Module -Name $CI_MODULE_MANIFEST_PATH -Force
    }
    PostCondition     = {
        ( Get-Metadata -Path $CI_MODULE_MANIFEST_PATH -PropertyName 'Prerelease' -ErrorAction 'SilentlyContinue' ) -eq $null
    }
}
Task @deployAppVeyorNuGetFeedTask


$deployPsGalleryTask = @{
    Name              = 'PSDeploy module to PowerShell Gallery'
    Depends           = $testTask.Name
    RequiredVariables = (
        'CI_DEPLOY_SCRIPTS_PATH',
        'CI_MODULE_NAME',
        'CI_PROJECT_PATH'
    )
    PreCondition      = {
        $DeploymentMode -eq $true -and
        $TestMode -eq $false -and
        $CI_COMMIT_MESSAGE -notmatch $CI_SKIP_PUBLISH_KEYWORD -and
        $CI_NAME -eq 'AppVeyor' -and
        $CI_PULL_REQUEST -eq $null -and
        $CI_BRANCH -eq 'master' -and
        $Env:APPVEYOR_REPO_TAG -eq $false -and
        $Env:NUGET_API_KEY -ne $null
    }
    Action            = {
        $path = Join-Path -Path $CI_DEPLOY_SCRIPTS_PATH -ChildPath 'PSGallery.PSDeploy.ps1'
        Write-StatusUpdate -Message "Start PSDeploy task: '${path}'."
        Invoke-PSDeploy -Path $path -DeploymentRoot $CI_PROJECT_PATH -Force
    }
}
Task @deployPsGalleryTask


$commitChangesTask = @{
    Name              = 'Commit & push changes'
    Depends           = $task.Name
    RequiredVariables = (
        'CI_BRANCH',
        'CI_DEPLOY_COMMIT_MESSAGE',
        'CI_MODULE_VERSION',
        'CI_PROJECT_NAME',
        'CI_PUBLISH_MESSAGE_FORM',
        'Env:HOME'
    )
    PreCondition      = {
        $DeploymentMode -eq $true -and
        $TestMode -eq $false -and
        $CI_NAME -eq 'AppVeyor' -and
        $CI_PULL_REQUEST -eq $null -and
        $Env:APPVEYOR_REPO_TAG -eq $false -and
        $Env:APPVEYOR_RE_BUILD -eq $true -and
        $Env:APPVEYOR_REPO_COMMIT_AUTHOR -ne $null -and
        $Env:APPVEYOR_REPO_COMMIT_AUTHOR_EMAIL -ne $null -and
        $Env:GITHUB_API_KEY -ne $null
    }
    PreAction         = {
        Write-StatusUpdate -Message 'Configure git'
        git config --local user.email $Env:APPVEYOR_REPO_COMMIT_AUTHOR_EMAIL
        git config --local user.name $Env:APPVEYOR_REPO_COMMIT_AUTHOR
        git config --local core.autocrlf true
        git config --local core.safecrlf false
        git config --local credential.helper store

        $splat = @{
            Path  = Join-Path -Path $Env:HOME -ChildPath '.git-credentials'
            Value = "https://${Env:GITHUB_API_KEY}:x-oauth-basic@github.com`n"
            Force = $true
        }
        Add-Content @splat
    }
    Action            = {
        #region init
        $message = $CI_PUBLISH_MESSAGE_FORM -f 'project', $CI_PROJECT_NAME, $Script:CI_MODULE_VERSION, 'GitHub'
        #endregion

        Write-StatusUpdate -Message $message
        $details = git checkout --quiet $CI_BRANCH |
            Out-String
        if ( $? -eq $false ) {
            Write-StatusUpdate -Message "Failed to checkout branch: '${CI_BRANCH}'." -Category 'Error'
        }

        $details += git add --all |
            Out-String
        if ( $? -eq $false ) {
            Write-StatusUpdate -Message "Failed to add changed files to index." -Category 'Error'
        }

        $details += git status |
            Out-String
        if ( $? -eq $false ) {
            Write-StatusUpdate -Message "Failed to retrieve status." -Category 'Error'
        }

        $details += git commit --signoff --message $CI_DEPLOY_COMMIT_MESSAGE |
            Out-String
        if ( $? -eq $false ) {
            Write-StatusUpdate -Message "Failed to commit changes." -Category 'Error'
        }

        $details += git push --porcelain --set-upstream origin $CI_BRANCH |
            Out-String
        if ( $? -eq $false ) {
            Write-StatusUpdate -Message "Failed to push to branch: '${CI_BRANCH}'." -Category 'Error'
        }

        Write-StatusUpdate -Message 'git output:' -Details $details
    }
}
Task @commitChangesTask


$deployReleaseTask = @{
    Name              = 'Create release'
    Description       = 'Tag commit & push tag to GitHub Releases.'
    Depends           = $commitChangesTask.Name
    RequiredVariables = (
        'CI_MODULE_VERSION',
        'CI_PROJECT_NAME',
        'CI_PUBLISH_MESSAGE_FORM'
    )
    PreCondition      = {
        $DeploymentMode -eq $true -and
        $TestMode -eq $false -and
        $CI_COMMIT_MESSAGE -notmatch $CI_SKIP_PUBLISH_KEYWORD -and
        $CI_NAME -eq 'AppVeyor' -and
        $CI_BRANCH -eq 'master' -and
        $CI_PULL_REQUEST -eq $null -and
        $Env:APPVEYOR_REPO_TAG -eq $false -and
        $Env:APPVEYOR_RE_BUILD -eq $true
    }
    Action            = {
        #region init
        $tag = "v${Script:CI_MODULE_VERSION}"
        $message = $CI_PUBLISH_MESSAGE_FORM -f 'project', $CI_PROJECT_NAME, $tag, 'GitHub Releases'
        #endregion

        Write-StatusUpdate -Message $message
        $details = git tag $tag |
            Out-String
        if ( $? -eq $false ) {
            Write-StatusUpdate -Message 'Failed to tag the commit.' -Category 'Error'
        }

        $details += git push --porcelain origin $tag |
            Out-String
        if ( $? -eq $false ) {
            Write-StatusUpdate -Message 'Failed to push the tag to GitHub.' -Category 'Error'
        }

        Write-StatusUpdate -Message 'git output:' -Details $details
    }
}
Task @deployReleaseTask


$deployDocsTask = @{
    Name              = 'Deploy documentation site'
    Depends           = $task.Name
    RequiredVariables = (
        'CI_DEPLOY_COMMIT_MESSAGE',
        'CI_MODULE_VERSION',
        'CI_PROJECT_NAME'
    )
    PreCondition      = {
        $DeploymentMode -eq $true -and
        $TestMode -eq $false -and
        $CI_NAME -eq 'AppVeyor' -and
        $CI_BRANCH -eq 'master' -and
        $CI_PULL_REQUEST -eq $null -and
        $Env:APPVEYOR_REPO_TAG -eq $false
    }
    Action            = {
        Write-StatusUpdate -Message "Publishing documentation: '${CI_PROJECT_NAME}' version: '${Script:CI_MODULE_VERSION}' to GitHub Pages."
        # mkdocs output is written directly to the console instead of stdout in v0.17.4 and earlier
        mkdocs gh-deploy --clean --message $CI_DEPLOY_COMMIT_MESSAGE
        if ( $? -eq $false ) {
            Write-StatusUpdate -Message 'Failed to build the mkdocs site.' -Category 'Error'
        }
    }
}
Task @deployDocsTask


$task = @{
    Name    = 'Default'
    Depends = (
        $task.Name,
        $testTask.Name,
        $publishTestResults.Name,
        $publishCodeCoverageTask.Name,
        $deployPsGalleryTask.Name,
        $commitChangesTask.Name,
        $deployReleaseTask.Name,
        $deployDocsTask.Name,
        $deployAppVeyorNuGetFeedTask.Name
    )
}
Task @task
