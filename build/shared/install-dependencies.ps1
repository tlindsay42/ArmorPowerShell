Set-PSRepository -Name 'PSGallery' -InstallationPolicy 'Trusted'

Write-Host -Object "`nInstalling modules:" -ForegroundColor 'Yellow'

ForEach ( $module In 'Pester', 'Posh-Git', 'Coveralls' )
{
	Write-Host -Object ( '   {0}' -f $module )
	Install-Module -Name $module -Force |
		Out-Null
}
Remove-Variable -Name module

Write-Host -Object ''
