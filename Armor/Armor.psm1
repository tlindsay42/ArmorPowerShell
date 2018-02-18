$filter = '*.ps1'

# Get class definition files, as well as the private and public function definition files.
$lib = Get-ChildItem -Path $env:CI_MODULE_LIB_PATH -Filter $filter -ErrorAction 'Stop'
$private = Get-ChildItem -Path $env:CI_MODULE_PRIVATE_PATH -Filter $filter -ErrorAction 'Stop'
$public = Get-ChildItem -Path $env:CI_MODULE_PUBLIC_PATH -Filter $filter -ErrorAction 'Stop'

# Source the definition files
foreach ( $import in ( $lib + $private + $public ) ) {
    . $import.FullName
}

# Export the Public modules
Export-ModuleMember -Function $Public.BaseName -ErrorAction 'Stop'
