Write-Host -Object "`nListing all continuous integration environment variables." -ForegroundColor 'Yellow'

( Get-ChildItem -Path 'Env:' ).Where(
    {
        $_.Name -match "^(?:CI|${Env:CI_NAME})(?:_|$)" -and
            $_.Name -notmatch 'EMAIL'
    }
) |
    Sort-Object -Property 'Name' |
    Format-Table -AutoSize -Property 'Name', 'Value' |
    Out-String |
    Write-Host
