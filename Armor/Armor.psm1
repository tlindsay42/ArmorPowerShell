$aliases = Get-Content -Path "${PSScriptRoot}/Etc/Aliases.json" -ErrorAction 'Stop' |
    ConvertFrom-Json -ErrorAction 'Stop'

$lib = @( Get-ChildItem -Path "${PSScriptRoot}/Lib/*.ps1" -ErrorAction 'Stop' )
$private = @( Get-ChildItem -Path "${PSScriptRoot}/Private/*.ps1" -ErrorAction 'Stop' )
$public = @( Get-ChildItem -Path "${PSScriptRoot}/Public/*.ps1" -ErrorAction 'Stop' )

# Source the definition files
foreach ( $import in ( $lib + $private + $public ) ) {
    . $import.FullName
}

# Export the Public modules
Export-ModuleMember -Function $public.BaseName -Alias $aliases.Name -ErrorAction 'Stop'
