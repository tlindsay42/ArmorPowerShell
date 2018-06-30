if ( $Env:CI -eq $true ) {
    Describe -Name 'Environment Variables' -Tag 'Environment Variables', 'Config' -Fixture {
        Context -Name 'CI Abstraction' -Fixture {
            $testCases = @(
                @{
                    VariableName = '$CI_BUILD_PATH'
                    Path         = $CI_BUILD_PATH
                },
                @{
                    VariableName = '$CI_BUILD_SCRIPTS_PATH'
                    Path         = $CI_BUILD_SCRIPTS_PATH
                }
            )
            $testName = 'should set: <VariableName> to a directory that exists'
            It -Name $testName -TestCases $testCases -Test {
                param ( [String] $Path )
                Test-Path -Path $Path -PathType 'Container' |
                    Should -Be $true
            }

            It -Name "should set: '`$CI_OWNER_NAME' be a valid username" -Test {
                ( Invoke-WebRequest -Method 'Get' -Uri "https://github.com/${CI_OWNER_NAME}" ).StatusCode |
                    Should -Be 200
            }

            It -Name "should set: '`$CI_PROJECT_NAME' correctly" -Test {
                $CI_PROJECT_NAME |
                    Should -Be ( Split-Path -Path $CI_PROJECT_PATH -Leaf )
            }
        }

        Context -Name 'Coveralls' -Fixture {
            $testCases = 'AppVeyor', 'Travis'
            It -Name "should set: '`$CI_NAME' to one of the following: $( $testCases -join ', ' )" -Test {
                $CI_NAME |
                    Should -BeIn $testCases
            }

            It -Name "should set: '`$CI_BUILD_NUMBER' to an unsigned integer" -Test {
                $CI_BUILD_NUMBER |
                    Should -Match '^\d+$'
            }

            It -Name "should set: '`$CI_BUILD_URL' to a URL that exists" -Test {
                ( Invoke-WebRequest -Method 'Get' -Uri $CI_BUILD_URL ).StatusCode |
                    Should -Be 200
            }

            $testCases = @(
                @{
                    VariableName = '$CI_BRANCH'
                    String       = $CI_BRANCH
                }
            )
            $testName = 'should set: <VariableName>'
            It -Name $testName -TestCases $testCases -Test {
                param ( [String] $String )
                $String |
                    Should -Not -BeNullOrEmpty
            }

            if ( $CI_PULL_REQUEST -ne $null ) {
                It -Name "should set: '`$CI_PULL_REQUEST'" -Test {
                    $CI_PULL_REQUEST |
                        Should -Not -BeNullOrEmpty
                }
            }
            else {
                It -Name "should not set: '`$CI_PULL_REQUEST'" -Test {
                    $CI_PULL_REQUEST |
                        Should -BeNullOrEmpty
                }
            }
        }

        Context -Name 'Module' -Fixture {
            $testCases = @(
                @{ Name = 'Armor' }
            )
            $testName = "should set: '`$Global:CI_MODULE_NAME' to: <Name>"
            It -Name $testName -TestCases $testCases -Test {
                param ( [String] $Name )
                $Global:CI_MODULE_NAME |
                    Should -Be $Name
            }

            $testCases = @(
                @{
                    VariableName = '$CI_MODULE_ETC_PATH'
                    Path         = $CI_MODULE_ETC_PATH
                },
                @{
                    VariableName = '$CI_MODULE_LIB_PATH'
                    Path         = $CI_MODULE_LIB_PATH
                },
                @{
                    VariableName = '$CI_MODULE_PRIVATE_PATH'
                    Path         = $CI_MODULE_PRIVATE_PATH
                },
                @{
                    VariableName = '$CI_MODULE_PUBLIC_PATH'
                    Path         = $CI_MODULE_PUBLIC_PATH
                }
            )
            $testName = 'should set: <VariableName> to a directory that exists'
            It -Name $testName -TestCases $testCases -Test {
                param ( [String] $Path )
                Test-Path -Path $Path -PathType 'Container' |
                    Should -Be $true
            }

            $testCases = @(
                @{
                    VariableName = '$CI_MODULE_MANIFEST_PATH'
                    Path         = $CI_MODULE_MANIFEST_PATH
                }
            )
            $testName = 'should set: <VariableName> to a file that exists'
            It -Name $testName -TestCases $testCases -Test {
                param ( [String] $Path )
                Test-Path -Path $Path -PathType 'Leaf' |
                    Should -Be $true
            }

            It -Name "should set: '`$CI_MODULE_MANIFEST_PATH' to a valid module manifest" -Test {
                { Test-ModuleManifest -Path $CI_MODULE_MANIFEST_PATH } |
                    Should -Not -Throw
            }

            It -Name "should set: '`$CI_MODULE_VERSION' to the same version in the module manifest" -Test {
                $CI_MODULE_VERSION |
                    Should -Be ( Test-ModuleManifest -Path $CI_MODULE_MANIFEST_PATH ).Version.ToString()
            }
        }

        Context -Name 'Test Result Paths' -Fixture {
            It -Name "should set: '`$CI_TESTS_PATH' to a directory that exists" -Test {
                Test-Path -Path $CI_TESTS_PATH -PathType 'Container' |
                    Should -Be $true
            }

            $testCases = @(
                @{
                    VariableName = '$CI_TEST_RESULTS_PATH'
                    Path         = $CI_TEST_RESULTS_PATH
                },
                @{
                    VariableName = '$CI_COVERAGE_RESULTS_PATH'
                    Path         = $CI_COVERAGE_RESULTS_PATH
                }
            )
            $testName = 'should set: <VariableName> to a new file'
            It -Name $testName -TestCases $testCases -Test {
                param ( [String] $Path )
                Test-Path -Path $Path -PathType 'Leaf' |
                    Should -Be $false
            }
        }

        Context -Name 'Documentation Path' -Fixture {
            It -Name "should set: '`$CI_DOCS_PATH' to a directory that exists" -Test {
                Test-Path -Path $CI_DOCS_PATH -PathType 'Container' |
                    Should -Be $true
            }
        }
    }

    if ( $DeploymentMode -eq $true ) {
        Describe -Name 'Git' -Tag 'Git', 'Config' -Fixture {
            Context -Name 'Configuration Files' -Fixture {
                $testCases = @(
                    @{
                        FileType = 'git config'
                        Path     = Join-Path -Path $Env:HOME -ChildPath '.gitconfig'
                    },
                    @{
                        FileType = 'git credential'
                        Path     = Join-Path -Path $Env:HOME -ChildPath '.git-credentials'
                    }
                )
                $testName = 'should have a: <FileType> file'
                It -Name $testName -TestCases $testCases -Test {
                    param ( [String] $Path )
                    Test-Path -Path $Path -PathType 'Leaf' |
                        Should -Be $true
                }
            }

            Context -Name 'Configuration Settings' -Fixture {
                It -Name "should set: 'user.name' to the commit author" -Test {
                    git config --global --get 'user.name' |
                        Should -Be $Env:APPVEYOR_REPO_COMMIT_AUTHOR
                }

                It -Name "should set: 'user.email' to the commit author's email address" -Test {
                    git config --global --get 'user.email' |
                        Should -Be $Env:APPVEYOR_REPO_COMMIT_AUTHOR_EMAIL
                }

                It -Name "should set: 'credential.helper' to 'store'" -Test {
                    git config --global --get 'credential.helper' |
                        Should -Be 'store'
                }

                It -Name "should set: 'core.autocrlf' to 'true'" -Test {
                    git config --global --get 'core.autocrlf' |
                        Should -Be 'true'
                }

                It -Name "should set: 'core.safecrlf' to 'false'" -Test {
                    git config --global --get 'core.safecrlf' |
                        Should -Be 'false'
                }
            }
        }
    }
}
