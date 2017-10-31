Write-Host -Object "`nInstalling package provider: 'NuGet'." -ForegroundColor 'Yellow'
Install-PackageProvider -Name 'NuGet' -Force | 
	Out-Null

Write-Host -Object "`nInstalling module: 'Pester'." -ForegroundColor 'Yellow'
Install-Module -Name 'Pester' -Force

Write-Host -Object "`nInstalling module: 'posh-git'." -ForegroundColor 'Yellow'
Install-Module -Name 'posh-git' -Force
