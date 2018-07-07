#requires -Version 5.0

[CmdletBinding()]
param (
    # Deployment mode.
    [Switch] $DeploymentMode = $false,

    # Test mode.
    [Switch] $TestMode = $false,

    <#
    Bypasses the BuildHelpers initialization of environment variables if running
    locally instead of from a supported CI system.
    #>
    [Switch] $Local = $false,

    # Include automated tests assigned the specified tags.
    [String[]] $TestTag = @(),

    # Exclude automated tests assigned the specified tags.
    [String[]] $ExcludeTestTag = @(),

    # Specifies whether to build a code coverage report.
    [Switch] $Coverage = $false,

    # Skips dependency testing & installation if enabled.
    [Switch] $SkipDependencies = $false
)

#region Includes
. ( Join-Path -Path $PSScriptRoot -ChildPath 'private' | Join-Path -ChildPath 'Write-StatusUpdate.ps1' )
#endregion

#region Set the error action preference
$errorAction = 'Stop'
$ErrorActionPreference = $errorAction
Write-StatusUpdate -Message "Set the ErrorAction preference to: '${errorAction}'."
Remove-Variable -Name 'errorAction'
#endregion

if ( $SkipDependencies -eq $false ) {
    #region Install PowerShell package providers
    $providerNames = 'NuGet', 'PowerShellGet'
    Write-StatusUpdate -Message "Install PowerShell package providers: $( ( $providerNames.ForEach( { "'${_}'" } ) -join ', ' ) )."
    $details = Get-PackageProvider $providerNames -Force -ForceBootstrap |
        Format-Table -AutoSize -Property 'Name', 'Version' |
        Out-String
    Write-StatusUpdate -Message 'PowerShell package providers:' -Details $details
    Remove-Variable -Name 'providerNames'
    #endregion

    #region Configure PowerShell repositories
    $splats = @(
        @{
            Name                      = 'PSGallery'
            SourceLocation            = 'https://www.powershellgallery.com/api/v2/'
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
        MinimumVersion = '0.2.5'
        Repository     = 'PSGallery'
        Force          = $true
    }
    if ( ( Get-Module -ListAvailable -Name $splat.Name ) -eq $null ) {
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

    Invoke-PSDepend -Path $psdependPath -Tags $tag -Install -Import -Confirm:$false

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
    Remove-Item -Path $tempFile -Force
    Remove-Variable -Name 'tempFile', 'temp'
    Write-StatusUpdate -Message 'NodeJS development dependencies:' -Details $details
    #endregion

    #region python dev dependencies
    Write-StatusUpdate -Message 'Install python development dependencies.'
    $requirementsPath = Join-Path -Path $Env:BHProjectPath -ChildPath 'requirements.txt'
    $details = pip install --user --requirement $requirementsPath |
        Out-String
    if ( $? -eq $false ) {
        Write-StatusUpdate -Message 'Failed to install python development dependencies.' -Category 'Error'
        }
    Remove-Variable -Name 'psdependPath', 'requirementsPath'
    Write-StatusUpdate -Message 'python development dependencies:' -Details $details
    #endregion
    #endregion
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
