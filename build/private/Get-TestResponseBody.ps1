function Get-TestResponseBody ( [String] $FileName ) {
    [String] $return = ''

    $path = Join-Path -Path $CI_BUILD_PATH -ChildPath 'etc'
    $filePath = Join-Path -Path $path -ChildPath $FileName
    if ( ( Test-Path -Path $filePath ) -eq $true ) {
        $return = Get-Content -Path $filePath

        if ( ( ConvertFrom-Json -InputObject $return -ErrorAction 'SilentlyContinue' ) -eq '' ) {
            throw "Invalid JSON content: '${filePath}'"
        }
    }

    $return
}
