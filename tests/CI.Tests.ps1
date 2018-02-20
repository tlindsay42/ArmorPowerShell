if ( $env:CI -eq $true ) {
    Describe 'Environment Variables' {
        Context 'CI Abstraction' {
            It 'should set $env:CI_BUILD_PATH to a directory that exists' {
                Test-Path -Path $env:CI_BUILD_PATH -PathType 'Container' |
                    Should -Be $true
            }

            It 'should set $env:CI_BUILD_SCRIPTS_PATH to a directory that exists' {
                Test-Path -Path $env:CI_BUILD_SCRIPTS_PATH -PathType 'Container' |
                    Should -Be $true
            }

            It 'should set $env:CI_OWNER_NAME be a valid username' {
                ( Invoke-WebRequest -Method 'Get' -Uri "https://github.com/${env:CI_OWNER_NAME}" ).StatusCode |
                    Should -Be 200
            }

            It 'should set $env:CI_PROJECT_NAME correctly' {
                $env:CI_PROJECT_NAME |
                    Should -Be ( Split-Path -Path $env:CI_BUILD_PATH -Leaf )
            }
        }

        Context 'Coveralls' {
            It 'should set $env:CI_NAME to either "AppVeyor" or "Travis"' {
                $env:CI_NAME |
                    Should -BeIn 'AppVeyor', 'Travis'
            }

            It 'should set $env:CI_BUILD_NUMBER to an unsigned integer' {
                $env:CI_BUILD_NUMBER |
                    Should -Match '^\d+$'
            }

            It 'should set $env:CI_BUILD_URL to a URL that exists' {
                ( Invoke-WebRequest -Method 'Get' -Uri $env:CI_BUILD_URL ).StatusCode |
                    Should -Be 200
            }

            It 'should set $env:CI_BRANCH' {
                $env:CI_BRANCH |
                    Should -Not -BeNullOrEmpty
            }

            if ( $env:CI_PULL_REQUEST -ne $null ) {
                It 'should set $env:CI_PULL_REQUEST' {
                    $env:CI_PULL_REQUEST |
                        Should -Not -BeNullOrEmpty
                }
            }
        }

        Context 'Module' {
            It 'should set $env:CI_MODULE_NAME to "Armor"' {
                $env:CI_MODULE_NAME |
                    Should -Be 'Armor'
            }

            It 'should set $env:CI_MODULE_LIB_PATH to a directory that exists' {
                Test-Path -Path $env:CI_MODULE_LIB_PATH -PathType 'Container' |
                    Should -Be $true
            }

            It 'should set $env:CI_MODULE_PRIVATE_PATH to a directory that exists' {
                Test-Path -Path $env:CI_MODULE_PRIVATE_PATH -PathType 'Container' |
                    Should -Be $true
            }

            It 'should set $env:CI_MODULE_PUBLIC_PATH to a directory that exists' {
                Test-Path -Path $env:CI_MODULE_PUBLIC_PATH -PathType 'Container' |
                    Should -Be $true
            }

            It 'should set $env:CI_MODULE_MANIFEST_PATH to a file that exists' {
                Test-Path -Path $env:CI_MODULE_MANIFEST_PATH -PathType 'Leaf' |
                    Should -Be $true
            }

            It 'should set $env:CI_MODULE_MANIFEST_PATH to a valid module manifest' {
                { Test-ModuleManifest -Path $env:CI_MODULE_MANIFEST_PATH } |
                    Should -Not -Throw
            }

            It 'should set $env:CI_MODULE_VERSION to the same version in the module manifest' {
                $env:CI_MODULE_VERSION |
                    Should -Be ( Test-ModuleManifest -Path $env:CI_MODULE_MANIFEST_PATH ).Version.ToString()
            }
        }

        Context 'Test Result Paths' {
            It 'should set $env:CI_TESTS_PATH to a directory that exists' {
                Test-Path -Path $env:CI_TESTS_PATH -PathType 'Container' |
                    Should -Be $true
            }

            It 'should set $env:CI_TEST_RESULTS_PATH to a new file' {
                Test-Path -Path $env:CI_TEST_RESULTS_PATH -PathType 'Leaf' |
                    Should -Be $false
            }

            It 'should set $env:CI_COVERAGE_RESULTS_PATH to a new file' {
                Test-Path -Path $env:CI_COVERAGE_RESULTS_PATH -PathType 'Leaf' |
                    Should -Be $false
            }
        }

        Context 'Documentation Path' {
            It 'should set $env:CI_DOCS_PATH to a directory that exists' {
                Test-Path -Path $env:CI_DOCS_PATH -PathType 'Container' |
                    Should -Be $true
            }
        }

        Context 'CI Script Paths' {
            It 'should set $env:CI_INITIALIZE_ENVIRONMENT_SCRIPT_PATH to a file that exists' {
                Test-Path -Path $env:CI_INITIALIZE_ENVIRONMENT_SCRIPT_PATH -PathType 'Leaf' |
                    Should -Be $true
            }

            It 'should set $env:CI_INSTALL_DEPENDENCIES_SCRIPT_PATH to a file that exists' {
                Test-Path -Path $env:CI_INSTALL_DEPENDENCIES_SCRIPT_PATH -PathType 'Leaf' |
                    Should -Be $true
            }

            It 'should set $env:CI_BUILD_PROJECT_SCRIPT_PATH to a file that exists' {
                Test-Path -Path $env:CI_BUILD_PROJECT_SCRIPT_PATH -PathType 'Leaf' |
                    Should -Be $true
            }

            It 'should set $env:CI_START_TESTS_SCRIPT_PATH to a file that exists' {
                Test-Path -Path $env:CI_START_TESTS_SCRIPT_PATH -PathType 'Leaf' |
                    Should -Be $true
            }

            It 'should set $env:CI_PUBLISH_PROJECT_SCRIPT_PATH to a file that exists' {
                Test-Path -Path $env:CI_PUBLISH_PROJECT_SCRIPT_PATH -PathType 'Leaf' |
                    Should -Be $true
            }
        }
    }

    if ( $env:APPVEYOR -eq $true ) {
        Describe 'Git' {
            Context 'Configuration Files' {
                It 'should have a git config file' {
                    Join-Path -Path $env:USERPROFILE -ChildPath '.gitconfig' |
                        Test-Path -PathType 'Leaf' |
                        Should -Be $true
                }

                It 'should have a git credential file' {
                    Join-Path -Path $env:USERPROFILE -ChildPath '.git-credentials' |
                        Test-Path -PathType 'Leaf' |
                        Should -Be $true
                }
            }

            Context 'Configuration Settings' {
                It "should set 'user.name' to the commit author" {
                    git config --global --get 'user.name' |
                        Should -Be $env:APPVEYOR_REPO_COMMIT_AUTHOR
                }

                It "should set 'user.email' to the commit author's email address" {
                    git config --global --get 'user.email' |
                        Should -Be $env:APPVEYOR_REPO_COMMIT_AUTHOR_EMAIL
                }

                It "should set 'credential.helper' to 'store'" {
                    git config --global --get 'credential.helper' |
                        Should -Be 'store'
                }

                It "should set 'core.autocrlf' to 'true'" {
                    git config --global --get 'core.autocrlf' |
                        Should -Be 'true'
                }

                It "should set 'core.safecrlf' to 'false'" {
                    git config --global --get 'core.safecrlf' |
                        Should -Be 'false'
                }
            }
        }
    }
}
