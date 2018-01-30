Set-PSRepository -Name 'PSGallery' -InstallationPolicy 'Trusted'

Write-Host -Object "`nInstalling modules:" -ForegroundColor 'Yellow'

foreach ( $providerName in 'NuGet', 'PowerShellGet' ) {
    Install-PackageProvider -Name $providerName -Scope 'CurrentUser' -Force -ForceBootstrap
}

foreach ( $moduleName in 'Pester', 'Coveralls' ) {
    Write-Host -Object ( '   {0}' -f $moduleName )
    if ( $env:APPVEYOR_BUILD_WORKER_IMAGE -eq 'Visual Studio 2015' ) {
        Install-Module -Name $moduleName -Scope 'CurrentUser' -Repository 'PSGallery' -Force -Confirm:$false |
            Out-Null
    }
    else {
        Install-Module -Name $moduleName -Scope 'CurrentUser' -Repository 'PSGallery' -SkipPublisherCheck -Force -Confirm:$false |
            Out-Null
    }

    Import-Module -Name $moduleName
}
Remove-Variable -Name 'moduleName'

Write-Host -Object ''
