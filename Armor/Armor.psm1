$aliases = Get-Content -Path "${PSScriptRoot}/Etc/Aliases.json" -ErrorAction 'Stop' |
    ConvertFrom-Json -ErrorAction 'Stop'

$lib = Get-ChildItem -Path "${PSScriptRoot}/Lib/*.ps1" -ErrorAction 'Stop'
$private = Get-ChildItem -Path "${PSScriptRoot}/Private/*.ps1" -ErrorAction 'Stop'
$public = Get-ChildItem -Path "${PSScriptRoot}/Public/*.ps1" -ErrorAction 'Stop'

foreach ( $import in $lib ) {
    . $import.FullName

    <#
    ScriptsToProcess in the manifest loads each script as a separate module.
    Once each type is loaded, the script module(s) no longer need to remain
    loaded.  The following command will successfully remove the script
    module(s), but throws an error, which is why 'SilentlyContinue' is configured.
    #>
    Remove-Module -Name $import.BaseName -Force -ErrorAction 'SilentlyContinue'
}

# Source the definition files
foreach ( $import in ( $private + $public ) ) {
    . $import.FullName
}

# Export the Public modules
Export-ModuleMember -Function $public.BaseName -Alias $aliases.Name -ErrorAction 'Stop'
