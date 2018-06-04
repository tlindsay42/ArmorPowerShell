foreach ( $className in 'ArmorVM' ) {
    $classPath = Split-Path -Path $MyInvocation.MyCommand.Path -Parent |
        Join-Path -ChildPath "${className}.ps1"
    . $classPath
}

class ArmorCompleteWorkloadTier {
    [ValidateRange( 1, 65535 )]
    [UInt16] $ID

    [ValidateNotNullOrEmpty()]
    [String] $Name

    [AllowEmptyCollection()]
    [ArmorVM[]] $VMs
}
