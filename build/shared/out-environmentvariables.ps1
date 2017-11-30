Push-Location -Path 'env:'

$table = ( Get-ChildItem ).Where( { $_.Name -match '^(?:CI|{0})(?:_|$)' -f $env:CI_NAME } ) |
    Select-Object -Property 'Name', 'Value' |
    Sort-Object -Property 'Name' |
    Format-Table -AutoSize |
    Out-String

if ( $env:APPVEYOR -eq $true ) {
    Add-AppveyorMessage -Message $table -Category 'Information'
}

# Print all of the continuous integration-related environment variables
Write-Host -Object $table

Remove-Variable -Name 'table'

Pop-Location
