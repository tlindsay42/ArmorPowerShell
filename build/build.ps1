#requires -Version 5.0

[CmdletBinding()]
param (
    # Deployment mode.
    [Parameter( Position = 0 )]
    [Switch]
    $DeploymentMode = $false,

    # Test mode.
    [Parameter( Position = 1 )]
    [Switch]
    $TestMode = $false,

    <#
    Bypasses the BuildHelpers initialization of environment variables if running
    locally instead of from a supported CI system.
    #>
    [Parameter( Position = 2 )]
    [Switch]
    $Local = $false,

    # Include automated tests assigned the specified tags.
    [Parameter( Position = 3 )]
    [AllowNull()]
    [String[]]
    $TestTag = @(),

    # Exclude automated tests assigned the specified tags.
    [Parameter( Position = 4 )]
    [AllowNull()]
    [String[]]
    $ExcludeTestTag = @(),

    # Specifies whether to build a code coverage report.
    [Parameter( Position = 5 )]
    [ValidateSet( $true, $false )]
    [Boolean]
    $Coverage = $true,

    # Skips dependency testing & installation if enabled.
    [Parameter( Position = 6 )]
    [Switch]
    $SkipDependencies = $false
)

#region Includes
. ( Join-Path -Path $PSScriptRoot -ChildPath 'private' | Join-Path -ChildPath 'Write-StatusUpdate.ps1' )
#endregion

#region Set the error action preference
$errorAction = 'Stop'
$ErrorActionPreference = $errorAction
Write-StatusUpdate -Message "Set the error action preference to: '${errorAction}'."
Remove-Variable -Name 'errorAction'
#endregion

#region Set the progress preference
# The progress bar generates really ugly console output in most continuous integration environments
$progressBarAction = 'SilentlyContinue'
$ProgressPreference = $progressBarAction
Write-StatusUpdate -Message "Set the progress bar preference to: '${progressBarAction}'."
Remove-Variable -Name 'progressBarAction'
#endregion

#region Set strict mode
$strictModeVersion = 'Latest'
Write-StatusUpdate -Message "Set PowerShell strict mode to version: '${strictModeVersion}'."
Set-StrictMode -Version $strictModeVersion
Remove-Variable -Name 'strictModeVersion'
#endregion

# Print the path directories
$Env:PATH

if ( $SkipDependencies -eq $false ) {
    if ( $Env:CI_LINUX -eq $false ) {
        #region Install PowerShell package providers
        $providerNames = 'NuGet', 'PowerShellGet'
        Write-StatusUpdate -Message "Install PowerShell package providers: $( ( $providerNames.ForEach( { "'${_}'" } ) -join ', ' ) )."
        $details = Get-PackageProvider -Name $providerNames -Force -ForceBootstrap |
            Format-Table -AutoSize -Property 'Name', 'Version' |
            Out-String
        Write-StatusUpdate -Message 'PowerShell package providers:' -Details $details
        Remove-Variable -Name 'providerNames'
        #endregion
    }

    #region Import package management modules
    $modules = 'PackageManagement', 'PowerShellGet'
    Write-StatusUpdate -Message "Import the $( ( $modules.ForEach( { "'${_}'" } ) -join ', ' ) ) modules."
    foreach ( $module in $modules ) {
        Import-Module -Name $module -Force
    }
    $details = Get-Module -Name $modules |
        Format-Table -AutoSize -Property 'Name', 'Version' |
        Out-String
    Write-StatusUpdate -Message 'Provider modules:' -Details $details
    #endregion

    #region Configure PowerShell repositories
    $splats = @(
        @{
            Name                      = 'PSGallery'
            InstallationPolicy        = 'Trusted'
            PackageManagementProvider = 'NuGet'
        }
    )
    Write-StatusUpdate -Message "Configure PowerShell repositories: $( ( $splats.Name.ForEach( { "'${_}'" } ) -join ', ' ) )."
    $details = ''
    foreach ( $splat in $splats ) {
        Set-PSRepository @splat
        $details += Get-PSRepository -Name $splat.Name |
            Format-List |
            Out-String
    }
    Write-StatusUpdate -Message 'PowerShell repositories:' -Details $details
    Remove-Variable -Name 'splats'
    #endregion

    #region Install & import PSDepend
    Write-StatusUpdate -Message "Install & import the 'PSDepend' module."
    $splat = @{
        Name           = 'PSDepend'
        Scope          = 'CurrentUser'
        MinimumVersion = '0.3.0'
        Repository     = 'PSGallery'
        Force          = $true
    }
    $psdepend = Get-Module -ListAvailable -Name $splat.Name
    if ( $null -eq $psdepend ) {
        Install-Module @splat
    }
    elseif ( $psdepend.Version.ToString() -lt $splat.MinimumVersion ) {
        Install-Module @splat
    }

    $splat.Scope = 'Local'
    $splat.Remove( 'Repository' )
    Import-Module @splat

    $details = Get-Module -Name $splat.Name |
        Format-Table -AutoSize -Property 'Name', 'Version' |
        Out-String
    Write-StatusUpdate -Message 'PSDepend module:' -Details $details
    #endregion

    #region Install development dependencies
    #region PowerShell Module dev dependencies
    $tag = ''
    if ( $Env:CI_WINDOWS -eq $true ) {
        $tag = 'WindowsOnly'
    }
    else {
        $tag = 'Default'
    }
    Write-StatusUpdate -Message "Install PSDepend managed PowerShell module development dependencies."
    $psdependPath = Split-Path -Path $PSScriptRoot -Parent |
        Join-Path -ChildPath 'requirements.psd1'

    $base = 'Base'
    Invoke-PSDepend -Path $psdependPath -Tags $base -Install -Force -ErrorAction 'Continue'
    Remove-Module -Name 'PowerShellGet', 'PackageManagement'
    Invoke-PSDepend -Path $psdependPath -Tags $base -Import -Confirm:$false -ErrorAction 'Continue'
    Remove-Variable -Name 'base'

    Invoke-PSDepend -Path $psdependPath -Tags $tag -Install -Import -Confirm:$false -ErrorAction 'Continue'
    Remove-Variable -Name 'tag'

    $details = Get-Dependency -Path $psdependPath |
        Format-Table -AutoSize -Property 'DependencyName', 'DependencyType', 'Version' |
        Out-String
    Write-StatusUpdate -Message 'PSDepend managed development dependencies:' -Details $details

    if ( $Local -eq $false ) {
        Write-StatusUpdate -Message "Load the 'BuildHelpers' environment variables."
        Set-BuildEnvironment -Force
    }
    #endregion

    #region NodeJS dev dependencies
    Write-StatusUpdate -Message 'Install NodeJS development dependencies.'
    $temp = $ErrorActionPreference
    $ErrorActionPreference = 'Continue'
    $tempFile = [System.IO.Path]::GetTempFileName()
    npm install --global sinon@1 markdown-spellcheck 2>&1 > $tempFile
    $ErrorActionPreference = $temp
    $details = Get-Content -Path $tempFile |
        Out-String
    if ( -not ( Get-Command -Name 'mdspell' -ErrorAction 'SilentlyContinue' ) ) {
        Write-StatusUpdate -Message 'Failed to install NodeJS development dependencies.' -Category 'Error'
    }
    $details += Get-Command -Name 'mdspell' -ErrorAction 'Continue' |
        Format-Table -AutoSize -Property 'Name', 'Source' |
        Out-String
    Remove-Item -Path $tempFile -Force
    Remove-Variable -Name 'tempFile', 'temp'
    Write-StatusUpdate -Message 'NodeJS development dependencies:' -Details $details
    #endregion

    #region python dev dependencies
    Write-StatusUpdate -Message 'Install python development dependencies.'
    $temp = $ErrorActionPreference
    $ErrorActionPreference = 'Continue'
    $requirementsPath = Join-Path -Path $Env:BHProjectPath -ChildPath 'requirements.txt'
    $return = $null
    $details = pip3 install --upgrade pip |
        Out-String
    $return = $?
    $details += pip3 install --requirement $requirementsPath |
        Out-String
    $return = $?
    $ErrorActionPreference = $temp
    $mkdocs = Get-Command -Name 'mkdocs' -ErrorAction 'Continue'
    if ( $mkdocs -eq $null ) {
        Write-StatusUpdate -Message 'Failed to install python development dependencies.' -Category 'Error' -Details $details
    }
    else {
        $details += $mkdocs |
            Format-Table -AutoSize -Property 'Name', 'Source' |
            Out-String
    }
    Remove-Variable -Name 'psdependPath', 'requirementsPath', 'return'
    Write-StatusUpdate -Message 'python development dependencies:' -Details $details
    #endregion
    #endregion
}

if ( $DeploymentMode -eq $true ) {
    Write-StatusUpdate -Message 'Configure git'
    git config --local user.email $Env:APPVEYOR_REPO_COMMIT_AUTHOR_EMAIL
    git config --local user.name $Env:APPVEYOR_REPO_COMMIT_AUTHOR
    git config --local core.autocrlf true
    git config --local core.safecrlf false
    git config --local credential.helper store

    $splat = @{
        Path  = Join-Path -Path $Env:USERPROFILE -ChildPath '.git-credentials'
        Value = "https://${Env:GITHUB_API_KEY}:x-oauth-basic@github.com`n"
        Force = $true
    }
    Add-Content @splat
}

<#
Enable verbose mode for the build if the commit message contains the
appropriate flag.
#>
$commitFlag = '!Verbose'
$verbose = $false
if ( $Env:BHCommitMessage -match $commitFlag ) {
    Write-StatusUpdate -Message "Verbose mode is now enabled for this build per commit flag '${commitFlag}'."
    $VerbosePreference = 'Continue'
    $verbose = $true
    Write-Host
}
Remove-Variable -Name 'commitFlag'

if ( ( Test-Path -Path $Env:BHBuildOutput ) -eq $false ) {
    Write-StatusUpdate -Message "Create the build output directory: '${Env:BHBuildOutput}'."
    New-Item -Path $Env:BHBuildOutput -ItemType 'Directory' -Force
}

Write-StatusUpdate -Message 'Start the psake (PowerShell make) build automation tool.'
$splat = @{
    BuildFile  = Join-Path -Path $PSScriptRoot -ChildPath 'psakefile.ps1'
    Parameters = @{
        DeploymentMode = $DeploymentMode
        TestMode       = $TestMode
        Coverage       = $Coverage
        Local          = $Local
    }
    Verbose    = $verbose
}
if ( ( $TestTag | Measure-Object ).Count -gt 0 ) {
    $splat.Parameters.Add( 'TestTag', $TestTag )
}
if ( ( $ExcludeTestTag | Measure-Object ).Count -gt 0 ) {
    $splat.Parameters.Add( 'ExcludeTestTag', $ExcludeTestTag )
}
Invoke-psake @splat

exit ( -not $psake.build_success ).ToInt16( $null )
