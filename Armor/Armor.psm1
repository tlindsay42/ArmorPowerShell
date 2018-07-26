$moduleName = ( Get-Item -Path $PSScriptRoot ).BaseName

$glob = '*.ps1'

$lib = @(
    Join-Path -Path $PSScriptRoot -ChildPath 'Lib' |
        Get-ChildItem -Filter $glob -ErrorAction 'Stop'
)

$private = @(
    Join-Path -Path $PSScriptRoot -ChildPath 'Private' |
        Get-ChildItem -Filter $glob -ErrorAction 'Stop'
)

$public = @(
    Join-Path -Path $PSScriptRoot -ChildPath 'Public' |
        Get-ChildItem -Filter $glob -ErrorAction 'Stop'
)

# Source the definition files
foreach ( $import in ( $lib + $private + $public ) ) {
    . $import.FullName
}

$aliases = ( Get-Alias ).Where( { $_.Source -eq $moduleName } )

# Export the Public modules
Export-ModuleMember -Function $public.BaseName -Alias $aliases.Name -ErrorAction 'Stop'
