#
# Script module for module 'Armor'
#
Set-StrictMode -Version 'Latest'

# Set up some helper variables to make it easier to work with the module
$Script:PSModule = $ExecutionContext.SessionState.Module

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

$aliases = ( Get-Alias ).Where( { $_.Source -eq $Script:PSModule.Name } )

$splat = @{
    ErrorAction = 'Stop'
}

if ( ( $public.BaseName | Measure-Object ).Count -gt 0 ) {
    $splat.Add( 'Function', $public.BaseName )
}

if ( ( $aliases.Name | Measure-Object ).Count -gt 0 ) {
    $splat.Add( 'Alias', $aliases.Name )
}

# Export the Public modules
Export-ModuleMember @splat
