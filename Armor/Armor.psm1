# Get class definition files, as well as the private and public function definition files.
$lib = @( Get-ChildItem -Path ( '{0}\Lib\*.ps1' -f $PSScriptRoot ) -ErrorAction 'SilentlyContinue' )
$private = @( Get-ChildItem -Path ( '{0}\Private\*.ps1' -f $PSScriptRoot ) -ErrorAction 'SilentlyContinue' )
$public = @( Get-ChildItem -Path ( '{0}\Public\*.ps1' -f $PSScriptRoot ) -ErrorAction 'SilentlyContinue' )

# Source the definition files
ForEach ( $import In @( $lib + $private + $public ) )
{
	Try
	{
		. $import.FullName
	}
	Catch
	{
		Write-Error -Message ( 'Failed to import function {0}: {1}.' -f $import.FullName, $_ )
	}
}

# Export the Public modules
Export-ModuleMember -Function $Public.BaseName
