function OutWarning ( [String] $Message ) {
    Add-AppVeyorMessage -Message $Message -Category 'Warning'
    Write-Warning -Message "`n$Message`n"
}

function OutInfo ( [String] $Message ) {
    Add-AppVeyorMessage -Message $Message -Category 'Information'
    Write-Host -Object "`n$Message`n" -ForegroundColor 'Yellow'
}

$message = $null
$messageForm = "Skipping publish to The PowerShell Gallery & GitHub Releases for {0}: '{1}'."
$skipKeyword = 'skip publish'
$commitMessageKeyword = 'commit message keyword'
$tag = "v${Env:CI_MODULE_VERSION}"
$tempFile = [System.IO.Path]::GetTempFileName()

if ( $Env:APPVEYOR -ne $true ) {
    Write-Warning -Message ( $messageForm -f 'continuous integration platform', $Env:CI_NAME )
}
elseif ( $Env:APPVEYOR_REPO_TAG -eq $true ) {
    OutWarning( ( $messageForm -f 'tag build', $true ) )
}
elseif ( $Env:CI_PULL_REQUEST -gt 0 ) {
    OutWarning( ( $messageForm -f 'pull request', $Env:CI_PULL_REQUEST ) )
}
elseif ( $Env:APPVEYOR_JOB_NUMBER -ne 1 ) {
    OutWarning( ( $messageForm -f 'job', $Env:APPVEYOR_JOB_NUMBER ) )
}
elseif ( $Env:APPVEYOR_JOB_NUMBER -eq 1 ) {
    $messageForm = "Skipping publish to {0} for {1}: '{2}'."
    $publishForm = "Publishing {0}: '{1}' version: '{2}' to {3}."

    if ( $Env:CI_BRANCH -eq 'master' ) {
        if ( $Env:APPVEYOR_REPO_COMMIT_MESSAGE -match "\[${skipKeyword}\]" ) {
            OutWarning( ( $messageForm -f 'The PowerShell Gallery', $commitMessageKeyword, "[${skipKeyword}]" ) )
        }
        else {
            OutInfo( ( $publishForm -f 'module', $Env:CI_MODULE_NAME, $Env:CI_MODULE_VERSION, 'The PowerShell Gallery' ) )

            # Publish the new version to the PowerShell Gallery
            Publish-Module -Path $Env:CI_MODULE_PATH -NuGetApiKey $Env:NUGET_API_KEY -ErrorAction 'Stop'
        }
    }

    OutInfo( ( $publishForm -f 'project', $Env:CI_PROJECT_NAME, $Env:APPVEYOR_BUILD_VERSION, 'GitHub' ) )

    if ( $Env:APPVEYOR_RE_BUILD -eq $true ) {
        OutWarning( ( $messageForm -f 'GitHub', 'rebuild', $true ) )
    }
    else {
        # Publish the new version back to GitHub
        git checkout --quiet $Env:CI_BRANCH 2> $tempFile
        Get-Content -Path $tempFile

        git add --all
        git status
        git commit --signoff --message "${Env:CI_NAME}: Update version to ${Env:CI_MODULE_VERSION} [ci skip]"
        git push --porcelain --set-upstream origin $Env:CI_BRANCH

        if ( $Env:CI_BRANCH -eq 'master' ) {
            if ( $Env:APPVEYOR_REPO_COMMIT_MESSAGE -match "\[${skipKeyword}\]" ) {
                OutWarning( ( $messageForm -f 'GitHub Releases', $commitMessageKeyword, "[${skipKeyword}]" ) )
            }
            else {
                OutInfo( ( $publishForm -f 'project', $Env:CI_PROJECT_NAME, $Env:CI_MODULE_VERSION, 'GitHub Releases' ) )

                # Publish the new version to GitHub Releases
                git tag $tag
                git push --porcelain origin $tag
            }
        }
    }

    if ( $Env:APPVEYOR_ACCOUNT_NAME -eq $Env:CI_OWNER_NAME -and $Env:CI_BRANCH -eq 'master' ) {
        OutInfo( ( $publishForm -f 'documentation', $Env:CI_PROJECT_NAME, $Env:CI_MODULE_VERSION, 'GitHub Pages' ) )

        # Publish the documentation to GitHub Pages
        git fetch --quiet origin 'gh-pages' 2> $tempFile
        Get-Content -Path $tempFile

        git checkout --quiet 'gh-pages' 2> $tempFile
        Get-Content -Path $tempFile

        git clean -d -x --force 2> $tempFile
        Get-Content -Path $tempFile

        git pull origin 'gh-pages' 2> $tempFile
        Get-Content -Path $tempFile

        git checkout --quiet $Env:CI_BRANCH 2> $tempFile
        Get-Content -Path $tempFile

        mkdocs gh-deploy 2> $tempFile
        Get-Content -Path $tempFile
    }

    Write-Host -Object ''
}
else {
    throw 'Unknown deployment condition.'
}
