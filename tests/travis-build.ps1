# Install InvokeBuild
Install-Module -Name InvokeBuild -Scope CurrentUser -Force
Install-Module -Name PlatyPS -Scope CurrentUser -Force

# Build the code and perform tests
Import-Module -Name InvokeBuild
Invoke-Build
