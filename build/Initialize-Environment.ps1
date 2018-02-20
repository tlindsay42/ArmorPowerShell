if ( ( Test-Path -Path $env:CI_RESULTS_PATH ) -eq $false ) {
    Write-Host -Object 'Creating the test results directory.' -ForegroundColor 'Yellow'

    New-Item -Path $env:CI_RESULTS_PATH -ItemType 'Directory' -Force -ErrorAction 'Stop'

    if ( ( Test-Path -Path $env:CI_RESULTS_PATH ) -eq $false ) {
        throw "Directory not found: '${env:CI_RESULTS_PATH}'."
    }
}

Write-Host -Object 'Listing all continuous integration environment variables.' -ForegroundColor 'Yellow'

( Get-ChildItem -Path 'env:' ).Where(
    {
        $_.Name -match "^(?:CI|${env:CI_NAME})(?:_|$)" -and
            $_.Name -notmatch 'EMAIL'
    }
) |
    Sort-Object -Property 'Name' |
    Format-Table -AutoSize -Property 'Name', 'Value' |
    Out-String |
    Write-Host
