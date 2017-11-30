function OutWarning ( [String] $Message ) {
    Add-AppVeyorMessage -Message $Message -Category 'Warning'
    Write-Warning -Message ( "`n{0}`n" -f $Message )
}

function OutInfo ( [String] $Message ) {
    Add-AppVeyorMessage -Message $Message -Category 'Information'
    Write-Host -Message ( "`n{0}`n" -f $Message ) -ForegroundColor 'Yellow'
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
    $messageForm = '{0} module version "{1}" published to {2}.'
    # Publish the new version to the PowerShell Gallery
    Publish-Module -Path $env:CI_MODULE_PATH -NuGetApiKey $env:NUGET_API_KEY -ErrorAction 'Stop'

    OutInfo( ( $messageForm -f $env:APPVEYOR_PROJECT_NAME, $env:CI_MODULE_VERSION, 'the PowerShell Gallery' ) )

    # Publish the new version back to GitHub
    git add --all
    git status
    git commit --signoff --message ( 'AppVeyor: Update version to {0} [ci skip]' -f $env:APPVEYOR_BUILD_VERSION )
    git push --porcelain origin master

    OutInfo( ( $messageForm -f $env:CI_MODULE_NAME, $env:APPVEYOR_BUILD_VERSION, 'GitHub' ) )
}
