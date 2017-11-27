function OutWarning ( [String] $Message ) {
    Add-AppVeyorMessage -Message $Message -Category 'Warning'
    Write-Warning -Message ( "`n{0}`n" -f $Message )
}

$skipMessage = 'Skipping publish to the PowerShell Gallery'
$message = $null
$messageForm = '{0} for {1} "{2}".'

if ( $env:APPVEYOR_REPO_BRANCH -ne 'master' ) {
    OutWarning( ( $messageForm -f $skipMessage, 'branch', $env:APPVEYOR_REPO_BRANCH ) )
}
elseif ( $env:APPVEYOR_PULL_REQUEST_NUMBER -gt 0 ) {
    OutWarning( ( $messageForm -f $skipMessage, 'pull request', $env:APPVEYOR_PULL_REQUEST_NUMBER ) )
}
elseif ( $env:APPVEYOR_REPO_COMMIT_AUTHOR_EMAIL -ne $env:EMAIL_ADDRESS ) {
    OutWarning( ( $messageForm -f $skipMessage, 'commit author', $env:APPVEYOR_REPO_COMMIT_AUTHOR ) )
}
elseif ( $env:APPVEYOR_JOB_NUMBER -eq 1 ) {
    $message = '{0} Module version {1} published to the PowerShell Gallery.' -f $env:APPVEYOR_PROJECT_NAME, $env:MODULE_VERSION

    # Publish the new version to the PowerShell Gallery
    Publish-Module -Path $env:MODULE_PATH -NuGetApiKey $env:NUGET_API_KEY -ErrorAction 'Stop'

    Add-AppVeyorMessage -Message $message -Category 'Information'

    Write-Host -Object ( "`n{0}`n" -f $message ) -ForegroundColor 'Yellow'
}
