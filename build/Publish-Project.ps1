function OutWarning ( [String] $Message ) {
    Add-AppVeyorMessage -Message $Message -Category 'Warning'
    Write-Warning -Message "`n$Message`n"
}

function OutInfo ( [String] $Message ) {
    Add-AppVeyorMessage -Message $Message -Category 'Information'
    Write-Host -Object "`n$Message`n" -ForegroundColor 'Yellow'
}

$skipMessage = 'Skipping publish to the PowerShell Gallery'
$message = $null
$messageForm = '{0} for {1} "{2}".'

if ( $env:APPVEYOR -ne $true ) {
    Write-Warning -Message ( $messageForm -f $skipMessage, 'continuous integration platform', $env:CI_NAME )
}
elseif ( $env:CI_BRANCH -ne 'master' ) {
    OutWarning( ( $messageForm -f $skipMessage, 'branch', $env:CI_BRANCH ) )
}
elseif ( $env:CI_PULL_REQUEST -gt 0 ) {
    OutWarning( ( $messageForm -f $skipMessage, 'pull request', $env:CI_PULL_REQUEST ) )
}
elseif ( $env:APPVEYOR_JOB_NUMBER -eq 1 ) {
    $messageForm = '{0} module version "{1}" published to {2}.'

    # Publish the new version to the PowerShell Gallery
    Publish-Module -Path $env:CI_MODULE_PATH -NuGetApiKey $env:NUGET_API_KEY -ErrorAction 'Stop'

    OutInfo( ( $messageForm -f $env:CI_PROJECT_NAME, $env:CI_MODULE_VERSION, 'the PowerShell Gallery' ) )

    # Publish the new version back to GitHub
    git checkout master
    git add --all
    git status
    git commit --signoff --message "${env:CI_NAME}: Update version to $env:CI_MODULE_VERSION [ci skip]"
    git push --porcelain origin master

    OutInfo( ( $messageForm -f $env:CI_MODULE_NAME, $env:APPVEYOR_BUILD_VERSION, 'GitHub' ) )
}
