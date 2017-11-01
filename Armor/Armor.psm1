#Get public and private function definition files.
$Public  = @( Get-ChildItem -Path $PSScriptRoot/Public/*.ps1 -ErrorAction SilentlyContinue )
$Private = @( Get-ChildItem -Path $PSScriptRoot/Private/*.ps1 -ErrorAction SilentlyContinue )

#Dot source the files
ForEach ( $import In @( $Public + $Private ) )
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
