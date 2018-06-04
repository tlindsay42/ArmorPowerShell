$aliases = Get-Content -Path "${PSScriptRoot}/Etc/Aliases.json" -ErrorAction 'Stop' |
    ConvertFrom-Json -ErrorAction 'Stop'

foreach ( $alias in $aliases ) {
    $splat = @{
        'Name' = $alias.Name
        'Value' = $alias.Value
        'Description' = $alias.Description
        'Option' = 'AllScope'
        'Scope' = 'Global'
        'Force' = $true
        'ErrorAction' = 'Stop'
    }
    New-Alias @splat
}

# Get class definition files, as well as the private and public function definition files.
$classesWithDependencies = Get-Content -Path "${PSScriptRoot}/Etc/ClassesWithDependenciesImportOrder.json" -ErrorAction 'Stop' |
    ConvertFrom-Json -ErrorAction 'Stop'

$lib = @()
$lib += Get-ChildItem -Path "${PSScriptRoot}/Lib/*.ps1" -Exclude $classesWithDependencies -ErrorAction 'Stop'

foreach ( $classWithDependencies in $classesWithDependencies ) {
    $lib += Get-ChildItem -Path "${PSScriptRoot}/Lib/${classWithDependencies}.ps1" -ErrorAction 'Stop'
}

$private = Get-ChildItem -Path "${PSScriptRoot}/Private/*.ps1" -ErrorAction 'Stop'
$public = Get-ChildItem -Path "${PSScriptRoot}/Public/*.ps1" -ErrorAction 'Stop'

# Source the definition files
foreach ( $import in ( $lib + $private + $public ) ) {
    . $import.FullName
}

# Export the Public modules
Export-ModuleMember -Function $public.BaseName -Alias $aliases.Name -ErrorAction 'Stop'
