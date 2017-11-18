Set-PSRepository -Name 'PSGallery' -InstallationPolicy 'Trusted'

ForEach ( $module In 'Pester', 'Posh-Git', 'Coveralls' )
{
	Write-Host -Object ( "Installing module: '{0}'." -f $module ) -ForegroundColor 'Yellow'
	Install-Module -Name $module -Force |
		Out-Null
}
Remove-Variable -Name module
