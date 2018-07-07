@{
    # Defaults for all dependencies, unless overridden
    PSDependOptions       = @{
        Target = 'CurrentUser'
        Tags   = 'Default', 'WindowsOnly'
    }
    
    # Continuous-Integration / Continuous Deployment (CI/CD) tools
    BuildHelpers          = 'Latest'

    # Code coverage deployment tool
    Coveralls             = @{
        Tags           = 'WindowsOnly'
        Version        = 'Latest'
    }

    # Framework for Behavior Driven Development (BDD) test automation
    Pester                = @{
        Parameters = @{
            SkipPublisherCheck = $true
        }
        Version    = 'Latest'
    }

    # Documentation generation tool
    platyPS               = 'Latest'

    # Build automation tool
    psake                 = 'Latest'

    # Deployment tool
    PSDeploy              = 'Latest'
}
