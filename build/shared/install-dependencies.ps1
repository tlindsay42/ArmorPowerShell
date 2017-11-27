Set-PSRepository -Name 'PSGallery' -InstallationPolicy 'Trusted'

Write-Host -Object "`nInstalling modules:" -ForegroundColor 'Yellow'

foreach ( $moduleName in 'Pester', 'Coveralls' ) {
    Write-Host -Object ( '   {0}' -f $moduleName )
    if ( $env:APPVEYOR_BUILD_WORKER_IMAGE -eq 'Visual Studio 2015' ) {
        Install-Module -Name $moduleName -Scope 'CurrentUser' -Force -Confirm:$false |
            Out-Null
    }
    else {
        Install-Module -Name $moduleName -Scope 'CurrentUser' -SkipPublisherCheck -Force -Confirm:$false |
            Out-Null
    }
}
Remove-Variable -Name moduleName

Write-Host -Object ''
