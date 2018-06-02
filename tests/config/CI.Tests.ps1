if ( $Env:CI -eq $true ) {
    Describe -Name 'Environment Variables' -Tag 'Environment Variables', 'Config' -Fixture {
        Context -Name 'CI Abstraction' -Fixture {
            It -Name 'should set $Env:CI_BUILD_PATH to a directory that exists' -Test {
                Test-Path -Path $Env:CI_BUILD_PATH -PathType 'Container' |
                    Should -Be $true
            } # End of It

            It -Name 'should set $Env:CI_BUILD_SCRIPTS_PATH to a directory that exists' -Test {
                Test-Path -Path $Env:CI_BUILD_SCRIPTS_PATH -PathType 'Container' |
                    Should -Be $true
            } # End of It

            It -Name 'should set $Env:CI_OWNER_NAME be a valid username' -Test {
                ( Invoke-WebRequest -Method 'Get' -Uri "https://github.com/${Env:CI_OWNER_NAME}" ).StatusCode |
                    Should -Be 200
            } # End of It

            It -Name 'should set $Env:CI_PROJECT_NAME correctly' -Test {
                $Env:CI_PROJECT_NAME |
                    Should -Be ( Split-Path -Path $Env:CI_BUILD_PATH -Leaf )
            } # End of It
        } # End of Context

        Context -Name 'Coveralls' -Fixture {
            It -Name 'should set $Env:CI_NAME to either "AppVeyor" or "Travis"' -Test {
                $Env:CI_NAME |
                    Should -BeIn 'AppVeyor', 'Travis'
            } # End of It

            It -Name 'should set $Env:CI_BUILD_NUMBER to an unsigned integer' -Test {
                $Env:CI_BUILD_NUMBER |
                    Should -Match '^\d+$'
            } # End of It

            It -Name 'should set $Env:CI_BUILD_URL to a URL that exists' -Test {
                ( Invoke-WebRequest -Method 'Get' -Uri $Env:CI_BUILD_URL ).StatusCode |
                    Should -Be 200
            } # End of It

            It -Name 'should set $Env:CI_BRANCH' -Test {
                $Env:CI_BRANCH |
                    Should -Not -BeNullOrEmpty
            } # End of It

            if ( $Env:CI_PULL_REQUEST -ne $null ) {
                It -Name 'should set $Env:CI_PULL_REQUEST' -Test {
                    $Env:CI_PULL_REQUEST |
                        Should -Not -BeNullOrEmpty
                } # End of It
            }
        } # End of Context

        Context -Name 'Module' -Fixture {
            It -Name 'should set $Env:CI_MODULE_NAME to "Armor"' -Test {
                $Env:CI_MODULE_NAME |
                    Should -Be 'Armor'
            } # End of It

            It -Name 'should set $Env:CI_MODULE_LIB_PATH to a directory that exists' -Test {
                Test-Path -Path $Env:CI_MODULE_LIB_PATH -PathType 'Container' |
                    Should -Be $true
            } # End of It

            It -Name 'should set $Env:CI_MODULE_PRIVATE_PATH to a directory that exists' -Test {
                Test-Path -Path $Env:CI_MODULE_PRIVATE_PATH -PathType 'Container' |
                    Should -Be $true
            } # End of It

            It -Name 'should set $Env:CI_MODULE_PUBLIC_PATH to a directory that exists' -Test {
                Test-Path -Path $Env:CI_MODULE_PUBLIC_PATH -PathType 'Container' |
                    Should -Be $true
            } # End of It

            It -Name 'should set $Env:CI_MODULE_MANIFEST_PATH to a file that exists' -Test {
                Test-Path -Path $Env:CI_MODULE_MANIFEST_PATH -PathType 'Leaf' |
                    Should -Be $true
            } # End of It

            It -Name 'should set $Env:CI_MODULE_MANIFEST_PATH to a valid module manifest' -Test {
                { Test-ModuleManifest -Path $Env:CI_MODULE_MANIFEST_PATH } |
                    Should -Not -Throw
            } # End of It

            It -Name 'should set $Env:CI_MODULE_VERSION to the same version in the module manifest' -Test {
                $Env:CI_MODULE_VERSION |
                    Should -Be ( Test-ModuleManifest -Path $Env:CI_MODULE_MANIFEST_PATH ).Version.ToString()
            } # End of It
        } # End of Context

        Context -Name 'Test Result Paths' -Fixture {
            It -Name 'should set $Env:CI_TESTS_PATH to a directory that exists' -Test {
                Test-Path -Path $Env:CI_TESTS_PATH -PathType 'Container' |
                    Should -Be $true
            } # End of It

            It -Name 'should set $Env:CI_TEST_RESULTS_PATH to a new file' -Test {
                Test-Path -Path $Env:CI_TEST_RESULTS_PATH -PathType 'Leaf' |
                    Should -Be $false
            } # End of It

            It -Name 'should set $Env:CI_COVERAGE_RESULTS_PATH to a new file' -Test {
                Test-Path -Path $Env:CI_COVERAGE_RESULTS_PATH -PathType 'Leaf' |
                    Should -Be $false
            } # End of It
        } # End of Context

        Context -Name 'Documentation Path' -Fixture {
            It -Name 'should set $Env:CI_DOCS_PATH to a directory that exists' -Test {
                Test-Path -Path $Env:CI_DOCS_PATH -PathType 'Container' |
                    Should -Be $true
            } # End of It
        } # End of Context

        Context -Name 'CI Script Paths' -Fixture {
            It -Name 'should set $Env:CI_INITIALIZE_ENVIRONMENT_SCRIPT_PATH to a file that exists' -Test {
                Test-Path -Path $Env:CI_INITIALIZE_ENVIRONMENT_SCRIPT_PATH -PathType 'Leaf' |
                    Should -Be $true
            } # End of It

            It -Name 'should set $Env:CI_INSTALL_DEPENDENCIES_SCRIPT_PATH to a file that exists' -Test {
                Test-Path -Path $Env:CI_INSTALL_DEPENDENCIES_SCRIPT_PATH -PathType 'Leaf' |
                    Should -Be $true
            } # End of It

            It -Name 'should set $Env:CI_BUILD_PROJECT_SCRIPT_PATH to a file that exists' -Test {
                Test-Path -Path $Env:CI_BUILD_PROJECT_SCRIPT_PATH -PathType 'Leaf' |
                    Should -Be $true
            } # End of It

            It -Name 'should set $Env:CI_START_TESTS_SCRIPT_PATH to a file that exists' -Test {
                Test-Path -Path $Env:CI_START_TESTS_SCRIPT_PATH -PathType 'Leaf' |
                    Should -Be $true
            } # End of It

            It -Name 'should set $Env:CI_PUBLISH_PROJECT_SCRIPT_PATH to a file that exists' -Test {
                Test-Path -Path $Env:CI_PUBLISH_PROJECT_SCRIPT_PATH -PathType 'Leaf' |
                    Should -Be $true
            } # End of It
        } # End of Context
    } # End of Describe

    if ( $Env:APPVEYOR -eq $true ) {
        Describe -Name 'Git' -Tag 'Git', 'Config' -Fixture {
            Context -Name 'Configuration Files' -Fixture {
                It -Name 'should have a git config file' -Test {
                    Join-Path -Path $Env:USERPROFILE -ChildPath '.gitconfig' |
                        Test-Path -PathType 'Leaf' |
                        Should -Be $true
                } # End of It

                It -Name 'should have a git credential file' -Test {
                    Join-Path -Path $Env:USERPROFILE -ChildPath '.git-credentials' |
                        Test-Path -PathType 'Leaf' |
                        Should -Be $true
                } # End of It
            } # End of Context

            Context -Name 'Configuration Settings' -Fixture {
                It -Name "should set 'user.name' to the commit author" -Test {
                    git config --global --get 'user.name' |
                        Should -Be $Env:APPVEYOR_REPO_COMMIT_AUTHOR
                } # End of It

                It -Name "should set 'user.email' to the commit author's email address" -Test {
                    git config --global --get 'user.email' |
                        Should -Be $Env:APPVEYOR_REPO_COMMIT_AUTHOR_EMAIL
                } # End of It

                It -Name "should set 'credential.helper' to 'store'" -Test {
                    git config --global --get 'credential.helper' |
                        Should -Be 'store'
                } # End of It

                It -Name "should set 'core.autocrlf' to 'true'" -Test {
                    git config --global --get 'core.autocrlf' |
                        Should -Be 'true'
                } # End of It

                It -Name "should set 'core.safecrlf' to 'false'" -Test {
                    git config --global --get 'core.safecrlf' |
                        Should -Be 'false'
                } # End of It
            } # End of Context
        } # End of Describe
    }
}
