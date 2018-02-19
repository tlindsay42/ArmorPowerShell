Set-PSRepository -Name 'PSGallery' -InstallationPolicy 'Trusted'

Write-Host -Object "`nInstalling package providers:" -ForegroundColor 'Yellow'
foreach ( $providerName in 'NuGet', 'PowerShellGet' ) {
    if ( -not ( Get-PackageProvider $providerName -ErrorAction 'SilentlyContinue' ) ) {
        Install-PackageProvider -Name $providerName -Scope 'CurrentUser' -Force -ForceBootstrap
    }
    Get-PackageProvider -Name $providerName
}

Write-Host -Object "`nInstalling modules:" -ForegroundColor 'Yellow'
foreach ( $moduleName in 'Pester', 'Coveralls' ) {
    if ( $env:APPVEYOR_BUILD_WORKER_IMAGE -eq 'Visual Studio 2015' ) {
        Install-Module -Name $moduleName -Scope 'CurrentUser' -Repository 'PSGallery' -Force -Confirm:$false |
            Out-Null
    }
    else {
        Install-Module -Name $moduleName -Scope 'CurrentUser' -Repository 'PSGallery' -SkipPublisherCheck -Force -Confirm:$false |
            Out-Null
    }
    
    Import-Module -Name $moduleName
    Get-Module -Name $moduleName
}
Remove-Variable -Name 'moduleName'

Write-Host -Object ''

& node --version
& npm --version

& npm install -g sinon@1 markdown-spellcheck
