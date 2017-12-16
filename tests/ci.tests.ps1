#Import-Module -Name './Armor/Armor.psm1'

if ( $env:CI -eq $true ) {

    Describe 'CI Build Configuration' {

        Context 'Environment Variables : CI Abstraction' {

            It 'set $env:CI_BUILD_PATH to a directory that exists' {
                {
                    Test-Path -Path $env:CI_BUILD_PATH -PathType 'Container' 
                } |
                    Should -Be $true
            }

            It 'set $env:CI_MODULE_NAME to "Armor"' {
                $env:CI_MODULE_NAME |
                    Should -Be 'Armor'
            }

            It 'set $env:CI_MODULE_PATH to "${env:CI_BUILD_PATH}/${env:CI_MODULE_NAME}"' {
                $env:CI_MODULE_PATH |
                    Should -Be ( Join-Path -Path $env:CI_BUILD_PATH -ChildPath $env:CI_MODULE_NAME )
            }

            It 'set $env:CI_MODULE_PATH to a directory that exists' {
                {
                    Test-Path -Path $env:CI_MODULE_PATH -PathType 'Container'
                } |
                    Should -Be $true
            }

            It 'set $env:CI_MODULE_PATH to a directory that contains a valid module manifest' {
                {
                    Join-Path -Path $env:CI_MODULE_PATH -ChildPath "${env:CI_MODULE_NAME}.psd1" |
                        Test-ModuleManifest
                } |
                    Should -Be $true
            }

            It 'set $env:CI_MODULE_VERSION to the same version in the module manifest' {
                $env:CI_MODULE_VERSION |
                    Should -Be ( Join-Path -Path $env:CI_MODULE_PATH -ChildPath "${env:CI_MODULE_NAME}.psd1" | Test-ModuleManifest ).Version.ToString()
            }

            It 'set $env:CI_OWNER_NAME to "tlindsay42"' {
                $env:CI_OWNER_NAME |
                    Should -Be 'tlindsay42'
            }

            It 'set $env:CI_PROJECT_NAME correctly' {
                $env:CI_PROJECT_NAME |
                    Should -Be ( Split-Path -Path $env:CI_BUILD_PATH -Leaf )
            }

            It 'set $env:CI_NAME to either "AppVeyor" or "Travis CI"' {
                $env:CI_NAME |
                    Should -BeIn 'AppVeyor', 'Travis CI'
            }

            It 'set $env:CI_BUILD_NUMBER to a number' {
                $env:CI_BUILD_NUMBER |
                    Should -Match '^\d+$'
            }

            It 'set $env:CI_BUILD_URL to a URL that exists' {
                ( Invoke-WebRequest -Method 'Get' -Uri $env:CI_BUILD_URL ).StatusCode |
                    Should -Be 200
            }

            It 'set $env:CI_BRANCH' {
                $env:CI_BRANCH |
                    Should -Not -BeNullOrEmpty
            }

            if ( $env:CI_PULL_REQUEST -ne $null ) {
                It 'set $env:CI_PULL_REQUEST' {
                    $env:CI_PULL_REQUEST |
                        Should -Not -BeNullOrEmpty
                    $env:CI_PULL_REQUEST |
                        Should -Match
                }
            }
        }
    }
}