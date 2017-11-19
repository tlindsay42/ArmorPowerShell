If ( $env:APPVEYOR -eq $true )
{
	$env:BUILD_PATH = $env:APPVEYOR_BUILD_FOLDER
	$env:MODULE_PATH = '{0}\{1}' -f $env:BUILD_PATH, $env:MODULE_NAME
	$env:MODULE_VERSION = $env:APPVEYOR_BUILD_VERSION
	$env:OWNER_NAME = $env:APPVEYOR_ACCOUNT_NAME
	$env:PROJECT_NAME = $env:APPVEYOR_PROJECT_NAME
}

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
