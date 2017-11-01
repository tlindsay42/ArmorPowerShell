ForEach ( $packageProvider In 'NuGet' )
{
	Write-Host -Object ( "`nInstalling package provider: '{0}'." -f $packageProvider ) -ForegroundColor 'Yellow'
	Install-PackageProvider -Name $packageProvider -Force
}
Remove-Variable -Name packageProvider

Write-Host -Object "`nInstalling package provider: 'NuGet'." -ForegroundColor 'Yellow'
Install-PackageProvider -Name 'NuGet' -Force | 
	Out-Null

ForEach ( $module In 'Pester', 'Posh-Git' )
{
	Write-Host -Object ( "`nInstalling module: '{0}'." -f $module ) -ForegroundColor 'Yellow'
	Install-Module -Name $module -Force
}
Remove-Variable -Name module

