$env:CI_MODULE_NAME = 'Armor'

if ( $env:APPVEYOR -eq $true ) {
    # CI abstraction variables
    $env:CI_OWNER_NAME = $env:APPVEYOR_ACCOUNT_NAME
    $env:CI_PROJECT_NAME = $env:APPVEYOR_PROJECT_NAME
    # Coveralls environment variables
    $env:CI_NAME = 'AppVeyor'
    $env:CI_BUILD_NUMBER = $env:APPVEYOR_BUILD_NUMBER
    $env:CI_BUILD_URL = "https://ci.appveyor.com/project/${env:CI_OWNER_NAME}/${env:CI_PROJECT_NAME}/build/job/${env:APPVEYOR_JOB_ID}"
    $env:CI_BRANCH = $env:APPVEYOR_REPO_BRANCH
    $env:CI_PULL_REQUEST = $env:APPVEYOR_PULL_REQUEST_NUMBER
}
elseif ( $env:TRAVIS -eq $true ) {
    # CI abstraction variables
    $repoSlug = $env:TRAVIS_REPO_SLUG.Split( '/' )
    $env:CI_OWNER_NAME = $repoSlug[0]
    $env:CI_PROJECT_NAME = $repoSlug[-1]
    # Coveralls environment variables
    $env:CI_NAME = 'Travis'
    $env:CI_BUILD_NUMBER = $env:TRAVIS_BUILD_NUMBER
    $env:CI_BUILD_URL = "https://travis-ci.org/${env:CI_OWNER_NAME}/${env:CI_PROJECT_NAME}/jobs/${env:TRAVIS_JOB_ID}"
    $env:CI_BRANCH = $env:TRAVIS_BRANCH
    $env:CI_PULL_REQUEST = $env:TRAVIS_PULL_REQUEST
}
else {
    throw 'This is not a supported continuous integration environment.'
}

$env:CI_MODULE_PATH = Join-Path -Path $env:CI_BUILD_PATH -ChildPath $env:CI_MODULE_NAME
$env:CI_MODULE_MANIFEST_PATH = Join-Path -Path $env:CI_MODULE_PATH -ChildPath "$env:CI_MODULE_NAME.psd1"
$env:CI_MODULE_LIB_PATH = Join-Path -Path $env:CI_MODULE_PATH -ChildPath 'Lib'
$env:CI_MODULE_PRIVATE_PATH = Join-Path -Path $env:CI_MODULE_PATH -ChildPath 'Private'
$env:CI_MODULE_PUBLIC_PATH = Join-Path -Path $env:CI_MODULE_PATH -ChildPath 'Public'

if ( $env:APPVEYOR -eq $true ) {
    $env:CI_MODULE_VERSION = ( $env:APPVEYOR_BUILD_VERSION ).Split( '-' )[0]
}
elseif ( $env:TRAVIS -eq $true ) {
    $env:CI_MODULE_VERSION = (
        Get-Content -Path $env:CI_MODULE_MANIFEST_PATH |
            Select-String -Pattern 'ModuleVersion' |
            Out-String
    ).Split( "'" )[1]
}

$env:CI_TESTS_PATH = Join-Path -Path $env:CI_BUILD_PATH -ChildPath 'tests'
$env:CI_RESULTS_PATH = Join-Path -Path $env:CI_TESTS_PATH -ChildPath 'results'
$env:CI_TEST_RESULTS_PATH = Join-Path -Path $env:CI_RESULTS_PATH -ChildPath "${env:CI_NAME}TestsResults.xml"
$env:CI_COVERAGE_RESULTS_PATH = Join-Path -Path $env:CI_RESULTS_PATH -ChildPath "${env:CI_NAME}CodeCoverageResults.xml"

$env:CI_DOCS_PATH = Join-Path -Path $env:CI_BUILD_PATH -ChildPath 'docs'

$env:CI_INSTALL_DEPENDENCIES_SCRIPT_PATH = Join-Path -Path $env:CI_BUILD_SCRIPTS_PATH -ChildPath 'Install-Dependencies.ps1'
$env:CI_BUILD_PROJECT_SCRIPT_PATH = Join-Path -Path $env:CI_BUILD_SCRIPTS_PATH -ChildPath 'Build-Project.ps1'
$env:CI_START_TESTS_SCRIPT_PATH = Join-Path -Path $env:CI_TESTS_PATH -ChildPath 'Start-Tests.ps1'
$env:CI_PUBLISH_PROJECT_SCRIPT_PATH = Join-Path -Path $env:CI_BUILD_SCRIPTS_PATH -ChildPath 'Publish-Project.ps1'


if ( ( Test-Path -Path $env:CI_RESULTS_PATH ) -eq $false ) {
    New-Item -Path $env:CI_RESULTS_PATH -ItemType 'Directory' -Force -ErrorAction 'Stop'

    if ( ( Test-Path -Path $env:CI_RESULTS_PATH ) -eq $false ) {
        throw "Directory not found: '${env:CI_RESULTS_PATH}'."
    }
}

$table = ( Get-ChildItem -Path 'env:' ).Where(
    {
        $_.Name -match "^(?:CI|${env:CI_NAME})(?:_|$)" -and
            $_.Name -notmatch 'EMAIL'
    }
) |
    Select-Object -Property 'Name', 'Value' |
    Sort-Object -Property 'Name' |
    Format-Table -AutoSize |
    Out-String

# Print all of the continuous integration-related environment variables
Write-Host -Object $table

Remove-Variable -Name 'table'
