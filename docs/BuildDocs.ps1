Import-Module -Name ( '{0}\..\Armor' -f $PSScriptRoot ) -Force

ForEach ( $verb In ( Get-Command -Module Armor ).Verb | Select-Object -Unique )
{
	$data = @()
	$data += '{0} Commands' -f $verb
	$data += '========================='
	$data += ''
	$data += 'This page contains details on **{0}** commands.' -f $verb
	$data += ''

	ForEach ( $help In ( Get-Command -Module Armor ).Where( { $_.Name -match ( '^{0}-' -f $verb ) } ) )
	{
		$data += $help.Name
		$data += '-------------------------'
		$data += ''
		$data += Get-Help -Name $help.name -Detailed
		$data += ''
	}

	$data |
		Out-File -FilePath ( '{0}\cmd_{1}.rst' -f $PSScriptRoot, $verb.ToLower() ) -Encoding utf8

	Write-Output -InputObject ( "`tcmd_{0}" -f $verb.ToLower() )
}
