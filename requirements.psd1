@{
    # Defaults for all dependencies, unless overridden
    PSDependOptions   = @{
        Target = 'CurrentUser'
        Tags   = 'Default', 'WindowsOnly'
    }

    # Continuous-Integration / Continuous Deployment (CI/CD) tools
    BuildHelpers      = 'Latest'

    # Code coverage deployment tool
    Coveralls         = @{
        Tags    = 'WindowsOnly'
        Version = 'Latest'
    }

    # Multiplexor of package providers
    PackageManagement = @{
        Tags    = 'Base'
        Version = 'Latest'
    }

    # Framework for Behavior Driven Development (BDD) test automation
    Pester            = @{
        Parameters = @{
            SkipPublisherCheck = $true
        }
        Version    = 'Latest'
    }

    # Documentation generation tool
    platyPS           = 'Latest'

    # Module updating & publishing tool
    PowerShellGet     = @{
        Tags    = 'Base'
        Version = 'Latest'
    }

    # Build automation tool
    psake             = 'Latest'

    # Deployment tool
    PSDeploy          = 'Latest'

    <#
    PSScriptAnalyzer provides script analysis and checks for potential code defects in
    the scripts by applying a group of built-in or customized rules on the scripts
    being analyzed.
    #>
    PSScriptAnalyzer  = 'Latest'
}
