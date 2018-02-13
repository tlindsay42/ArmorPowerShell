$table = ( Get-ChildItem -Path 'env:' ).Where(
    {
        $_.Name -match "^(?:CI|${env:CI_NAME})(?:_|$)" -and
            $_.Name -notmatch 'EMAIL'
    }
) |
    Select-Object -Property 'Name', 'Value' |
    Sort-Object -Property 'Name' |
    Format-Table -AutoSize |
    Out-String

# Print all of the continuous integration-related environment variables
Write-Host -Object $table

Remove-Variable -Name 'table'
