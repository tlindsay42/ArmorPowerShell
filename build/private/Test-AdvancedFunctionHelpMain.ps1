function Test-AdvancedFunctionHelpMain ( [PSObject] $Help ) {
    $contextName = $Global:FORM_FUNCTION_HELP -f 'Main'
    Context -Name $contextName -Fixture {
        #region init
        $name = $Help.Name
        $template = '{ ?required: .+ ?}'
        $uriRegex = @(
            "^$( $TEXT.GitHubPagesProjectUrl )(?:private|public)/${name}/$",
            "^$( $TEXT.RepoUrl )/blob/master/${Global:CI_MODULE_NAME}/(?:Private|Public)/${name}.ps1$"
        )
        #endregion

        $testCases = @(
            @{ Property = 'Synopsis' },
            @{ Property = 'Description' },
            @{ Property = 'Examples' },
            @{ Property = 'Component' },
            @{ Property = 'Functionality' }
        )
        $testName = 'should have content in section: <Property>'
        It -Name $testName -TestCases $testCases -Test {
            param ( [String] $Property )
            $Help.$Property |
                Should -Not -BeNullOrEmpty
        }

        $testName = "should not match the template entry: '${template}' in section: <Property>"
        It -Name $testName -TestCases $testCases -Test {
            param ( [String] $Property )
            $Help.$Property |
                Should -Not -Match $template
        }

        for ( $i = 0; $i -lt ( $Help.Examples.Example | Measure-Object ).Count; $i++ ) {
            $testName = "should not match the template entry: '${template}' in: 'Example $( $i + 1 )'"
            It -Name $testName -Test {
                param ( [String] $Property )
                $Help.Examples.Example[$i] |
                    Should -Not -Match $template
            }
        }

        $testName = "should have at least four help: 'Link' entries"
        It -Name $testName -Test {
            $Help.RelatedLinks.NavigationLink.Uri.Count |
                Should -BeGreaterThan 3
        }

        $helpLinks = $Help.RelatedLinks.NavigationLink.Uri
        if ( $CI_COMMIT_MESSAGE -match '\[new\]' ) {
            $helpLinks = $helpLinks.Where( {
                    $_ -notmatch ( $uriRegex -join '|' )
                }
            )
        }
        foreach ( $uri in $helpLinks ) {
            $testName = "should be a valid help link: '${uri}'"
            It -Name $testName -Test {
                ( Invoke-WebRequest -Method 'Get' -Uri $uri ).StatusCode |
                    Should -Be 200
            }
        }

        $uri = $uriRegex[0]
        $testName = "should match: '${uri}' link 1"
        It -Name $testName -Test {
            $Help.RelatedLinks.NavigationLink.Uri[0] |
                Should -Match $uri
        }

        $uri = $uriRegex[1]
        $testName = "should match: '${uri}' for link 2"
        It -Name $testName -Test {
            $Help.RelatedLinks.NavigationLink.Uri[1] |
                Should -Match $uri
        }
    }
}
