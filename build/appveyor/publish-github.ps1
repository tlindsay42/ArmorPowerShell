# Publish the new version back to Master on GitHub
# Set up a path to the git.exe cmd, import posh-git to give us control over git, and then push changes to GitHub
# Note that "update version" is included in the appveyor.yml file's "skip a build" regex to avoid a loop
if ( ( '{0}\Git\cmd' -f $env:ProgramFiles ) -notin $env:Path.Split( ';' ).Trim() ) {
    $env:Path += ';{0}\Git\cmd' -f $env:ProgramFiles
}

Import-Module -Name 'Posh-Git' -ErrorAction 'Stop'

git checkout --quiet master
git add --all
git status
git commit --signoff --message ( 'AppVeyor: Update version to {0} [ci skip]' -f $env:APPVEYOR_BUILD_VERSION )
git push --porcelain origin master

Write-Host -Object ( 'Armor PowerShell Module version {0} published to GitHub.' -f $env:APPVEYOR_BUILD_VERSION ) -ForegroundColor 'Cyan'
