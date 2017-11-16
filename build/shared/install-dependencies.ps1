Get-PackageProvider

# ForEach ( $packageProvider In 'NuGet' )
# {
# 	Write-Host -Object ( "`nInstalling package provider: '{0}'." -f $packageProvider ) -ForegroundColor 'Yellow'
# 	Install-PackageProvider -Name $packageProvider -Force |
# 		Out-Null
# }
# Remove-Variable -Name packageProvider

Set-PSRepository -Name 'PSGallery' -InstallationPolicy 'Trusted'

ForEach ( $module In 'Pester', 'Posh-Git', 'Coveralls' )
{
	Write-Host -Object ( "`nInstalling module: '{0}'." -f $module ) -ForegroundColor 'Yellow'
	Install-Module -Name $module -Force |
		Out-Null
}
Remove-Variable -Name module
